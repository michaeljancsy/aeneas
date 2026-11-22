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
(`0x7FC00000` for `f32`, `0x7FF8000000000000` for `f64`, the bits of Rust's `NAN`). Rust keeps
the sign and payload of a NaN. So, on a NaN, the models differ from Rust as follows:
- `to_bits` returns the canonical NaN; Rust returns the NaN's own bits;
- `from_bits` of a NaN bit pattern gives the canonical NaN;
- `is_sign_negative` is `false` (and `is_sign_positive` is `true`); Rust reads the NaN's sign bit;
- `copysign x y` with a NaN `x` returns the canonical NaN; Rust returns a NaN with the sign of
  `y`. With a NaN `y`, the sign used is the canonical NaN's, which is positive;
- `recip` of a NaN is the canonical NaN; Rust does not specify the payload.

Everywhere else (every non-NaN input, and `signum`, `is_nan`, `is_infinite`, `is_normal`,
`is_subnormal` on every input) the models agree with Rust bit for bit.

Lean's compiled `toBits` and `ofBits` canonicalise NaNs in the same way, so compiled code
(`#eval`, `#guard`) computes the same results as the logical model.
-/
namespace Aeneas.Std

/-! ## binary64 (`f64`) -/

@[expose, rust_fun "core::f64::{f64}::to_bits" -canFail]
def core.f64.to_bits (x : Float) : U64 := ⟨x.toBits.toBitVec⟩

@[expose, rust_fun "core::f64::{f64}::from_bits" -canFail]
def core.f64.from_bits (v : U64) : Float := Float.ofBits (UInt64.ofBitVec v.bv)

@[expose, rust_fun "core::f64::{f64}::is_nan" -canFail]
def core.f64.is_nan (x : Float) : Bool := x.isNaN

@[expose, rust_fun "core::f64::{f64}::is_infinite" -canFail]
def core.f64.is_infinite (x : Float) : Bool := x.isInf

@[expose, rust_fun "core::f64::{f64}::is_sign_negative" -canFail]
def core.f64.is_sign_negative (x : Float) : Bool := x.toBits >>> 63 == 1

@[expose, rust_fun "core::f64::{f64}::is_sign_positive" -canFail]
def core.f64.is_sign_positive (x : Float) : Bool := !core.f64.is_sign_negative x

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

/-- The magnitude of `x` with the sign bit of `sign`. -/
@[expose, rust_fun "core::f64::{f64}::copysign" -canFail]
def core.f64.copysign (x sign : Float) : Float :=
  Float.ofBits ((x.toBits &&& 0x7FFFFFFFFFFFFFFF) ||| (sign.toBits &&& 0x8000000000000000))

/-- `1.0` with the sign of `x`, or NaN if `x` is NaN. -/
@[expose, rust_fun "core::f64::{f64}::signum" -canFail]
def core.f64.signum (x : Float) : Float :=
  if x.isNaN then Float.nan else core.f64.copysign (Float.ofBits 0x3FF0000000000000) x

/-- `1.0 / x`. -/
@[expose, rust_fun "core::f64::{f64}::recip" -canFail]
def core.f64.recip (x : Float) : Float := Float.ofBits 0x3FF0000000000000 / x

/-! ## binary32 (`f32`) -/

@[expose, rust_fun "core::f32::{f32}::to_bits" -canFail]
def core.f32.to_bits (x : Float32) : U32 := ⟨x.toBits.toBitVec⟩

@[expose, rust_fun "core::f32::{f32}::from_bits" -canFail]
def core.f32.from_bits (v : U32) : Float32 := Float32.ofBits (UInt32.ofBitVec v.bv)

@[expose, rust_fun "core::f32::{f32}::is_nan" -canFail]
def core.f32.is_nan (x : Float32) : Bool := x.isNaN

@[expose, rust_fun "core::f32::{f32}::is_infinite" -canFail]
def core.f32.is_infinite (x : Float32) : Bool := x.isInf

@[expose, rust_fun "core::f32::{f32}::is_sign_negative" -canFail]
def core.f32.is_sign_negative (x : Float32) : Bool := x.toBits >>> 31 == 1

@[expose, rust_fun "core::f32::{f32}::is_sign_positive" -canFail]
def core.f32.is_sign_positive (x : Float32) : Bool := !core.f32.is_sign_negative x

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

/-- The magnitude of `x` with the sign bit of `sign`. -/
@[expose, rust_fun "core::f32::{f32}::copysign" -canFail]
def core.f32.copysign (x sign : Float32) : Float32 :=
  Float32.ofBits ((x.toBits &&& 0x7FFFFFFF) ||| (sign.toBits &&& 0x80000000))

/-- `1.0` with the sign of `x`, or NaN if `x` is NaN. -/
@[expose, rust_fun "core::f32::{f32}::signum" -canFail]
def core.f32.signum (x : Float32) : Float32 :=
  if x.isNaN then Float32.nan else core.f32.copysign (Float32.ofBits 0x3F800000) x

/-- `1.0 / x`. -/
@[expose, rust_fun "core::f32::{f32}::recip" -canFail]
def core.f32.recip (x : Float32) : Float32 := Float32.ofBits 0x3F800000 / x

end Aeneas.Std
