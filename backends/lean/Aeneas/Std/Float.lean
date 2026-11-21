module
public import Aeneas.Std.Core.Core
public import Aeneas.Std.Core.Cmp
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

/-! ## Remainder (`%`)

Rust's `%` on `f32` and `f64` is C's `fmod`
(https://doc.rust-lang.org/reference/expressions/operator-expr.html#arithmetic-and-logical-binary-operators):
the result is `x - trunc(x / y) * y`, computed exactly (it is always representable), with the
sign of `x`. It is NaN if `x` is infinite, `y` is zero, or either is NaN; it is `x` if `y` is
infinite and `x` is finite. A zero result has the sign of `x`.

The definition goes through Lean's logical float model: on finite operands, both mantissas are
brought to the smaller exponent and the remainder is computed on natural numbers. NaN payloads are
not preserved.
-/

open Float.Model in
/-- `fmod` on unpacked floats, in the given format. -/
@[expose] def UnpackedFloat.fmod (spec : Format) : UnpackedFloat → UnpackedFloat → UnpackedFloat
  | .notANumber, _ => .notANumber
  | _, .notANumber => .notANumber
  | .infinity _, _ => .notANumber
  | _, .zero _ => .notANumber
  | x, .infinity _ => x
  | .zero s, _ => .zero s
  | .finite s₁ m₁ e₁ _, .finite _ m₂ e₂ _ =>
    let e := min e₁ e₂
    let a := m₁ <<< (e₁ - e).toNat
    let b := m₂ <<< (e₂ - e).toNat
    -- `a % b` is exact and smaller than `|y|`, so rounding to the format is exact; a zero result
    -- keeps the sign of `x`.
    UnpackedFloat.normalize spec (s₁.apply (a % b : Nat)) e s₁

/-- `x % y` for `x y : f64`. -/
@[expose] def Float.rem (x y : Float) : Float :=
  Float.ofModel (Float.Model.pack (UnpackedFloat.fmod .binary64 x.toModel.unpack y.toModel.unpack))

/-- `x % y` for `x y : f32`. -/
@[expose] def Float32.rem (x y : Float32) : Float32 :=
  Float32.ofModel
    (Float32.Model.pack (UnpackedFloat.fmod .binary32 x.toModel.unpack y.toModel.unpack))

end Aeneas.Std
