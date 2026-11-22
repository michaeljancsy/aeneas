import Aeneas

set_option autoImplicit false

/-! Checks of the float bit, classification and sign models (`Aeneas.Std.FloatBits`) and of the
float constants (`Aeneas.Std.FloatConsts`) against Rust. Every expected value below was printed by
a Rust program (`to_bits` of Rust's own constants and method results). The checks are evaluated
by the kernel (`rfl`, `decide`), so they test Lean's logical model, not compiled code. -/

open Aeneas.Std

/-! ## Constants: bits from Rust's `to_bits` -/

example : core.f32.consts.PI.toBits = 0x40490FDB := rfl
example : core.f32.consts.TAU.toBits = 0x40C90FDB := rfl
example : core.f32.consts.GOLDEN_RATIO.toBits = 0x3FCF1BBD := rfl
example : core.f32.consts.EULER_GAMMA.toBits = 0x3F13C468 := rfl
example : core.f32.consts.FRAC_PI_2.toBits = 0x3FC90FDB := rfl
example : core.f32.consts.FRAC_PI_3.toBits = 0x3F860A92 := rfl
example : core.f32.consts.FRAC_PI_4.toBits = 0x3F490FDB := rfl
example : core.f32.consts.FRAC_PI_6.toBits = 0x3F060A92 := rfl
example : core.f32.consts.FRAC_PI_8.toBits = 0x3EC90FDB := rfl
example : core.f32.consts.FRAC_1_PI.toBits = 0x3EA2F983 := rfl
example : core.f32.consts.FRAC_1_SQRT_PI.toBits = 0x3F106EBB := rfl
example : core.f32.consts.FRAC_1_SQRT_2PI.toBits = 0x3ECC422A := rfl
example : core.f32.consts.FRAC_2_PI.toBits = 0x3F22F983 := rfl
example : core.f32.consts.FRAC_2_SQRT_PI.toBits = 0x3F906EBB := rfl
example : core.f32.consts.SQRT_2.toBits = 0x3FB504F3 := rfl
example : core.f32.consts.FRAC_1_SQRT_2.toBits = 0x3F3504F3 := rfl
example : core.f32.consts.SQRT_3.toBits = 0x3FDDB3D7 := rfl
example : core.f32.consts.FRAC_1_SQRT_3.toBits = 0x3F13CD3A := rfl
example : core.f32.consts.SQRT_5.toBits = 0x400F1BBD := rfl
example : core.f32.consts.FRAC_1_SQRT_5.toBits = 0x3EE4F92E := rfl
example : core.f32.consts.E.toBits = 0x402DF854 := rfl
example : core.f32.consts.LOG2_E.toBits = 0x3FB8AA3B := rfl
example : core.f32.consts.LOG2_10.toBits = 0x40549A78 := rfl
example : core.f32.consts.LOG10_E.toBits = 0x3EDE5BD9 := rfl
example : core.f32.consts.LOG10_2.toBits = 0x3E9A209B := rfl
example : core.f32.consts.LN_2.toBits = 0x3F317218 := rfl
example : core.f32.consts.LN_10.toBits = 0x40135D8E := rfl
example : core.f32.F32.EPSILON.toBits = 0x34000000 := rfl
example : core.f32.EPSILON = core.f32.F32.EPSILON := rfl
example : core.f32.F32.MIN.toBits = 0xFF7FFFFF := rfl
example : core.f32.MIN = core.f32.F32.MIN := rfl
example : core.f32.F32.MAX.toBits = 0x7F7FFFFF := rfl
example : core.f32.MAX = core.f32.F32.MAX := rfl
example : core.f32.F32.MIN_POSITIVE.toBits = 0x00800000 := rfl
example : core.f32.MIN_POSITIVE = core.f32.F32.MIN_POSITIVE := rfl
example : core.f32.F32.INFINITY.toBits = 0x7F800000 := rfl
example : core.f32.INFINITY = core.f32.F32.INFINITY := rfl
example : core.f32.F32.NEG_INFINITY.toBits = 0xFF800000 := rfl
example : core.f32.NEG_INFINITY = core.f32.F32.NEG_INFINITY := rfl
example : core.f32.F32.RADIX.val = 2 := rfl
example : core.f32.F32.MANTISSA_DIGITS.val = 24 := rfl
example : core.f32.F32.DIGITS.val = 6 := rfl
example : core.f32.F32.MIN_EXP.val = -125 := rfl
example : core.f32.F32.MAX_EXP.val = 128 := rfl
example : core.f32.F32.MIN_10_EXP.val = -37 := rfl
example : core.f32.F32.MAX_10_EXP.val = 38 := rfl
example : core.f64.consts.PI.toBits = 0x400921FB54442D18 := rfl
example : core.f64.consts.TAU.toBits = 0x401921FB54442D18 := rfl
example : core.f64.consts.GOLDEN_RATIO.toBits = 0x3FF9E3779B97F4A8 := rfl
example : core.f64.consts.EULER_GAMMA.toBits = 0x3FE2788CFC6FB619 := rfl
example : core.f64.consts.FRAC_PI_2.toBits = 0x3FF921FB54442D18 := rfl
example : core.f64.consts.FRAC_PI_3.toBits = 0x3FF0C152382D7366 := rfl
example : core.f64.consts.FRAC_PI_4.toBits = 0x3FE921FB54442D18 := rfl
example : core.f64.consts.FRAC_PI_6.toBits = 0x3FE0C152382D7366 := rfl
example : core.f64.consts.FRAC_PI_8.toBits = 0x3FD921FB54442D18 := rfl
example : core.f64.consts.FRAC_1_PI.toBits = 0x3FD45F306DC9C883 := rfl
example : core.f64.consts.FRAC_1_SQRT_PI.toBits = 0x3FE20DD750429B6D := rfl
example : core.f64.consts.FRAC_1_SQRT_2PI.toBits = 0x3FD9884533D43651 := rfl
example : core.f64.consts.FRAC_2_PI.toBits = 0x3FE45F306DC9C883 := rfl
example : core.f64.consts.FRAC_2_SQRT_PI.toBits = 0x3FF20DD750429B6D := rfl
example : core.f64.consts.SQRT_2.toBits = 0x3FF6A09E667F3BCD := rfl
example : core.f64.consts.FRAC_1_SQRT_2.toBits = 0x3FE6A09E667F3BCD := rfl
example : core.f64.consts.SQRT_3.toBits = 0x3FFBB67AE8584CAA := rfl
example : core.f64.consts.FRAC_1_SQRT_3.toBits = 0x3FE279A74590331C := rfl
example : core.f64.consts.SQRT_5.toBits = 0x4001E3779B97F4A8 := rfl
example : core.f64.consts.FRAC_1_SQRT_5.toBits = 0x3FDC9F25C5BFEDD9 := rfl
example : core.f64.consts.E.toBits = 0x4005BF0A8B145769 := rfl
example : core.f64.consts.LOG2_E.toBits = 0x3FF71547652B82FE := rfl
example : core.f64.consts.LOG2_10.toBits = 0x400A934F0979A371 := rfl
example : core.f64.consts.LOG10_E.toBits = 0x3FDBCB7B1526E50E := rfl
example : core.f64.consts.LOG10_2.toBits = 0x3FD34413509F79FF := rfl
example : core.f64.consts.LN_2.toBits = 0x3FE62E42FEFA39EF := rfl
example : core.f64.consts.LN_10.toBits = 0x40026BB1BBB55516 := rfl
example : core.f64.F64.EPSILON.toBits = 0x3CB0000000000000 := rfl
example : core.f64.EPSILON = core.f64.F64.EPSILON := rfl
example : core.f64.F64.MIN.toBits = 0xFFEFFFFFFFFFFFFF := rfl
example : core.f64.MIN = core.f64.F64.MIN := rfl
example : core.f64.F64.MAX.toBits = 0x7FEFFFFFFFFFFFFF := rfl
example : core.f64.MAX = core.f64.F64.MAX := rfl
example : core.f64.F64.MIN_POSITIVE.toBits = 0x0010000000000000 := rfl
example : core.f64.MIN_POSITIVE = core.f64.F64.MIN_POSITIVE := rfl
example : core.f64.F64.INFINITY.toBits = 0x7FF0000000000000 := rfl
example : core.f64.INFINITY = core.f64.F64.INFINITY := rfl
example : core.f64.F64.NEG_INFINITY.toBits = 0xFFF0000000000000 := rfl
example : core.f64.NEG_INFINITY = core.f64.F64.NEG_INFINITY := rfl
example : core.f64.F64.RADIX.val = 2 := rfl
example : core.f64.F64.MANTISSA_DIGITS.val = 53 := rfl
example : core.f64.F64.DIGITS.val = 15 := rfl
example : core.f64.F64.MIN_EXP.val = -1021 := rfl
example : core.f64.F64.MAX_EXP.val = 1024 := rfl
example : core.f64.F64.MIN_10_EXP.val = -307 := rfl
example : core.f64.F64.MAX_10_EXP.val = 308 := rfl

/-! ## The models that can fail

`to_bits`, `is_sign_negative`, `is_sign_positive` and `copysign` return a `Result`: they fail
(`undef`) when they would read a NaN's sign or bits, and otherwise return the pure bit-level
helper (`bitsOf`, `signBit`, `copysignBits`). This holds by definition, for every input. The
tables below then check the helpers, and `isNaN`, on special values: `Result` does not reduce
in the kernel, so `decide` cannot evaluate a `Result` directly. -/

example (x : Float32) :
    core.f32.to_bits x = if x.isNaN then .fail .undef else .ok (core.f32.bitsOf x) := rfl
example (x : Float32) :
    core.f32.is_sign_negative x = if x.isNaN then .fail .undef else .ok (core.f32.signBit x) := rfl
example (x : Float32) :
    core.f32.is_sign_positive x = if x.isNaN then .fail .undef else .ok (!core.f32.signBit x) :=
  rfl
example (x y : Float32) :
    core.f32.copysign x y = if y.isNaN then .fail .undef else .ok (core.f32.copysignBits x y) :=
  rfl
example (x : Float) :
    core.f64.to_bits x = if x.isNaN then .fail .undef else .ok (core.f64.bitsOf x) := rfl
example (x : Float) :
    core.f64.is_sign_negative x = if x.isNaN then .fail .undef else .ok (core.f64.signBit x) := rfl
example (x : Float) :
    core.f64.is_sign_positive x = if x.isNaN then .fail .undef else .ok (!core.f64.signBit x) :=
  rfl
example (x y : Float) :
    core.f64.copysign x y = if y.isNaN then .fail .undef else .ok (core.f64.copysignBits x y) :=
  rfl

/-! ## `f32` methods on special values (kernel evaluation) -/

/-- Expected results for a non-NaN `x` (and a non-NaN `y` for `copysign`), all Rust's:
`to_bits`, the six classification flags (`is_nan`, `is_infinite`, `is_sign_positive`,
`is_sign_negative`, `is_normal`, `is_subnormal`, bit 0 first), `signum`, `copysign`, `recip`,
`from_bits`. Since `x` and `y` are not NaNs, `to_bits`, `is_sign_*` and `copysign` return `ok`
of the helpers checked here. The results of `signum`, `copysign`, `recip` and `from_bits` are
compared through their bits; none of the expected values is a NaN, so these results are not
NaNs either, and `to_bits` of them is `ok` of the same bits. -/
def checkf32 (x y : UInt32) (toBits flags signum copysign recip fromBits : Nat) : Bool :=
  let fx := Float32.ofBits x
  let fy := Float32.ofBits y
  let bits (f : Float32) : Nat := (core.f32.bitsOf f).bv.toNat
  let fl := (if core.f32.is_nan fx then 1 else 0) + (if core.f32.is_infinite fx then 2 else 0)
    + (if !core.f32.signBit fx then 4 else 0) + (if core.f32.signBit fx then 8 else 0)
    + (if core.f32.is_normal fx then 16 else 0) + (if core.f32.is_subnormal fx then 32 else 0)
  !fx.isNaN && !fy.isNaN &&
  bits fx == toBits && fl == flags &&
  bits (core.f32.signum fx) == signum &&
  bits (core.f32.copysignBits fx fy) == copysign &&
  bits (core.f32.recip fx) == recip &&
  bits (core.f32.from_bits ⟨x.toBitVec⟩) == fromBits &&
  !(core.f32.signum fx).isNaN && !(core.f32.copysignBits fx fy).isNaN &&
  !(core.f32.recip fx).isNaN && !(core.f32.from_bits ⟨x.toBitVec⟩).isNaN

/-- A NaN `x` (with a non-NaN `y`). Since `x` is a NaN, reading its sign or bits fails:
`to_bits x`, `is_sign_positive x`, `is_sign_negative x` and `copysign y x`. The other functions
give Rust's answer (`is_nan`, `is_infinite`, `is_normal`, `is_subnormal`), or a NaN (`signum`,
`recip`, `from_bits`, and `copysign x y`, which succeeds because `y` is not a NaN). -/
def checkNaN32 (x y : UInt32) : Bool :=
  let fx := Float32.ofBits x
  let fy := Float32.ofBits y
  fx.isNaN && !fy.isNaN &&
  core.f32.is_nan fx && !core.f32.is_infinite fx &&
  !core.f32.is_normal fx && !core.f32.is_subnormal fx &&
  (core.f32.signum fx).isNaN && (core.f32.recip fx).isNaN &&
  (core.f32.from_bits ⟨x.toBitVec⟩).isNaN &&
  (core.f32.copysignBits fx fy).isNaN

example : checkf32 0 0 0 4 1065353216 0 2139095040 0 := by decide
example : checkf32 0 2147483648 0 4 1065353216 2147483648 2139095040 0 := by decide
example : checkf32 2147483648 0 2147483648 8 3212836864 0 4286578688 2147483648 := by decide
example : checkf32 2147483648 2147483648 2147483648 8 3212836864 2147483648 4286578688 2147483648 := by decide
example : checkf32 1 0 1 36 1065353216 1 2139095040 1 := by decide
example : checkf32 1 2147483648 1 36 1065353216 2147483649 2139095040 1 := by decide
example : checkf32 2147483649 0 2147483649 40 3212836864 1 4286578688 2147483649 := by decide
example : checkf32 2147483649 2147483648 2147483649 40 3212836864 2147483649 4286578688 2147483649 := by decide
example : checkf32 8388607 0 8388607 36 1065353216 8388607 2122317825 8388607 := by decide
example : checkf32 8388607 2147483648 8388607 36 1065353216 2155872255 2122317825 8388607 := by decide
example : checkf32 2155872255 0 2155872255 40 3212836864 8388607 4269801473 2155872255 := by decide
example : checkf32 2155872255 2147483648 2155872255 40 3212836864 2155872255 4269801473 2155872255 := by decide
example : checkf32 8388608 0 8388608 20 1065353216 8388608 2122317824 8388608 := by decide
example : checkf32 8388608 2147483648 8388608 20 1065353216 2155872256 2122317824 8388608 := by decide
example : checkf32 2155872256 0 2155872256 24 3212836864 8388608 4269801472 2155872256 := by decide
example : checkf32 2155872256 2147483648 2155872256 24 3212836864 2155872256 4269801472 2155872256 := by decide
example : checkf32 1065353216 0 1065353216 20 1065353216 1065353216 1065353216 1065353216 := by decide
example : checkf32 1065353216 2147483648 1065353216 20 1065353216 3212836864 1065353216 1065353216 := by decide
example : checkf32 3212836864 0 3212836864 24 3212836864 1065353216 3212836864 3212836864 := by decide
example : checkf32 3212836864 2147483648 3212836864 24 3212836864 3212836864 3212836864 3212836864 := by decide
example : checkf32 2139095039 0 2139095039 20 1065353216 2139095039 2097152 2139095039 := by decide
example : checkf32 2139095039 2147483648 2139095039 20 1065353216 4286578687 2097152 2139095039 := by decide
example : checkf32 4286578687 0 4286578687 24 3212836864 2139095039 2149580800 4286578687 := by decide
example : checkf32 4286578687 2147483648 4286578687 24 3212836864 4286578687 2149580800 4286578687 := by decide
example : checkf32 2139095040 0 2139095040 6 1065353216 2139095040 0 2139095040 := by decide
example : checkf32 2139095040 2147483648 2139095040 6 1065353216 4286578688 0 2139095040 := by decide
example : checkf32 4286578688 0 4286578688 10 3212836864 2139095040 2147483648 4286578688 := by decide
example : checkf32 4286578688 2147483648 4286578688 10 3212836864 4286578688 2147483648 4286578688 := by decide
example : checkNaN32 2143289344 0 := by decide
example : checkNaN32 2143289344 2147483648 := by decide
example : checkNaN32 4290772992 0 := by decide
example : checkNaN32 4290772992 2147483648 := by decide
example : checkNaN32 2139095041 0 := by decide
example : checkNaN32 2139095041 2147483648 := by decide
example : checkNaN32 4286578689 0 := by decide
example : checkNaN32 4286578689 2147483648 := by decide
example : checkNaN32 2143289345 0 := by decide
example : checkNaN32 2143289345 2147483648 := by decide
example : checkNaN32 2147483647 0 := by decide
example : checkNaN32 2147483647 2147483648 := by decide
example : checkNaN32 4294967295 0 := by decide
example : checkNaN32 4294967295 2147483648 := by decide
example : checkNaN32 2141192192 0 := by decide
example : checkNaN32 2141192192 2147483648 := by decide
example : checkf32 1078530011 0 1078530011 20 1065353216 1078530011 1050868099 1078530011 := by decide
example : checkf32 1078530011 2147483648 1078530011 20 1065353216 3226013659 1050868099 1078530011 := by decide
example : checkf32 4194304 0 4194304 36 1065353216 4194304 2130706432 4194304 := by decide
example : checkf32 4194304 2147483648 4194304 36 1065353216 2151677952 2130706432 4194304 := by decide

/-! ## `f64` methods on special values (kernel evaluation) -/

/-- Expected results for a non-NaN `x` (and a non-NaN `y` for `copysign`), all Rust's:
`to_bits`, the six classification flags (`is_nan`, `is_infinite`, `is_sign_positive`,
`is_sign_negative`, `is_normal`, `is_subnormal`, bit 0 first), `signum`, `copysign`, `recip`,
`from_bits`. Since `x` and `y` are not NaNs, `to_bits`, `is_sign_*` and `copysign` return `ok`
of the helpers checked here. The results of `signum`, `copysign`, `recip` and `from_bits` are
compared through their bits; none of the expected values is a NaN, so these results are not
NaNs either, and `to_bits` of them is `ok` of the same bits. -/
def checkf64 (x y : UInt64) (toBits flags signum copysign recip fromBits : Nat) : Bool :=
  let fx := Float.ofBits x
  let fy := Float.ofBits y
  let bits (f : Float) : Nat := (core.f64.bitsOf f).bv.toNat
  let fl := (if core.f64.is_nan fx then 1 else 0) + (if core.f64.is_infinite fx then 2 else 0)
    + (if !core.f64.signBit fx then 4 else 0) + (if core.f64.signBit fx then 8 else 0)
    + (if core.f64.is_normal fx then 16 else 0) + (if core.f64.is_subnormal fx then 32 else 0)
  !fx.isNaN && !fy.isNaN &&
  bits fx == toBits && fl == flags &&
  bits (core.f64.signum fx) == signum &&
  bits (core.f64.copysignBits fx fy) == copysign &&
  bits (core.f64.recip fx) == recip &&
  bits (core.f64.from_bits ⟨x.toBitVec⟩) == fromBits &&
  !(core.f64.signum fx).isNaN && !(core.f64.copysignBits fx fy).isNaN &&
  !(core.f64.recip fx).isNaN && !(core.f64.from_bits ⟨x.toBitVec⟩).isNaN

/-- A NaN `x` (with a non-NaN `y`). Since `x` is a NaN, reading its sign or bits fails:
`to_bits x`, `is_sign_positive x`, `is_sign_negative x` and `copysign y x`. The other functions
give Rust's answer (`is_nan`, `is_infinite`, `is_normal`, `is_subnormal`), or a NaN (`signum`,
`recip`, `from_bits`, and `copysign x y`, which succeeds because `y` is not a NaN). -/
def checkNaN64 (x y : UInt64) : Bool :=
  let fx := Float.ofBits x
  let fy := Float.ofBits y
  fx.isNaN && !fy.isNaN &&
  core.f64.is_nan fx && !core.f64.is_infinite fx &&
  !core.f64.is_normal fx && !core.f64.is_subnormal fx &&
  (core.f64.signum fx).isNaN && (core.f64.recip fx).isNaN &&
  (core.f64.from_bits ⟨x.toBitVec⟩).isNaN &&
  (core.f64.copysignBits fx fy).isNaN

example : checkf64 0 0 0 4 4607182418800017408 0 9218868437227405312 0 := by decide
example : checkf64 0 9223372036854775808 0 4 4607182418800017408 9223372036854775808 9218868437227405312 0 := by decide
example : checkf64 9223372036854775808 0 9223372036854775808 8 13830554455654793216 0 18442240474082181120 9223372036854775808 := by decide
example : checkf64 9223372036854775808 9223372036854775808 9223372036854775808 8 13830554455654793216 9223372036854775808 18442240474082181120 9223372036854775808 := by decide
example : checkf64 1 0 1 36 4607182418800017408 1 9218868437227405312 1 := by decide
example : checkf64 1 9223372036854775808 1 36 4607182418800017408 9223372036854775809 9218868437227405312 1 := by decide
example : checkf64 9223372036854775809 0 9223372036854775809 40 13830554455654793216 1 18442240474082181120 9223372036854775809 := by decide
example : checkf64 9223372036854775809 9223372036854775808 9223372036854775809 40 13830554455654793216 9223372036854775809 18442240474082181120 9223372036854775809 := by decide
example : checkf64 4503599627370495 0 4503599627370495 36 4607182418800017408 4503599627370495 9209861237972664321 4503599627370495 := by decide
example : checkf64 4503599627370495 9223372036854775808 4503599627370495 36 4607182418800017408 9227875636482146303 9209861237972664321 4503599627370495 := by decide
example : checkf64 9227875636482146303 0 9227875636482146303 40 13830554455654793216 4503599627370495 18433233274827440129 9227875636482146303 := by decide
example : checkf64 9227875636482146303 9223372036854775808 9227875636482146303 40 13830554455654793216 9227875636482146303 18433233274827440129 9227875636482146303 := by decide
example : checkf64 4503599627370496 0 4503599627370496 20 4607182418800017408 4503599627370496 9209861237972664320 4503599627370496 := by decide
example : checkf64 4503599627370496 9223372036854775808 4503599627370496 20 4607182418800017408 9227875636482146304 9209861237972664320 4503599627370496 := by decide
example : checkf64 9227875636482146304 0 9227875636482146304 24 13830554455654793216 4503599627370496 18433233274827440128 9227875636482146304 := by decide
example : checkf64 9227875636482146304 9223372036854775808 9227875636482146304 24 13830554455654793216 9227875636482146304 18433233274827440128 9227875636482146304 := by decide
example : checkf64 4607182418800017408 0 4607182418800017408 20 4607182418800017408 4607182418800017408 4607182418800017408 4607182418800017408 := by decide
example : checkf64 4607182418800017408 9223372036854775808 4607182418800017408 20 4607182418800017408 13830554455654793216 4607182418800017408 4607182418800017408 := by decide
example : checkf64 13830554455654793216 0 13830554455654793216 24 13830554455654793216 4607182418800017408 13830554455654793216 13830554455654793216 := by decide
example : checkf64 13830554455654793216 9223372036854775808 13830554455654793216 24 13830554455654793216 13830554455654793216 13830554455654793216 13830554455654793216 := by decide
example : checkf64 9218868437227405311 0 9218868437227405311 20 4607182418800017408 9218868437227405311 1125899906842624 9218868437227405311 := by decide
example : checkf64 9218868437227405311 9223372036854775808 9218868437227405311 20 4607182418800017408 18442240474082181119 1125899906842624 9218868437227405311 := by decide
example : checkf64 18442240474082181119 0 18442240474082181119 24 13830554455654793216 9218868437227405311 9224497936761618432 18442240474082181119 := by decide
example : checkf64 18442240474082181119 9223372036854775808 18442240474082181119 24 13830554455654793216 18442240474082181119 9224497936761618432 18442240474082181119 := by decide
example : checkf64 9218868437227405312 0 9218868437227405312 6 4607182418800017408 9218868437227405312 0 9218868437227405312 := by decide
example : checkf64 9218868437227405312 9223372036854775808 9218868437227405312 6 4607182418800017408 18442240474082181120 0 9218868437227405312 := by decide
example : checkf64 18442240474082181120 0 18442240474082181120 10 13830554455654793216 9218868437227405312 9223372036854775808 18442240474082181120 := by decide
example : checkf64 18442240474082181120 9223372036854775808 18442240474082181120 10 13830554455654793216 18442240474082181120 9223372036854775808 18442240474082181120 := by decide
example : checkNaN64 9221120237041090560 0 := by decide
example : checkNaN64 9221120237041090560 9223372036854775808 := by decide
example : checkNaN64 18444492273895866368 0 := by decide
example : checkNaN64 18444492273895866368 9223372036854775808 := by decide
example : checkNaN64 9218868437227405313 0 := by decide
example : checkNaN64 9218868437227405313 9223372036854775808 := by decide
example : checkNaN64 18442240474082181121 0 := by decide
example : checkNaN64 18442240474082181121 9223372036854775808 := by decide
example : checkNaN64 9221120237041090561 0 := by decide
example : checkNaN64 9221120237041090561 9223372036854775808 := by decide
example : checkNaN64 9223372036854775807 0 := by decide
example : checkNaN64 9223372036854775807 9223372036854775808 := by decide
example : checkNaN64 18446744073709551615 0 := by decide
example : checkNaN64 18446744073709551615 9223372036854775808 := by decide
example : checkNaN64 9219994337134247936 0 := by decide
example : checkNaN64 9219994337134247936 9223372036854775808 := by decide
example : checkf64 4614256656552045848 0 4614256656552045848 20 4607182418800017408 4614256656552045848 4599405781057128579 4614256656552045848 := by decide
example : checkf64 4614256656552045848 9223372036854775808 4614256656552045848 20 4607182418800017408 13837628693406821656 4599405781057128579 4614256656552045848 := by decide
example : checkf64 2251799813685248 0 2251799813685248 36 4607182418800017408 2251799813685248 9214364837600034816 2251799813685248 := by decide
example : checkf64 2251799813685248 9223372036854775808 2251799813685248 36 4607182418800017408 9225623836668461056 9214364837600034816 2251799813685248 := by decide

/-! ## NaN: reading a NaN's sign or bits fails in the model

Lean's model has a single NaN, but Rust keeps a NaN's sign and payload. So `to_bits`,
`is_sign_negative` and `is_sign_positive` of a NaN, and `copysign` with a NaN sign, fail with
`undef`. -/

example : core.f32.to_bits (core.f32.from_bits 0xFFC00000#u32) = .fail .undef :=
  core.f32.to_bits_nan _ (by decide)
example : core.f64.to_bits (Float.ofBits 0x7FF0000000000001) = .fail .undef :=
  core.f64.to_bits_nan _ (by decide)
example : core.f32.is_sign_negative (Float32.ofBits 0x7FC00000) = .fail .undef :=
  core.f32.is_sign_negative_nan _ (by decide)
example : core.f64.is_sign_positive (Float.ofBits 0xFFF8000000000000) = .fail .undef :=
  core.f64.is_sign_positive_nan _ (by decide)
example : core.f32.copysign (Float32.ofBits 0x3F800000) (Float32.ofBits 0xFFC00000) =
    .fail .undef :=
  core.f32.copysign_nan _ _ (by decide)
example : core.f64.copysign (Float.ofBits 0x3FF0000000000000) (Float.ofBits 0xFFF8000000000000) =
    .fail .undef :=
  core.f64.copysign_nan _ _ (by decide)

/-- A NaN *magnitude* is fine: the result is `ok` of a NaN. -/
example : core.f64.copysign (Float.ofBits 0x7FF8000000000000) (Float.ofBits 0xBFF0000000000000) =
    .ok (core.f64.copysignBits (Float.ofBits 0x7FF8000000000000)
      (Float.ofBits 0xBFF0000000000000)) := by
  have h : (Float.ofBits 0xBFF0000000000000).isNaN = false := by decide
  simp [core.f64.copysign, h]
example : (core.f64.copysignBits (Float.ofBits 0x7FF8000000000000)
    (Float.ofBits 0xBFF0000000000000)).isNaN = true := by decide

/-- Rust guarantees that negating a NaN flips its sign bit, so
`(-a).is_sign_negative() != a.is_sign_negative()` is `true` in Rust for every NaN `a`. In Lean
`-a = a`, so a model that gave any fixed answer here would prove it `false`. The model fails
instead, whichever side is evaluated first. -/
example :
    (let a := Float.ofBits 0xFFF8000000000000
     (do let n ← core.f64.is_sign_negative (-a)
         let m ← core.f64.is_sign_negative a
         pure (n != m) : Result Bool)) = .fail .undef := by
  simp only
  rw [core.f64.is_sign_negative_nan _ (by decide)]
  simp
example (a : Float) (h : a.isNaN = true) :
    ((do let m ← core.f64.is_sign_negative a
         let n ← core.f64.is_sign_negative (-a)
         pure (n != m)) : Result Bool) = .fail .undef := by
  rw [core.f64.is_sign_negative_nan _ h]
  simp

/-! Non-NaN inputs are unchanged (spot checks; the tables above check the rest). -/

example : core.f32.to_bits (Float32.ofBits 0x80000000) = .ok 0x80000000#u32 := by
  have h : (Float32.ofBits 0x80000000).isNaN = false := by decide
  simp only [core.f32.to_bits, h, Bool.false_eq_true, ↓reduceIte]; rfl
example : core.f64.is_sign_negative (Float.ofBits 0x8000000000000000) = .ok true := by
  have h : (Float.ofBits 0x8000000000000000).isNaN = false := by decide
  simp only [core.f64.is_sign_negative, h, Bool.false_eq_true, ↓reduceIte]; rfl
example : core.f64.copysign (Float.ofBits 0x400C000000000000) (Float.ofBits 0x8000000000000000) =
    .ok (Float.ofBits 0xC00C000000000000) := by
  have h : (Float.ofBits 0x8000000000000000).isNaN = false := by decide
  simp only [core.f64.copysign, h, Bool.false_eq_true, ↓reduceIte]; rfl

/-! ## Compiled code (`#guard`)

Compiled code runs the same definitions, so it also fails on a NaN. -/

/-- `r` fails with `undef`. -/
def failsUndef {α : Type} (r : Result α) : Bool :=
  match r.match with
  | .vis (.fail .undef) _ => true
  | _ => false

#guard failsUndef (core.f32.to_bits (core.f32.from_bits 0xFFC00000#u32))
#guard failsUndef (core.f32.to_bits (0 / 0))
#guard failsUndef (core.f64.to_bits (0 / 0))
#guard failsUndef (core.f32.is_sign_positive (0 / 0))
#guard failsUndef (core.f64.is_sign_negative (Float.ofBits 0xFFF8000000000000))
#guard failsUndef (core.f32.copysign 1 (0 / 0))
#guard failsUndef (core.f64.copysign 1 (0 / 0))
#guard (core.f32.to_bits 1).reducesTo 0x3F800000#u32
#guard (core.f64.to_bits (-0)).reducesTo 0x8000000000000000#u64
#guard (core.f64.is_sign_negative (-0)).reducesTo true
#guard (core.f32.is_sign_positive (-1)).reducesTo false
#guard (core.f64.copysign 3.5 (-0)).reducesTo (-3.5)
#guard ((core.f32.copysign (0 / 0) (-1)).reducesTo (0 / 0)) == false
#guard (Option.ofResult (core.f32.copysign (0 / 0) (-1))).map Float32.isNaN == some true
