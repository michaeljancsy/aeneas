module
import Float32

set_option autoImplicit false

/- Check the actual extracted constants against their source binary32 words. -/
example : float32.positive_zero = Aeneas.Std.Result.ok (Float32.ofBits 0) := rfl

example : float32.negative_zero = Aeneas.Std.Result.ok (Float32.ofBits 2147483648) := rfl

example : float32.literal = Aeneas.Std.Result.ok (Float32.ofBits 1036831949) := rfl

example : float32.subnormal = Aeneas.Std.Result.ok (Float32.ofBits 1) := rfl

example : float32.max_finite = Aeneas.Std.Result.ok (Float32.ofBits 2139095039) := rfl

example : float32.positive_infinity = Aeneas.Std.Result.ok (Float32.ofBits 2139095040) := rfl

example : float32.negative_infinity = Aeneas.Std.Result.ok (Float32.ofBits 4286578688) := rfl
