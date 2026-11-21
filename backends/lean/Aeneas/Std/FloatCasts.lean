module
public import Aeneas.Std.Scalar.Core
public section

/-!
# Numeric casts (`as`) to and from floats

The semantics follow the Rust reference
(https://doc.rust-lang.org/reference/expressions/operator-expr.html#numeric-cast):
- float to integer rounds toward zero, sends NaN to `0`, and saturates at the integer type's
  bounds;
- integer to float rounds to the nearest float (ties to even); overflow gives an infinity;
- `f32` to `f64` is exact for numbers, and `f64` to `f32` rounds to the nearest `f32` (ties to
  even).

For integer types up to 64 bits (and `usize`/`isize`), the casts use Lean's built-in conversions
(`Float.toUInt32`, `Int64.toFloat`, ...). These run as native code and are defined through Lean's
logical float model, so they can be reasoned about.

Lean's own `Float.toFloat32` and `Float32.toFloat` are `opaque`, so `f64 <-> f32` casts are
defined here through the logical float model, and compiled code runs Lean's native conversions
instead (`implemented_by`). This is the same arrangement as Lean's own `@[extern]` float
operations (a logical definition, with native code at run time). In the model a NaN gives
Lean's standard positive NaN, dropping its sign and payload; native code may keep them (Rust leaves
the NaN result of a cast unspecified).

Lean has no conversions for 128-bit integers, so those casts are computed through the logical
float model, which can be reasoned about but runs as ordinary (slower) Lean code.
-/

namespace Aeneas.Std

namespace FloatCasts

open Float.Model

/-- Round an unpacked float to the given format (exact if it is representable). -/
@[expose] def roundToFormat (spec : Format) : UnpackedFloat → UnpackedFloat
  | .finite s m e _ => UnpackedFloat.round spec s m e
  | u => u

/-- Rust's float-to-integer rule on an unpacked float: truncate toward zero, NaN to `0`, and
saturate to `[lo, hi]` (infinities included). -/
@[expose] def toIntSat (lo hi : Int) (u : UnpackedFloat) : Int :=
  max lo (min hi (u.toInt lo hi))

/-- Float-to-`u128` on an unpacked float. The bounds are written out (they equal
`UScalar.max .U128`, which is irreducible) so that the cast computes by `decide` and `rfl`. -/
@[expose] def toU128 (u : UnpackedFloat) : UScalar .U128 :=
  ⟨BitVec.ofInt 128 (toIntSat 0 (2 ^ 128 - 1) u)⟩

/-- Float-to-`i128` on an unpacked float; bounds as for `toU128`. -/
@[expose] def toI128 (u : UnpackedFloat) : IScalar .I128 :=
  ⟨BitVec.ofInt 128 (toIntSat (-2 ^ 127) (2 ^ 127 - 1) u)⟩

/-- The model of `f64 -> f32`: round to the nearest `f32`. -/
@[expose] def castToFloat32Model (x : Float) : Float32 :=
  Float32.ofModel (Float32.Model.pack (roundToFormat .binary32 x.toModel.unpack))

/-- The model of `f32 -> f64` (exact for numbers). -/
@[expose] def castToFloatModel (x : Float32) : Float :=
  Float.ofModel (Float.Model.pack (roundToFormat .binary64 x.toModel.unpack))

end FloatCasts

open FloatCasts

/-- `x as f32` for `x : f64`. Compiled code runs Lean's native `Float.toFloat32`. -/
@[expose, implemented_by Float.toFloat32, step_pure_def]
def Float.castToFloat32 (x : Float) : Float32 := castToFloat32Model x

/-- `x as f64` for `x : f32`. Compiled code runs Lean's native `Float32.toFloat`. -/
@[expose, implemented_by Float32.toFloat, step_pure_def]
def Float32.castToFloat (x : Float32) : Float := castToFloatModel x

/-- `x as uN` / `x as usize` for `x : f64`. -/
@[expose, step_pure_def] def Float.toUScalar (ty : UScalarTy) (x : Float) : UScalar ty :=
  match ty with
  | .U8 => ⟨x.toUInt8.toBitVec⟩
  | .U16 => ⟨x.toUInt16.toBitVec⟩
  | .U32 => ⟨x.toUInt32.toBitVec⟩
  | .U64 => ⟨x.toUInt64.toBitVec⟩
  | .Usize => ⟨x.toUSize.toBitVec⟩
  | .U128 => toU128 x.toModel.unpack

/-- `x as iN` / `x as isize` for `x : f64`. -/
@[expose, step_pure_def] def Float.toIScalar (ty : IScalarTy) (x : Float) : IScalar ty :=
  match ty with
  | .I8 => ⟨x.toInt8.toBitVec⟩
  | .I16 => ⟨x.toInt16.toBitVec⟩
  | .I32 => ⟨x.toInt32.toBitVec⟩
  | .I64 => ⟨x.toInt64.toBitVec⟩
  | .Isize => ⟨x.toISize.toBitVec⟩
  | .I128 => toI128 x.toModel.unpack

/-- `x as uN` / `x as usize` for `x : f32`. -/
@[expose, step_pure_def] def Float32.toUScalar (ty : UScalarTy) (x : Float32) : UScalar ty :=
  match ty with
  | .U8 => ⟨x.toUInt8.toBitVec⟩
  | .U16 => ⟨x.toUInt16.toBitVec⟩
  | .U32 => ⟨x.toUInt32.toBitVec⟩
  | .U64 => ⟨x.toUInt64.toBitVec⟩
  | .Usize => ⟨x.toUSize.toBitVec⟩
  | .U128 => toU128 x.toModel.unpack

/-- `x as iN` / `x as isize` for `x : f32`. -/
@[expose, step_pure_def] def Float32.toIScalar (ty : IScalarTy) (x : Float32) : IScalar ty :=
  match ty with
  | .I8 => ⟨x.toInt8.toBitVec⟩
  | .I16 => ⟨x.toInt16.toBitVec⟩
  | .I32 => ⟨x.toInt32.toBitVec⟩
  | .I64 => ⟨x.toInt64.toBitVec⟩
  | .Isize => ⟨x.toISize.toBitVec⟩
  | .I128 => toI128 x.toModel.unpack

/-- `x as f64` for an unsigned integer `x`. -/
@[expose, step_pure_def] def UScalar.toFloat {ty : UScalarTy} (x : UScalar ty) : Float :=
  match ty, x with
  | .U8, x => (UInt8.ofBitVec x.bv).toFloat
  | .U16, x => (UInt16.ofBitVec x.bv).toFloat
  | .U32, x => (UInt32.ofBitVec x.bv).toFloat
  | .U64, x => (UInt64.ofBitVec x.bv).toFloat
  | .Usize, x => (USize.ofBitVec x.bv).toFloat
  | .U128, x => Float.ofModel (Float.Model.ofNat x.val)

/-- `x as f32` for an unsigned integer `x`. -/
@[expose, step_pure_def] def UScalar.toFloat32 {ty : UScalarTy} (x : UScalar ty) : Float32 :=
  match ty, x with
  | .U8, x => (UInt8.ofBitVec x.bv).toFloat32
  | .U16, x => (UInt16.ofBitVec x.bv).toFloat32
  | .U32, x => (UInt32.ofBitVec x.bv).toFloat32
  | .U64, x => (UInt64.ofBitVec x.bv).toFloat32
  | .Usize, x => (USize.ofBitVec x.bv).toFloat32
  | .U128, x => Float32.ofModel (Float32.Model.ofNat x.val)

/-- `x as f64` for a signed integer `x`. -/
@[expose, step_pure_def] def IScalar.toFloat {ty : IScalarTy} (x : IScalar ty) : Float :=
  match ty, x with
  | .I8, x => (Int8.ofBitVec x.bv).toFloat
  | .I16, x => (Int16.ofBitVec x.bv).toFloat
  | .I32, x => (Int32.ofBitVec x.bv).toFloat
  | .I64, x => (Int64.ofBitVec x.bv).toFloat
  | .Isize, x => (ISize.ofBitVec x.bv).toFloat
  | .I128, x => Float.ofModel (Float.Model.ofInt x.val)

/-- `x as f32` for a signed integer `x`. -/
@[expose, step_pure_def] def IScalar.toFloat32 {ty : IScalarTy} (x : IScalar ty) : Float32 :=
  match ty, x with
  | .I8, x => (Int8.ofBitVec x.bv).toFloat32
  | .I16, x => (Int16.ofBitVec x.bv).toFloat32
  | .I32, x => (Int32.ofBitVec x.bv).toFloat32
  | .I64, x => (Int64.ofBitVec x.bv).toFloat32
  | .Isize, x => (ISize.ofBitVec x.bv).toFloat32
  | .I128, x => Float32.ofModel (Float32.Model.ofInt x.val)

end Aeneas.Std
