module
public import Aeneas.Std.Core.Core
public import Aeneas.Std.Core.Cmp
public import Aeneas.Std.Scalar.Core
public section

/-!
# Native binary32 and binary64 models

Rust `f32` is translated to Lean `Float32` and Rust `f64` to Lean `Float`. Each
primitive performs one native operation in the matching precision; exceptional
values are preserved. Callers implement their own rejection policy. NaN payload
selection remains a native primitive boundary.
-/
namespace Aeneas.Std

/-! ## binary64 (`f64`) -/

@[expose, rust_fun "core::f64::{f64}::is_finite" -canFail]
def core.f64.is_finite (x : Float) : Bool := x.isFinite

@[expose, rust_fun "core::f64::{f64}::abs" -canFail]
def core.f64.abs (x : Float) : Float := x.abs

@[expose, rust_fun "std::f64::{f64}::sqrt" -canFail]
def std.f64.sqrt (x : Float) : Float := x.sqrt

@[expose, rust_fun "core::clone::impls::{core::clone::Clone<f64>}::clone" -canFail]
def core.clone.impls.CloneF64.clone (x : Float) : Float := x

@[expose, reducible, rust_trait_impl "core::clone::Clone<f64>"]
def core.clone.CloneF64 : core.clone.Clone Float where
  clone := fun x => .ok x
  clone_from := fun _ x => .ok x

@[expose, reducible, rust_trait_impl "core::marker::Copy<f64>"]
def core.marker.CopyF64 : core.marker.Copy Float where
  cloneInst := core.clone.CloneF64

@[expose, rust_fun "core::cmp::impls::{core::cmp::PartialEq<f64, f64>}::eq" -canFail]
def core.cmp.impls.PartialEqF64.eq (x y : Float) : Bool := x == y

@[expose, rust_fun "core::cmp::impls::{core::cmp::PartialEq<f64, f64>}::ne" -canFail]
def core.cmp.impls.PartialEqF64.ne (x y : Float) : Bool := x != y

@[expose, reducible, rust_trait_impl "core::cmp::PartialEq<f64, f64>"]
def core.cmp.PartialEqF64 : core.cmp.PartialEq Float Float where
  eq := liftFun2 core.cmp.impls.PartialEqF64.eq
  ne := liftFun2 core.cmp.impls.PartialEqF64.ne

/-! ## binary32 (`f32`) -/

@[expose, rust_fun "core::f32::{f32}::is_finite" -canFail]
def core.f32.is_finite (x : Float32) : Bool := x.isFinite

@[expose, rust_fun "core::f32::{f32}::abs" -canFail]
def core.f32.abs (x : Float32) : Float32 := x.abs

@[expose, rust_fun "std::f32::{f32}::sqrt" -canFail]
def std.f32.sqrt (x : Float32) : Float32 := x.sqrt

@[expose, rust_fun "core::clone::impls::{core::clone::Clone<f32>}::clone" -canFail]
def core.clone.impls.CloneF32.clone (x : Float32) : Float32 := x

@[expose, reducible, rust_trait_impl "core::clone::Clone<f32>"]
def core.clone.CloneF32 : core.clone.Clone Float32 where
  clone := fun x => .ok x
  clone_from := fun _ x => .ok x

@[expose, reducible, rust_trait_impl "core::marker::Copy<f32>"]
def core.marker.CopyF32 : core.marker.Copy Float32 where
  cloneInst := core.clone.CloneF32

@[expose, rust_fun "core::cmp::impls::{core::cmp::PartialEq<f32, f32>}::eq" -canFail]
def core.cmp.impls.PartialEqF32.eq (x y : Float32) : Bool := x == y

@[expose, rust_fun "core::cmp::impls::{core::cmp::PartialEq<f32, f32>}::ne" -canFail]
def core.cmp.impls.PartialEqF32.ne (x y : Float32) : Bool := x != y

@[expose, reducible, rust_trait_impl "core::cmp::PartialEq<f32, f32>"]
def core.cmp.PartialEqF32 : core.cmp.PartialEq Float32 Float32 where
  eq := liftFun2 core.cmp.impls.PartialEqF32.eq
  ne := liftFun2 core.cmp.impls.PartialEqF32.ne

/-! ## Casts (`as`)

The semantics follow the Rust reference
(https://doc.rust-lang.org/reference/expressions/operator-expr.html#numeric-cast):
- float to integer rounds toward zero, sends NaN to `0`, and saturates at the integer type's
  bounds;
- integer to float rounds to the nearest float (ties to even); overflow gives an infinity;
- `f32` to `f64` is exact, and `f64` to `f32` rounds to the nearest `f32` (ties to even).

Every definition goes through Lean's logical float model (`Float.toModel`, `Float32.toModel`), so
it can be reasoned about. Lean's own `Float.toFloat32` and `Float32.toFloat` are `opaque`. NaN
payloads are not preserved.
-/

open Float.Model in
/-- Round an unpacked float to the given format (exact if it is representable). -/
@[expose] def UnpackedFloat.roundToFormat (spec : Format) : UnpackedFloat → UnpackedFloat
  | .finite s m e _ => UnpackedFloat.round spec s m e
  | u => u

open Float.Model in
/-- Rust's float-to-integer rule on an unpacked float: truncate toward zero, NaN to `0`, and
saturate to `[lo, hi]` (infinities included). -/
@[expose] def UnpackedFloat.toIntSat (lo hi : Int) (u : UnpackedFloat) : Int :=
  max lo (min hi (u.toInt lo hi))

/-- `x as f32` for `x : f64`. -/
@[expose] def Float.castToFloat32 (x : Float) : Float32 :=
  Float32.ofModel (Float32.Model.pack (UnpackedFloat.roundToFormat .binary32 x.toModel.unpack))

/-- `x as f64` for `x : f32` (exact). -/
@[expose] def Float32.castToFloat (x : Float32) : Float :=
  Float.ofModel (Float.Model.pack (UnpackedFloat.roundToFormat .binary64 x.toModel.unpack))

/-- `x as uN` / `x as usize` for `x : f64`. -/
@[expose] def Float.toUScalar (ty : UScalarTy) (x : Float) : UScalar ty :=
  ⟨BitVec.ofInt ty.numBits (UnpackedFloat.toIntSat 0 (2 ^ ty.numBits - 1) x.toModel.unpack)⟩

/-- `x as iN` / `x as isize` for `x : f64`. -/
@[expose] def Float.toIScalar (ty : IScalarTy) (x : Float) : IScalar ty :=
  ⟨BitVec.ofInt ty.numBits
    (UnpackedFloat.toIntSat (-2 ^ (ty.numBits - 1)) (2 ^ (ty.numBits - 1) - 1) x.toModel.unpack)⟩

/-- `x as uN` / `x as usize` for `x : f32`. -/
@[expose] def Float32.toUScalar (ty : UScalarTy) (x : Float32) : UScalar ty :=
  ⟨BitVec.ofInt ty.numBits (UnpackedFloat.toIntSat 0 (2 ^ ty.numBits - 1) x.toModel.unpack)⟩

/-- `x as iN` / `x as isize` for `x : f32`. -/
@[expose] def Float32.toIScalar (ty : IScalarTy) (x : Float32) : IScalar ty :=
  ⟨BitVec.ofInt ty.numBits
    (UnpackedFloat.toIntSat (-2 ^ (ty.numBits - 1)) (2 ^ (ty.numBits - 1) - 1) x.toModel.unpack)⟩

/-- `x as f64` for an unsigned integer `x`. -/
@[expose] def UScalar.toFloat {ty : UScalarTy} (x : UScalar ty) : Float := Float.ofNat x.val

/-- `x as f32` for an unsigned integer `x`. -/
@[expose] def UScalar.toFloat32 {ty : UScalarTy} (x : UScalar ty) : Float32 := Float32.ofNat x.val

/-- `x as f64` for a signed integer `x`. -/
@[expose] def IScalar.toFloat {ty : IScalarTy} (x : IScalar ty) : Float := Float.ofInt x.val

/-- `x as f32` for a signed integer `x`. -/
@[expose] def IScalar.toFloat32 {ty : IScalarTy} (x : IScalar ty) : Float32 := Float32.ofInt x.val

end Aeneas.Std
