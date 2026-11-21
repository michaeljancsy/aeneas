module
import Float32Traits

set_option autoImplicit false

open Aeneas.Std

/- `@` makes an accidentally auto-bound implicit float type visible here. -/
example : Float32 → Float32 → Bool → Result Float32 := @float32_traits.pick

example : float32_traits.test_create =
    Result.ok (float32_traits.BucketReduction.OverConsumption (Float32.ofBits 1069547520)) :=
  rfl

example (x y : Float32) : float32_traits.test_divide x y =
    Result.ok (float32_traits.BucketReduction.OverConsumption (Float32.div x y)) := rfl

/- `Copy` for f32 resolves to the new `CopyF32` instance. -/
example (x : Float32) : float32_traits.duplicate_f32 x = Result.ok (x, x) := rfl
