module
public import Aeneas.Std.Float
public import Aeneas.Std.Scalar.Core
public section

/-!
# Float bits, classification and sign

Models of Rust's `to_bits`, `from_bits`, `is_nan`, `is_infinite`, `is_sign_positive`,
`is_sign_negative`, `is_normal`, `is_subnormal`, `signum`, `copysign` and `recip` for `f32`
(`Float32`) and `f64` (`Float`). They follow the definitions in Rust's `core`, which work on the
bit pattern, and are built on Lean's logical float model.

## NaN

Lean's logical model has a single NaN: the canonical quiet NaN with a clear sign bit
(`0x7FC00000` for `f32`, `0x7FF8000000000000` for `f64`, the bits of Rust's `NAN`). All NaNs are
equal in Lean's logic. Rust keeps the sign and payload of a NaN, and does not fix which NaN an
operation returns. So anything that reads a NaN's sign or bits fails in the model
(`fail .undef`):
- `to_bits`, `is_sign_negative` and `is_sign_positive` on a NaN;
- `copysign x sign` when its `sign` argument is a NaN.

A proof that a function returns `ok` therefore also shows that it never reads a NaN's sign or
bits. Giving these functions any fixed answer on a NaN instead (even an unknown one) would let a
proof state false facts about Rust: for a NaN `a`, Rust guarantees that
`(-a).is_sign_negative() != a.is_sign_negative()`, but in Lean `-a = a`.

Any operation added to these models in the future that reads a NaN's sign or bits (for example
`total_cmp`, `to_le_bytes`, `to_be_bytes`, `to_ne_bytes`, or a model of `NAN`) must follow the
same rule: it fails with `fail .undef` on a NaN whose sign or bits it would read.

The other operations do not read a NaN's sign or bits, and are unchanged:
- `from_bits` of a NaN bit pattern gives the (single) NaN;
- `copysign x sign` with a NaN `x` and a non-NaN `sign` gives a NaN;
- `signum` and `recip` of a NaN give a NaN; Rust does not specify the payload;
- `is_nan`, `is_infinite`, `is_normal` and `is_subnormal` give Rust's answer on every input.

On every non-NaN input all the models agree with Rust bit for bit. The pure helpers `bitsOf`,
`signBit` and `copysignBits` give the bit-level results on every input (on a NaN they use the
canonical NaN); they are for stating specifications and are not the translation of any Rust
function.

Lean's compiled `toBits` and `ofBits` canonicalise NaNs in the same way, so compiled code
(`#eval`, `#guard`) computes the same results as the logical model.
-/
namespace Aeneas.Std

open Result WP

/-! ## binary64 (`f64`) -/

/-- The bits of an `f64` (pure helper, not a Rust function; see `to_bits`). On a NaN this uses
the canonical NaN's bits, which need not be Rust's. -/
@[expose] def core.f64.bitsOf (x : Float) : U64 := ⟨x.toBits.toBitVec⟩

/-- The sign bit of an `f64` (pure helper, not a Rust function; see `is_sign_negative`). On a
NaN this uses the canonical NaN's sign (positive), which need not be Rust's. -/
@[expose] def core.f64.signBit (x : Float) : Bool := x.toBits >>> 63 == 1

/-- The magnitude of `x` with the sign bit of `sign`, at the bit level (pure helper; see
`copysign`). When `sign` is a NaN, the canonical NaN's (positive) sign is used. -/
@[expose] def core.f64.copysignBits (x sign : Float) : Float :=
  Float.ofBits ((x.toBits &&& 0x7FFFFFFFFFFFFFFF) ||| (sign.toBits &&& 0x8000000000000000))

/-- The bits of `x`. Fails on a NaN (see the module docstring). -/
@[expose, rust_fun "core::f64::{f64}::to_bits"]
def core.f64.to_bits (x : Float) : Result U64 :=
  if x.isNaN then .fail .undef else .ok (core.f64.bitsOf x)

@[expose, rust_fun "core::f64::{f64}::from_bits" -canFail]
def core.f64.from_bits (v : U64) : Float := Float.ofBits (UInt64.ofBitVec v.bv)

@[expose, rust_fun "core::f64::{f64}::is_nan" -canFail]
def core.f64.is_nan (x : Float) : Bool := x.isNaN

@[expose, rust_fun "core::f64::{f64}::is_infinite" -canFail]
def core.f64.is_infinite (x : Float) : Bool := x.isInf

/-- Whether the sign bit of `x` is set. Fails on a NaN (see the module docstring). -/
@[expose, rust_fun "core::f64::{f64}::is_sign_negative"]
def core.f64.is_sign_negative (x : Float) : Result Bool :=
  if x.isNaN then .fail .undef else .ok (core.f64.signBit x)

/-- Whether the sign bit of `x` is clear. Fails on a NaN (see the module docstring). -/
@[expose, rust_fun "core::f64::{f64}::is_sign_positive"]
def core.f64.is_sign_positive (x : Float) : Result Bool :=
  if x.isNaN then .fail .undef else .ok (!core.f64.signBit x)

/-- Normal: the exponent field is neither all zeros nor all ones. -/
@[expose, rust_fun "core::f64::{f64}::is_normal" -canFail]
def core.f64.is_normal (x : Float) : Bool :=
  let e := (x.toBits >>> 52) &&& 0x7FF
  e != 0 && e != 0x7FF

/-- Subnormal: the exponent field is all zeros and the mantissa is not zero. -/
@[expose, rust_fun "core::f64::{f64}::is_subnormal" -canFail]
def core.f64.is_subnormal (x : Float) : Bool :=
  let b := x.toBits
  (b >>> 52) &&& 0x7FF == 0 && b &&& 0x000FFFFFFFFFFFFF != 0

/-- The magnitude of `x` with the sign bit of `sign`. Fails when `sign` is a NaN (see the module
docstring). -/
@[expose, rust_fun "core::f64::{f64}::copysign"]
def core.f64.copysign (x sign : Float) : Result Float :=
  if sign.isNaN then .fail .undef else .ok (core.f64.copysignBits x sign)

/-- `1.0` with the sign of `x`, or NaN if `x` is NaN. -/
@[expose, rust_fun "core::f64::{f64}::signum" -canFail]
def core.f64.signum (x : Float) : Float :=
  if x.isNaN then Float.nan else core.f64.copysignBits (Float.ofBits 0x3FF0000000000000) x

/-- `1.0 / x`. -/
@[expose, rust_fun "core::f64::{f64}::recip" -canFail]
def core.f64.recip (x : Float) : Float := Float.ofBits 0x3FF0000000000000 / x

@[step] theorem core.f64.to_bits_spec (x : Float) (h : x.isNaN = false) :
    core.f64.to_bits x ⦃ b => b = core.f64.bitsOf x ⦄ := by
  simp [core.f64.to_bits, h]

@[step] theorem core.f64.is_sign_negative_spec (x : Float) (h : x.isNaN = false) :
    core.f64.is_sign_negative x ⦃ s => s = core.f64.signBit x ⦄ := by
  simp [core.f64.is_sign_negative, h]

@[step] theorem core.f64.is_sign_positive_spec (x : Float) (h : x.isNaN = false) :
    core.f64.is_sign_positive x ⦃ s => s = !core.f64.signBit x ⦄ := by
  simp [core.f64.is_sign_positive, h]

@[step] theorem core.f64.copysign_spec (x sign : Float) (h : sign.isNaN = false) :
    core.f64.copysign x sign ⦃ y => y = core.f64.copysignBits x sign ⦄ := by
  simp [core.f64.copysign, h]

theorem core.f64.to_bits_nan (x : Float) (h : x.isNaN = true) :
    core.f64.to_bits x = .fail .undef := by
  simp [core.f64.to_bits, h]

theorem core.f64.is_sign_negative_nan (x : Float) (h : x.isNaN = true) :
    core.f64.is_sign_negative x = .fail .undef := by
  simp [core.f64.is_sign_negative, h]

theorem core.f64.is_sign_positive_nan (x : Float) (h : x.isNaN = true) :
    core.f64.is_sign_positive x = .fail .undef := by
  simp [core.f64.is_sign_positive, h]

theorem core.f64.copysign_nan (x sign : Float) (h : sign.isNaN = true) :
    core.f64.copysign x sign = .fail .undef := by
  simp [core.f64.copysign, h]

/-! ## binary32 (`f32`) -/

/-- The bits of an `f32` (pure helper, not a Rust function; see `to_bits`). On a NaN this uses
the canonical NaN's bits, which need not be Rust's. -/
@[expose] def core.f32.bitsOf (x : Float32) : U32 := ⟨x.toBits.toBitVec⟩

/-- The sign bit of an `f32` (pure helper, not a Rust function; see `is_sign_negative`). On a
NaN this uses the canonical NaN's sign (positive), which need not be Rust's. -/
@[expose] def core.f32.signBit (x : Float32) : Bool := x.toBits >>> 31 == 1

/-- The magnitude of `x` with the sign bit of `sign`, at the bit level (pure helper; see
`copysign`). When `sign` is a NaN, the canonical NaN's (positive) sign is used. -/
@[expose] def core.f32.copysignBits (x sign : Float32) : Float32 :=
  Float32.ofBits ((x.toBits &&& 0x7FFFFFFF) ||| (sign.toBits &&& 0x80000000))

/-- The bits of `x`. Fails on a NaN (see the module docstring). -/
@[expose, rust_fun "core::f32::{f32}::to_bits"]
def core.f32.to_bits (x : Float32) : Result U32 :=
  if x.isNaN then .fail .undef else .ok (core.f32.bitsOf x)

@[expose, rust_fun "core::f32::{f32}::from_bits" -canFail]
def core.f32.from_bits (v : U32) : Float32 := Float32.ofBits (UInt32.ofBitVec v.bv)

@[expose, rust_fun "core::f32::{f32}::is_nan" -canFail]
def core.f32.is_nan (x : Float32) : Bool := x.isNaN

@[expose, rust_fun "core::f32::{f32}::is_infinite" -canFail]
def core.f32.is_infinite (x : Float32) : Bool := x.isInf

/-- Whether the sign bit of `x` is set. Fails on a NaN (see the module docstring). -/
@[expose, rust_fun "core::f32::{f32}::is_sign_negative"]
def core.f32.is_sign_negative (x : Float32) : Result Bool :=
  if x.isNaN then .fail .undef else .ok (core.f32.signBit x)

/-- Whether the sign bit of `x` is clear. Fails on a NaN (see the module docstring). -/
@[expose, rust_fun "core::f32::{f32}::is_sign_positive"]
def core.f32.is_sign_positive (x : Float32) : Result Bool :=
  if x.isNaN then .fail .undef else .ok (!core.f32.signBit x)

/-- Normal: the exponent field is neither all zeros nor all ones. -/
@[expose, rust_fun "core::f32::{f32}::is_normal" -canFail]
def core.f32.is_normal (x : Float32) : Bool :=
  let e := (x.toBits >>> 23) &&& 0xFF
  e != 0 && e != 0xFF

/-- Subnormal: the exponent field is all zeros and the mantissa is not zero. -/
@[expose, rust_fun "core::f32::{f32}::is_subnormal" -canFail]
def core.f32.is_subnormal (x : Float32) : Bool :=
  let b := x.toBits
  (b >>> 23) &&& 0xFF == 0 && b &&& 0x007FFFFF != 0

/-- The magnitude of `x` with the sign bit of `sign`. Fails when `sign` is a NaN (see the module
docstring). -/
@[expose, rust_fun "core::f32::{f32}::copysign"]
def core.f32.copysign (x sign : Float32) : Result Float32 :=
  if sign.isNaN then .fail .undef else .ok (core.f32.copysignBits x sign)

/-- `1.0` with the sign of `x`, or NaN if `x` is NaN. -/
@[expose, rust_fun "core::f32::{f32}::signum" -canFail]
def core.f32.signum (x : Float32) : Float32 :=
  if x.isNaN then Float32.nan else core.f32.copysignBits (Float32.ofBits 0x3F800000) x

/-- `1.0 / x`. -/
@[expose, rust_fun "core::f32::{f32}::recip" -canFail]
def core.f32.recip (x : Float32) : Float32 := Float32.ofBits 0x3F800000 / x

@[step] theorem core.f32.to_bits_spec (x : Float32) (h : x.isNaN = false) :
    core.f32.to_bits x ⦃ b => b = core.f32.bitsOf x ⦄ := by
  simp [core.f32.to_bits, h]

@[step] theorem core.f32.is_sign_negative_spec (x : Float32) (h : x.isNaN = false) :
    core.f32.is_sign_negative x ⦃ s => s = core.f32.signBit x ⦄ := by
  simp [core.f32.is_sign_negative, h]

@[step] theorem core.f32.is_sign_positive_spec (x : Float32) (h : x.isNaN = false) :
    core.f32.is_sign_positive x ⦃ s => s = !core.f32.signBit x ⦄ := by
  simp [core.f32.is_sign_positive, h]

@[step] theorem core.f32.copysign_spec (x sign : Float32) (h : sign.isNaN = false) :
    core.f32.copysign x sign ⦃ y => y = core.f32.copysignBits x sign ⦄ := by
  simp [core.f32.copysign, h]

theorem core.f32.to_bits_nan (x : Float32) (h : x.isNaN = true) :
    core.f32.to_bits x = .fail .undef := by
  simp [core.f32.to_bits, h]

theorem core.f32.is_sign_negative_nan (x : Float32) (h : x.isNaN = true) :
    core.f32.is_sign_negative x = .fail .undef := by
  simp [core.f32.is_sign_negative, h]

theorem core.f32.is_sign_positive_nan (x : Float32) (h : x.isNaN = true) :
    core.f32.is_sign_positive x = .fail .undef := by
  simp [core.f32.is_sign_positive, h]

theorem core.f32.copysign_nan (x sign : Float32) (h : sign.isNaN = true) :
    core.f32.copysign x sign = .fail .undef := by
  simp [core.f32.copysign, h]

end Aeneas.Std
