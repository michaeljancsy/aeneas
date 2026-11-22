module
public import Aeneas.Std.Float
public import Aeneas.Std.Scalar.Core
public section

/-!
# Rounding to an integer, `min`, `max`, `clamp` and `mul_add` on floats

The semantics follow the Rust standard library documentation for `f64` and `f32`:
- `floor`, `ceil`, `trunc`, `round` (ties away from zero) and `round_ties_even` return NaN,
  infinities, zeros and values that are already integers unchanged; a zero result keeps the
  sign of the input (`(-0.5).ceil()` is `-0.0`);
- `fract(x)` is `x - x.trunc()`;
- `min` and `max` return the other argument when exactly one is NaN. When the arguments are zeros
  of opposite signs, Rust may return either one; the models return one of the two through
  `FloatRound.pickFirstZero`, an `opaque` constant, so a proof cannot depend on which (compiled
  code returns the second argument). Signalling NaNs cannot arise in translated code (there are
  no NaN literals), so they are treated like quiet ones;
- `clamp(x, lo, hi)` fails with an assertion failure (`massert`, as for integers) unless
  `lo <= hi` (so also when `lo` or `hi` is NaN), and otherwise
  follows Rust's source: `if x < lo { x = lo }; if x > hi { x = hi }; x`;
- `mul_add` is the fused multiply-add with a single rounding (Lean's `Float.fma`).

Every definition goes through Lean's logical float model; Lean's own `Float.floor`, `Float.ceil`
and `Float.round` are `opaque`. Compiled code (`#eval`, `#guard`) also runs these definitions,
except `mul_add`, which uses Lean's `Float.fma`. NaN payloads are not preserved.
-/

namespace Aeneas.Std

namespace FloatRound

open Float.Model

/-- The direction in which `roundToIntegral` rounds. -/
inductive IntegralRounding where
  /-- Toward zero (`trunc`). -/
  | towardZero
  /-- Toward negative infinity (`floor`). -/
  | down
  /-- Toward positive infinity (`ceil`). -/
  | up
  /-- To the nearest integer, ties away from zero (`round`). -/
  | nearestTiesAway
  /-- To the nearest integer, ties to even (`round_ties_even`). -/
  | nearestTiesEven

/-- Round an unpacked float to an integral value of the given format, in the given direction.
NaN, infinities, zeros and integers are returned unchanged, and a zero result keeps the input's
sign. -/
@[expose] def roundToIntegral (spec : Format) (mode : IntegralRounding) :
    UnpackedFloat → UnpackedFloat
  | u@(.finite s m e _) =>
    if 0 ≤ e then u
    else
      -- `|u| = m / 2^k`: `q` is its integer part and `r / 2^k` its fractional part
      let k := (-e).toNat
      let q := m / 2 ^ k
      let r := m % 2 ^ k
      let roundUp : Bool :=
        match mode with
        | .towardZero => false
        | .down => s == .negative && r != 0
        | .up => s == .positive && r != 0
        | .nearestTiesAway => 2 ^ k ≤ 2 * r
        | .nearestTiesEven => 2 ^ k < 2 * r || (2 * r == 2 ^ k && q % 2 == 1)
      let n := if roundUp then q + 1 else q
      if n = 0 then .zero s else UnpackedFloat.round spec s n 0
  | u => u

/-- Whether `min` and `max` return their first argument when given zeros of opposite signs. Rust
leaves this unspecified, so it is `opaque`: proofs cannot depend on its value. Compiled code uses
`false`. -/
opaque pickFirstZero : Bool

/-- Rust's `min` on unpacked floats in canonical form for a common format: if one argument is
NaN, the other is returned; for zeros of opposite signs, see `pickFirstZero`. -/
@[expose] def minNum : UnpackedFloat → UnpackedFloat → UnpackedFloat
  | .notANumber, y => y
  | x, .notANumber => x
  | .zero s₁, .zero s₂ => if s₁ == s₂ || pickFirstZero then .zero s₁ else .zero s₂
  | x, y => if y.lt x then y else x

/-- Rust's `max` on unpacked floats in canonical form for a common format: if one argument is
NaN, the other is returned; for zeros of opposite signs, see `pickFirstZero`. -/
@[expose] def maxNum : UnpackedFloat → UnpackedFloat → UnpackedFloat
  | .notANumber, y => y
  | x, .notANumber => x
  | .zero s₁, .zero s₂ => if s₁ == s₂ || pickFirstZero then .zero s₁ else .zero s₂
  | x, y => if x.lt y then y else x

end FloatRound

open FloatRound (IntegralRounding)

/-- Round an `f64` to an integral value in the given direction. -/
@[expose] def Float.roundToIntegral (mode : IntegralRounding) (x : Float) : Float :=
  Float.ofModel (Float.Model.pack (FloatRound.roundToIntegral .binary64 mode x.toModel.unpack))

/-- Round an `f32` to an integral value in the given direction. -/
@[expose] def Float32.roundToIntegral (mode : IntegralRounding) (x : Float32) : Float32 :=
  Float32.ofModel
    (Float32.Model.pack (FloatRound.roundToIntegral .binary32 mode x.toModel.unpack))

/-! ### binary64 (`f64`) -/

/-- `x.floor()` for `x : f64`. -/
@[expose, step_pure_def, rust_fun "std::f64::{f64}::floor" -canFail]
def std.f64.floor (x : Float) : Float := Float.roundToIntegral .down x

/-- `x.ceil()` for `x : f64`. -/
@[expose, step_pure_def, rust_fun "std::f64::{f64}::ceil" -canFail]
def std.f64.ceil (x : Float) : Float := Float.roundToIntegral .up x

/-- `x.trunc()` for `x : f64`. -/
@[expose, step_pure_def, rust_fun "std::f64::{f64}::trunc" -canFail]
def std.f64.trunc (x : Float) : Float := Float.roundToIntegral .towardZero x

/-- `x.round()` for `x : f64` (ties away from zero). -/
@[expose, step_pure_def, rust_fun "std::f64::{f64}::round" -canFail]
def std.f64.round (x : Float) : Float := Float.roundToIntegral .nearestTiesAway x

/-- `x.round_ties_even()` for `x : f64`. -/
@[expose, step_pure_def, rust_fun "std::f64::{f64}::round_ties_even" -canFail]
def std.f64.round_ties_even (x : Float) : Float := Float.roundToIntegral .nearestTiesEven x

/-- `x.fract()` for `x : f64`: `x - x.trunc()`. -/
@[expose, step_pure_def, rust_fun "std::f64::{f64}::fract" -canFail]
def std.f64.fract (x : Float) : Float := x - std.f64.trunc x

/-- `x.min(y)` for `x y : f64`. -/
@[expose, step_pure_def, rust_fun "core::f64::{f64}::min" -canFail]
def core.f64.min (x y : Float) : Float :=
  Float.ofModel (Float.Model.pack (FloatRound.minNum x.toModel.unpack y.toModel.unpack))

/-- `x.max(y)` for `x y : f64`. -/
@[expose, step_pure_def, rust_fun "core::f64::{f64}::max" -canFail]
def core.f64.max (x y : Float) : Float :=
  Float.ofModel (Float.Model.pack (FloatRound.maxNum x.toModel.unpack y.toModel.unpack))

/-- `x.clamp(lo, hi)` for `x lo hi : f64`: fails unless `lo <= hi`, like Rust's `assert!`. -/
@[expose, rust_fun "core::f64::{f64}::clamp"]
def core.f64.clamp (x lo hi : Float) : Result Float := do
  massert (lo ≤ hi)
  let x := if x < lo then lo else x
  .ok (if hi < x then hi else x)

/-- `x.mul_add(a, b)` for `x a b : f64`: `x * a + b` with a single rounding. -/
@[expose, step_pure_def, rust_fun "std::f64::{f64}::mul_add" -canFail]
def std.f64.mul_add (x a b : Float) : Float := x.fma a b

/-! ### binary32 (`f32`) -/

/-- `x.floor()` for `x : f32`. -/
@[expose, step_pure_def, rust_fun "std::f32::{f32}::floor" -canFail]
def std.f32.floor (x : Float32) : Float32 := Float32.roundToIntegral .down x

/-- `x.ceil()` for `x : f32`. -/
@[expose, step_pure_def, rust_fun "std::f32::{f32}::ceil" -canFail]
def std.f32.ceil (x : Float32) : Float32 := Float32.roundToIntegral .up x

/-- `x.trunc()` for `x : f32`. -/
@[expose, step_pure_def, rust_fun "std::f32::{f32}::trunc" -canFail]
def std.f32.trunc (x : Float32) : Float32 := Float32.roundToIntegral .towardZero x

/-- `x.round()` for `x : f32` (ties away from zero). -/
@[expose, step_pure_def, rust_fun "std::f32::{f32}::round" -canFail]
def std.f32.round (x : Float32) : Float32 := Float32.roundToIntegral .nearestTiesAway x

/-- `x.round_ties_even()` for `x : f32`. -/
@[expose, step_pure_def, rust_fun "std::f32::{f32}::round_ties_even" -canFail]
def std.f32.round_ties_even (x : Float32) : Float32 := Float32.roundToIntegral .nearestTiesEven x

/-- `x.fract()` for `x : f32`: `x - x.trunc()`. -/
@[expose, step_pure_def, rust_fun "std::f32::{f32}::fract" -canFail]
def std.f32.fract (x : Float32) : Float32 := x - std.f32.trunc x

/-- `x.min(y)` for `x y : f32`. -/
@[expose, step_pure_def, rust_fun "core::f32::{f32}::min" -canFail]
def core.f32.min (x y : Float32) : Float32 :=
  Float32.ofModel (Float32.Model.pack (FloatRound.minNum x.toModel.unpack y.toModel.unpack))

/-- `x.max(y)` for `x y : f32`. -/
@[expose, step_pure_def, rust_fun "core::f32::{f32}::max" -canFail]
def core.f32.max (x y : Float32) : Float32 :=
  Float32.ofModel (Float32.Model.pack (FloatRound.maxNum x.toModel.unpack y.toModel.unpack))

/-- `x.clamp(lo, hi)` for `x lo hi : f32`: fails unless `lo <= hi`, like Rust's `assert!`. -/
@[expose, rust_fun "core::f32::{f32}::clamp"]
def core.f32.clamp (x lo hi : Float32) : Result Float32 := do
  massert (lo ≤ hi)
  let x := if x < lo then lo else x
  .ok (if hi < x then hi else x)

/-- `x.mul_add(a, b)` for `x a b : f32`: `x * a + b` with a single rounding. -/
@[expose, step_pure_def, rust_fun "std::f32::{f32}::mul_add" -canFail]
def std.f32.mul_add (x a b : Float32) : Float32 := x.fma a b

end Aeneas.Std
