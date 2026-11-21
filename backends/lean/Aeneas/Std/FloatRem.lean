module
public import Aeneas.Std.Scalar.Core
public section

/-!
# Remainder (`%`) on floats

Rust's `%` on `f32` and `f64` is C's `fmod`
(https://doc.rust-lang.org/reference/expressions/operator-expr.html#arithmetic-and-logical-binary-operators):
the result is `x - trunc(x / y) * y`, computed exactly (it is always representable), with the
sign of `x`. It is NaN if `x` is infinite, `y` is zero, or either is NaN; it is `x` if `y` is
infinite and `x` is finite. A zero result has the sign of `x`.

The definition goes through Lean's logical float model: on finite operands, both mantissas are
brought to the smaller exponent and the remainder is computed on natural numbers. Lean has no
native `fmod`, so compiled code (`#eval`, `#guard`) also runs this definition. NaN payloads are
not preserved.
-/

namespace Aeneas.Std

namespace FloatRem

open Float.Model

/-- `fmod` on unpacked floats, in the given format. -/
@[expose] def fmod (spec : Format) : UnpackedFloat → UnpackedFloat → UnpackedFloat
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

end FloatRem

/-- `x % y` for `x y : f64`. -/
@[expose, step_pure_def]
def Float.rem (x y : Float) : Float :=
  Float.ofModel (Float.Model.pack (FloatRem.fmod .binary64 x.toModel.unpack y.toModel.unpack))

/-- `x % y` for `x y : f32`. -/
@[expose, step_pure_def]
def Float32.rem (x y : Float32) : Float32 :=
  Float32.ofModel
    (Float32.Model.pack (FloatRem.fmod .binary32 x.toModel.unpack y.toModel.unpack))

end Aeneas.Std
