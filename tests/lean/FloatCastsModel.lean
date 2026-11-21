import Aeneas.Std.FloatCasts

/-! Cross-checks for the float casts in `Aeneas.Std.FloatCasts`.

Casts for integer types up to 64 bits use Lean's built-in conversions directly. The others are
computed through Lean's logical float model:
- `f64 <-> f32`, because Lean's own `Float.toFloat32` and `Float32.toFloat` are opaque;
- 128-bit integers, which Lean has no conversions for.

This file checks those model-based casts against Lean's native conversions, on special values and
pseudo-random words:
- `f64 <-> f32` against the opaque native conversions;
- the 128-bit casts against the native 64-bit ones, on values that both can represent.

It is not a `module`: `#guard` must run the definitions of `Aeneas.Std` as compiled code. -/

set_option autoImplicit false

open Aeneas.Std

/-- Pseudo-random 64-bit words (xorshift). -/
def nextWord (s : UInt64) : UInt64 :=
  let s := s ^^^ (s <<< 13)
  let s := s ^^^ (s >>> 7)
  s ^^^ (s <<< 17)

/-- Zeros, subnormals, powers of two, the largest finite value, infinities, NaN, and values on
and next to binary32 rounding boundaries and the binary32 overflow threshold. -/
def special64 : List UInt64 :=
  [0, 0x8000000000000000, 1, 0x000FFFFFFFFFFFFF, 0x0010000000000000, 0x7FEFFFFFFFFFFFFF,
   0x7FF0000000000000, 0xFFF0000000000000, 0x7FF8000000000000, 0x47EFFFFFE0000000,
   0x47EFFFFFF0000000, 0x47EFFFFFEFFFFFFF, 0x3690000000000000, 0x36A0000000000000,
   0x3810000000000000, 0x380FFFFFFFFFFFFF, 0x3FF0000010000000, 0x3FF0000030000000,
   0x43DFFFFFFFFFFFFF, 0xC3E0000000000000, 0x43F0000000000000, 0xC3DFFFFFFFFFFFFF]

/-- `f64 -> f32` and `f32 -> f64` against Lean's native (opaque) conversions. -/
def checkFloatFloat (w : UInt64) : Bool :=
  let x := Float.ofBits w
  let y := Float32.ofBits w.toUInt32
  let ok64 :=
    if x.isNaN then (Float.castToFloat32 x).isNaN
    else (Float.castToFloat32 x).toBits == x.toFloat32.toBits
  let ok32 :=
    if y.isNaN then (Float32.castToFloat y).isNaN
    else (Float32.castToFloat y).toBits == y.toFloat.toBits
  ok64 && ok32

/-- `f64`/`f32 -> u128`/`i128` (model) against the native 64-bit conversions, on values whose
truncation fits in 64 bits. -/
def checkFloatTo128 (w : UInt64) : Bool :=
  let x := Float.ofBits w
  let y := Float32.ofBits w.toUInt32
  let fitsI64 (v : Float) := v.isNaN || (v.abs < 9223372036854775808.0)
  let fitsU64 (v : Float) := v.isNaN || (v < 18446744073709551616.0)
  (!fitsI64 x || (Float.toIScalar .I128 x).val == x.toInt64.toInt) &&
  (!fitsU64 x || (Float.toUScalar .U128 x).val == x.toUInt64.toNat) &&
  (!fitsI64 y.toFloat || (Float32.toIScalar .I128 y).val == y.toInt64.toInt) &&
  (!fitsU64 y.toFloat || (Float32.toUScalar .U128 y).val == y.toUInt64.toNat)

/-- `u128`/`i128 -> f64`/`f32` (model) against the native 64-bit conversions. -/
def check128ToFloat (w : UInt64) : Bool :=
  let u : UScalar .U128 := ⟨BitVec.ofNat 128 w.toNat⟩
  let i : IScalar .I128 := ⟨BitVec.ofInt 128 w.toInt64.toInt⟩
  (UScalar.toFloat u).toBits == w.toFloat.toBits &&
  (UScalar.toFloat32 u).toBits == w.toFloat32.toBits &&
  (IScalar.toFloat i).toBits == w.toInt64.toFloat.toBits &&
  (IScalar.toFloat32 i).toBits == w.toInt64.toFloat32.toBits

def checkAll (w : UInt64) : Bool :=
  checkFloatFloat w && checkFloatFloat (w >>> 32) && checkFloatTo128 w && check128ToFloat w

/-- Number of failing words among the special values and `n` pseudo-random ones. -/
def failures (n : Nat) : Nat := Id.run do
  let mut s : UInt64 := 0x9E3779B97F4A7C15
  let mut bad := (special64.filter (fun w => !checkAll w)).length
  for _ in [0:n] do
    s := nextWord s
    unless checkAll s do bad := bad + 1
  return bad

#guard failures 5000 == 0
