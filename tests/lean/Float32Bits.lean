module
import Float32Ops

set_option autoImplicit false

/- Check the actual extracted constants against their source binary32 words. -/
example : float32_ops.positive_zero = Aeneas.Std.Result.ok (Float32.ofBits 0) := rfl

example : float32_ops.negative_zero = Aeneas.Std.Result.ok (Float32.ofBits 2147483648) := rfl

example : float32_ops.literal = Aeneas.Std.Result.ok (Float32.ofBits 1036831949) := rfl

example : float32_ops.subnormal = Aeneas.Std.Result.ok (Float32.ofBits 1) := rfl

example : float32_ops.max_finite = Aeneas.Std.Result.ok (Float32.ofBits 2139095039) := rfl

example : float32_ops.positive_infinity = Aeneas.Std.Result.ok (Float32.ofBits 2139095040) := rfl

example : float32_ops.negative_infinity = Aeneas.Std.Result.ok (Float32.ofBits 4286578688) := rfl

example : float32_ops.rounding_worst_case = Aeneas.Std.Result.ok (Float32.ofBits 285106830) := rfl

example : float32_ops.min_positive_normal = Aeneas.Std.Result.ok (Float32.ofBits 8388608) := rfl

example : float32_ops.epsilon = Aeneas.Std.Result.ok (Float32.ofBits 872415232) := rfl
