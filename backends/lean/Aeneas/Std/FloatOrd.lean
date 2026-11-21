module
public import Aeneas.Std.Float
public import Aeneas.Std.Core.Cmp
public import Aeneas.Std.Core.Default
public section

/-!
# `PartialOrd` and `Default` for `f32` and `f64`

Rust's `PartialOrd` for floats follows IEEE 754:
- `partial_cmp` is `None` when either side is NaN, and `-0.0` and `+0.0` compare `Equal`;
- `lt`, `le`, `gt` and `ge` are false when either side is NaN.

Every definition goes through Lean's logical float model (`Float.toModel`, `Float32.toModel`), so
it can be reasoned about. The lemmas below relate the model to Lean's native comparisons
(`<`, `≤`, `==`), which are defined through the same model.

`Default` is `+0.0`.

Note that `x < y` on floats in Rust source is a built-in binary operation, not a trait call: these
definitions are used by generic code and by `#[derive(PartialOrd, Default)]`.
-/
namespace Aeneas.Std

/-! ## binary64 (`f64`) -/

@[expose, rust_fun "core::cmp::impls::{core::cmp::PartialOrd<f64, f64>}::partial_cmp" -canFail]
def core.cmp.impls.PartialOrdF64.partial_cmp (x y : Float) : Option Ordering :=
  x.toModel.compare y.toModel

@[expose, rust_fun "core::cmp::impls::{core::cmp::PartialOrd<f64, f64>}::lt" -canFail]
def core.cmp.impls.PartialOrdF64.lt (x y : Float) : Bool := x.toModel.lt y.toModel

@[expose, rust_fun "core::cmp::impls::{core::cmp::PartialOrd<f64, f64>}::le" -canFail]
def core.cmp.impls.PartialOrdF64.le (x y : Float) : Bool := x.toModel.le y.toModel

@[expose, rust_fun "core::cmp::impls::{core::cmp::PartialOrd<f64, f64>}::gt" -canFail]
def core.cmp.impls.PartialOrdF64.gt (x y : Float) : Bool := y.toModel.lt x.toModel

@[expose, rust_fun "core::cmp::impls::{core::cmp::PartialOrd<f64, f64>}::ge" -canFail]
def core.cmp.impls.PartialOrdF64.ge (x y : Float) : Bool := y.toModel.le x.toModel

@[expose, reducible, rust_trait_impl "core::cmp::PartialOrd<f64, f64>"]
def core.cmp.PartialOrdF64 : core.cmp.PartialOrd Float Float where
  partialEqInst := core.cmp.PartialEqF64
  partial_cmp := liftFun2 core.cmp.impls.PartialOrdF64.partial_cmp
  lt := liftFun2 core.cmp.impls.PartialOrdF64.lt
  le := liftFun2 core.cmp.impls.PartialOrdF64.le
  gt := liftFun2 core.cmp.impls.PartialOrdF64.gt
  ge := liftFun2 core.cmp.impls.PartialOrdF64.ge

@[expose, rust_fun "core::default::{core::default::Default<f64>}::default"]
def core.default.DefaultF64.default : Result Float := .ok (Float.ofBits 0)

@[expose, reducible, rust_trait_impl "core::default::Default<f64>"]
def core.default.DefaultF64 : core.default.Default Float where
  default := core.default.DefaultF64.default

/-! ## binary32 (`f32`) -/

@[expose, rust_fun "core::cmp::impls::{core::cmp::PartialOrd<f32, f32>}::partial_cmp" -canFail]
def core.cmp.impls.PartialOrdF32.partial_cmp (x y : Float32) : Option Ordering :=
  x.toModel.compare y.toModel

@[expose, rust_fun "core::cmp::impls::{core::cmp::PartialOrd<f32, f32>}::lt" -canFail]
def core.cmp.impls.PartialOrdF32.lt (x y : Float32) : Bool := x.toModel.lt y.toModel

@[expose, rust_fun "core::cmp::impls::{core::cmp::PartialOrd<f32, f32>}::le" -canFail]
def core.cmp.impls.PartialOrdF32.le (x y : Float32) : Bool := x.toModel.le y.toModel

@[expose, rust_fun "core::cmp::impls::{core::cmp::PartialOrd<f32, f32>}::gt" -canFail]
def core.cmp.impls.PartialOrdF32.gt (x y : Float32) : Bool := y.toModel.lt x.toModel

@[expose, rust_fun "core::cmp::impls::{core::cmp::PartialOrd<f32, f32>}::ge" -canFail]
def core.cmp.impls.PartialOrdF32.ge (x y : Float32) : Bool := y.toModel.le x.toModel

@[expose, reducible, rust_trait_impl "core::cmp::PartialOrd<f32, f32>"]
def core.cmp.PartialOrdF32 : core.cmp.PartialOrd Float32 Float32 where
  partialEqInst := core.cmp.PartialEqF32
  partial_cmp := liftFun2 core.cmp.impls.PartialOrdF32.partial_cmp
  lt := liftFun2 core.cmp.impls.PartialOrdF32.lt
  le := liftFun2 core.cmp.impls.PartialOrdF32.le
  gt := liftFun2 core.cmp.impls.PartialOrdF32.gt
  ge := liftFun2 core.cmp.impls.PartialOrdF32.ge

@[expose, rust_fun "core::default::{core::default::Default<f32>}::default"]
def core.default.DefaultF32.default : Result Float32 := .ok (Float32.ofBits 0)

@[expose, reducible, rust_trait_impl "core::default::Default<f32>"]
def core.default.DefaultF32 : core.default.Default Float32 where
  default := core.default.DefaultF32.default

/-! ## Relation to Lean's native comparisons -/

theorem core.cmp.impls.PartialOrdF64.lt_eq (x y : Float) :
    core.cmp.impls.PartialOrdF64.lt x y = decide (x < y) := by
  simp [core.cmp.impls.PartialOrdF64.lt, LT.lt, Float.lt]

theorem core.cmp.impls.PartialOrdF64.le_eq (x y : Float) :
    core.cmp.impls.PartialOrdF64.le x y = decide (x ≤ y) := by
  simp [core.cmp.impls.PartialOrdF64.le, LE.le, Float.le]

theorem core.cmp.impls.PartialOrdF64.gt_eq (x y : Float) :
    core.cmp.impls.PartialOrdF64.gt x y = decide (y < x) :=
  core.cmp.impls.PartialOrdF64.lt_eq y x

theorem core.cmp.impls.PartialOrdF64.ge_eq (x y : Float) :
    core.cmp.impls.PartialOrdF64.ge x y = decide (y ≤ x) :=
  core.cmp.impls.PartialOrdF64.le_eq y x

theorem core.cmp.impls.PartialOrdF32.lt_eq (x y : Float32) :
    core.cmp.impls.PartialOrdF32.lt x y = decide (x < y) := by
  simp [core.cmp.impls.PartialOrdF32.lt, LT.lt, Float32.lt]

theorem core.cmp.impls.PartialOrdF32.le_eq (x y : Float32) :
    core.cmp.impls.PartialOrdF32.le x y = decide (x ≤ y) := by
  simp [core.cmp.impls.PartialOrdF32.le, LE.le, Float32.le]

theorem core.cmp.impls.PartialOrdF32.gt_eq (x y : Float32) :
    core.cmp.impls.PartialOrdF32.gt x y = decide (y < x) :=
  core.cmp.impls.PartialOrdF32.lt_eq y x

theorem core.cmp.impls.PartialOrdF32.ge_eq (x y : Float32) :
    core.cmp.impls.PartialOrdF32.ge x y = decide (y ≤ x) :=
  core.cmp.impls.PartialOrdF32.le_eq y x

/-! ### `F64`: the comparison methods agree with `partial_cmp` -/

theorem core.cmp.impls.PartialOrdF64.partial_cmp_eq_none_iff (x y : Float) :
    core.cmp.impls.PartialOrdF64.partial_cmp x y = none ↔ x.isNaN ∨ y.isNaN := by
  simp only [core.cmp.impls.PartialOrdF64.partial_cmp, Float.isNaN, Float.Model.compare,
    Float.Model.isNaN]
  generalize x.toModel.unpack = a
  generalize y.toModel.unpack = b
  cases a <;> cases b <;>
    simp [Float.Model.UnpackedFloat.compare, Float.Model.UnpackedFloat.isNaN] <;>
    split <;> simp_all

theorem core.cmp.impls.PartialOrdF64.lt_eq_partial_cmp (x y : Float) :
    core.cmp.impls.PartialOrdF64.lt x y =
      (core.cmp.impls.PartialOrdF64.partial_cmp x y == some .lt) := rfl

theorem core.cmp.impls.PartialOrdF64.gt_eq_partial_cmp (x y : Float) :
    core.cmp.impls.PartialOrdF64.gt x y =
      (core.cmp.impls.PartialOrdF64.partial_cmp y x == some .lt) := rfl

theorem core.cmp.impls.PartialOrdF64.le_eq_partial_cmp (x y : Float) :
    core.cmp.impls.PartialOrdF64.le x y =
      (core.cmp.impls.PartialOrdF64.partial_cmp x y).any (·.isLE) := rfl

theorem core.cmp.impls.PartialOrdF64.ge_eq_partial_cmp (x y : Float) :
    core.cmp.impls.PartialOrdF64.ge x y =
      (core.cmp.impls.PartialOrdF64.partial_cmp y x).any (·.isLE) := rfl

/-! ### `F32`: the comparison methods agree with `partial_cmp` -/

theorem core.cmp.impls.PartialOrdF32.partial_cmp_eq_none_iff (x y : Float32) :
    core.cmp.impls.PartialOrdF32.partial_cmp x y = none ↔ x.isNaN ∨ y.isNaN := by
  simp only [core.cmp.impls.PartialOrdF32.partial_cmp, Float32.isNaN, Float32.Model.compare,
    Float32.Model.isNaN]
  generalize x.toModel.unpack = a
  generalize y.toModel.unpack = b
  cases a <;> cases b <;>
    simp [Float.Model.UnpackedFloat.compare, Float.Model.UnpackedFloat.isNaN] <;>
    split <;> simp_all

theorem core.cmp.impls.PartialOrdF32.lt_eq_partial_cmp (x y : Float32) :
    core.cmp.impls.PartialOrdF32.lt x y =
      (core.cmp.impls.PartialOrdF32.partial_cmp x y == some .lt) := rfl

theorem core.cmp.impls.PartialOrdF32.gt_eq_partial_cmp (x y : Float32) :
    core.cmp.impls.PartialOrdF32.gt x y =
      (core.cmp.impls.PartialOrdF32.partial_cmp y x == some .lt) := rfl

theorem core.cmp.impls.PartialOrdF32.le_eq_partial_cmp (x y : Float32) :
    core.cmp.impls.PartialOrdF32.le x y =
      (core.cmp.impls.PartialOrdF32.partial_cmp x y).any (·.isLE) := rfl

theorem core.cmp.impls.PartialOrdF32.ge_eq_partial_cmp (x y : Float32) :
    core.cmp.impls.PartialOrdF32.ge x y =
      (core.cmp.impls.PartialOrdF32.partial_cmp y x).any (·.isLE) := rfl

end Aeneas.Std
