module
public import Aeneas.Std.Float
public import Aeneas.Std.Scalar.Core
public section

/-!
# Float constants

Rust's `f32`/`f64` associated constants (`EPSILON`, `MIN`, `MAX`, `MIN_POSITIVE`, `INFINITY`,
`NEG_INFINITY`, `RADIX`, `MANTISSA_DIGITS`, `DIGITS`, `MIN_EXP`, `MAX_EXP`, `MIN_10_EXP`,
`MAX_10_EXP`), the legacy module-level copies (`core::f32::EPSILON` and so on), and the
`core::f32::consts` / `core::f64::consts` modules. Each float constant is the exact bit pattern
Rust gives (`to_bits`). `NAN` is not modelled: Lean's logical model has a single NaN and the
literal translation has no NaN encoding.
-/
namespace Aeneas.Std

/-! ### `f64` constants -/

/-- `f64::EPSILON` (2.220446049250313e-16). -/
@[expose, rust_const "core::f64::{f64}::EPSILON"]
def core.f64.F64.EPSILON : Float := Float.ofBits 0x3CB0000000000000

/-- `f64::MIN` (-1.7976931348623157e308). -/
@[expose, rust_const "core::f64::{f64}::MIN"]
def core.f64.F64.MIN : Float := Float.ofBits 0xFFEFFFFFFFFFFFFF

/-- `f64::MAX` (1.7976931348623157e308). -/
@[expose, rust_const "core::f64::{f64}::MAX"]
def core.f64.F64.MAX : Float := Float.ofBits 0x7FEFFFFFFFFFFFFF

/-- `f64::MIN_POSITIVE` (2.2250738585072014e-308). -/
@[expose, rust_const "core::f64::{f64}::MIN_POSITIVE"]
def core.f64.F64.MIN_POSITIVE : Float := Float.ofBits 0x0010000000000000

/-- `f64::INFINITY` (inf). -/
@[expose, rust_const "core::f64::{f64}::INFINITY"]
def core.f64.F64.INFINITY : Float := Float.ofBits 0x7FF0000000000000

/-- `f64::NEG_INFINITY` (-inf). -/
@[expose, rust_const "core::f64::{f64}::NEG_INFINITY"]
def core.f64.F64.NEG_INFINITY : Float := Float.ofBits 0xFFF0000000000000

/-- `f64::RADIX`. -/
@[expose, reducible, rust_const "core::f64::{f64}::RADIX"]
def core.f64.F64.RADIX : U32 := UScalar.ofNat 2

/-- `f64::MANTISSA_DIGITS`. -/
@[expose, reducible, rust_const "core::f64::{f64}::MANTISSA_DIGITS"]
def core.f64.F64.MANTISSA_DIGITS : U32 := UScalar.ofNat 53

/-- `f64::DIGITS`. -/
@[expose, reducible, rust_const "core::f64::{f64}::DIGITS"]
def core.f64.F64.DIGITS : U32 := UScalar.ofNat 15

/-- `f64::MIN_EXP`. -/
@[expose, reducible, rust_const "core::f64::{f64}::MIN_EXP"]
def core.f64.F64.MIN_EXP : I32 := IScalar.ofInt (-1021)

/-- `f64::MAX_EXP`. -/
@[expose, reducible, rust_const "core::f64::{f64}::MAX_EXP"]
def core.f64.F64.MAX_EXP : I32 := IScalar.ofInt 1024

/-- `f64::MIN_10_EXP`. -/
@[expose, reducible, rust_const "core::f64::{f64}::MIN_10_EXP"]
def core.f64.F64.MIN_10_EXP : I32 := IScalar.ofInt (-307)

/-- `f64::MAX_10_EXP`. -/
@[expose, reducible, rust_const "core::f64::{f64}::MAX_10_EXP"]
def core.f64.F64.MAX_10_EXP : I32 := IScalar.ofInt 308

/-! The `core::f64::consts` module (bits from Rust's `to_bits`). -/

/-- `core::f64::consts::PI` (3.141592653589793e0). -/
@[expose, rust_const "core::f64::consts::PI"]
def core.f64.consts.PI : Float := Float.ofBits 0x400921FB54442D18

/-- `core::f64::consts::TAU` (6.283185307179586e0). -/
@[expose, rust_const "core::f64::consts::TAU"]
def core.f64.consts.TAU : Float := Float.ofBits 0x401921FB54442D18

/-- `core::f64::consts::GOLDEN_RATIO` (1.618033988749895e0).
Unstable in Rust (`more_float_constants`). -/
@[expose, rust_const "core::f64::consts::GOLDEN_RATIO"]
def core.f64.consts.GOLDEN_RATIO : Float := Float.ofBits 0x3FF9E3779B97F4A8

/-- `core::f64::consts::EULER_GAMMA` (5.772156649015329e-1).
Unstable in Rust (`more_float_constants`). -/
@[expose, rust_const "core::f64::consts::EULER_GAMMA"]
def core.f64.consts.EULER_GAMMA : Float := Float.ofBits 0x3FE2788CFC6FB619

/-- `core::f64::consts::FRAC_PI_2` (1.5707963267948966e0). -/
@[expose, rust_const "core::f64::consts::FRAC_PI_2"]
def core.f64.consts.FRAC_PI_2 : Float := Float.ofBits 0x3FF921FB54442D18

/-- `core::f64::consts::FRAC_PI_3` (1.0471975511965979e0). -/
@[expose, rust_const "core::f64::consts::FRAC_PI_3"]
def core.f64.consts.FRAC_PI_3 : Float := Float.ofBits 0x3FF0C152382D7366

/-- `core::f64::consts::FRAC_PI_4` (7.853981633974483e-1). -/
@[expose, rust_const "core::f64::consts::FRAC_PI_4"]
def core.f64.consts.FRAC_PI_4 : Float := Float.ofBits 0x3FE921FB54442D18

/-- `core::f64::consts::FRAC_PI_6` (5.235987755982989e-1). -/
@[expose, rust_const "core::f64::consts::FRAC_PI_6"]
def core.f64.consts.FRAC_PI_6 : Float := Float.ofBits 0x3FE0C152382D7366

/-- `core::f64::consts::FRAC_PI_8` (3.9269908169872414e-1). -/
@[expose, rust_const "core::f64::consts::FRAC_PI_8"]
def core.f64.consts.FRAC_PI_8 : Float := Float.ofBits 0x3FD921FB54442D18

/-- `core::f64::consts::FRAC_1_PI` (3.183098861837907e-1). -/
@[expose, rust_const "core::f64::consts::FRAC_1_PI"]
def core.f64.consts.FRAC_1_PI : Float := Float.ofBits 0x3FD45F306DC9C883

/-- `core::f64::consts::FRAC_1_SQRT_PI` (5.641895835477563e-1).
Unstable in Rust (`more_float_constants`). -/
@[expose, rust_const "core::f64::consts::FRAC_1_SQRT_PI"]
def core.f64.consts.FRAC_1_SQRT_PI : Float := Float.ofBits 0x3FE20DD750429B6D

/-- `core::f64::consts::FRAC_1_SQRT_2PI` (3.989422804014327e-1).
Unstable in Rust (`more_float_constants`). -/
@[expose, rust_const "core::f64::consts::FRAC_1_SQRT_2PI"]
def core.f64.consts.FRAC_1_SQRT_2PI : Float := Float.ofBits 0x3FD9884533D43651

/-- `core::f64::consts::FRAC_2_PI` (6.366197723675814e-1). -/
@[expose, rust_const "core::f64::consts::FRAC_2_PI"]
def core.f64.consts.FRAC_2_PI : Float := Float.ofBits 0x3FE45F306DC9C883

/-- `core::f64::consts::FRAC_2_SQRT_PI` (1.1283791670955126e0). -/
@[expose, rust_const "core::f64::consts::FRAC_2_SQRT_PI"]
def core.f64.consts.FRAC_2_SQRT_PI : Float := Float.ofBits 0x3FF20DD750429B6D

/-- `core::f64::consts::SQRT_2` (1.4142135623730951e0). -/
@[expose, rust_const "core::f64::consts::SQRT_2"]
def core.f64.consts.SQRT_2 : Float := Float.ofBits 0x3FF6A09E667F3BCD

/-- `core::f64::consts::FRAC_1_SQRT_2` (7.071067811865476e-1). -/
@[expose, rust_const "core::f64::consts::FRAC_1_SQRT_2"]
def core.f64.consts.FRAC_1_SQRT_2 : Float := Float.ofBits 0x3FE6A09E667F3BCD

/-- `core::f64::consts::SQRT_3` (1.7320508075688772e0).
Unstable in Rust (`more_float_constants`). -/
@[expose, rust_const "core::f64::consts::SQRT_3"]
def core.f64.consts.SQRT_3 : Float := Float.ofBits 0x3FFBB67AE8584CAA

/-- `core::f64::consts::FRAC_1_SQRT_3` (5.773502691896257e-1).
Unstable in Rust (`more_float_constants`). -/
@[expose, rust_const "core::f64::consts::FRAC_1_SQRT_3"]
def core.f64.consts.FRAC_1_SQRT_3 : Float := Float.ofBits 0x3FE279A74590331C

/-- `core::f64::consts::SQRT_5` (2.23606797749979e0).
Unstable in Rust (`more_float_constants`). -/
@[expose, rust_const "core::f64::consts::SQRT_5"]
def core.f64.consts.SQRT_5 : Float := Float.ofBits 0x4001E3779B97F4A8

/-- `core::f64::consts::FRAC_1_SQRT_5` (4.472135954999579e-1).
Unstable in Rust (`more_float_constants`). -/
@[expose, rust_const "core::f64::consts::FRAC_1_SQRT_5"]
def core.f64.consts.FRAC_1_SQRT_5 : Float := Float.ofBits 0x3FDC9F25C5BFEDD9

/-- `core::f64::consts::E` (2.718281828459045e0). -/
@[expose, rust_const "core::f64::consts::E"]
def core.f64.consts.E : Float := Float.ofBits 0x4005BF0A8B145769

/-- `core::f64::consts::LOG2_E` (1.4426950408889634e0). -/
@[expose, rust_const "core::f64::consts::LOG2_E"]
def core.f64.consts.LOG2_E : Float := Float.ofBits 0x3FF71547652B82FE

/-- `core::f64::consts::LOG2_10` (3.321928094887362e0). -/
@[expose, rust_const "core::f64::consts::LOG2_10"]
def core.f64.consts.LOG2_10 : Float := Float.ofBits 0x400A934F0979A371

/-- `core::f64::consts::LOG10_E` (4.342944819032518e-1). -/
@[expose, rust_const "core::f64::consts::LOG10_E"]
def core.f64.consts.LOG10_E : Float := Float.ofBits 0x3FDBCB7B1526E50E

/-- `core::f64::consts::LOG10_2` (3.010299956639812e-1). -/
@[expose, rust_const "core::f64::consts::LOG10_2"]
def core.f64.consts.LOG10_2 : Float := Float.ofBits 0x3FD34413509F79FF

/-- `core::f64::consts::LN_2` (6.931471805599453e-1). -/
@[expose, rust_const "core::f64::consts::LN_2"]
def core.f64.consts.LN_2 : Float := Float.ofBits 0x3FE62E42FEFA39EF

/-- `core::f64::consts::LN_10` (2.302585092994046e0). -/
@[expose, rust_const "core::f64::consts::LN_10"]
def core.f64.consts.LN_10 : Float := Float.ofBits 0x40026BB1BBB55516

/-! The legacy module-level constants (`core::f64::EPSILON` and so on), equal to the
associated ones. -/

@[expose, reducible, rust_const "core::f64::RADIX"]
def core.f64.RADIX : U32 := core.f64.F64.RADIX

@[expose, reducible, rust_const "core::f64::MANTISSA_DIGITS"]
def core.f64.MANTISSA_DIGITS : U32 := core.f64.F64.MANTISSA_DIGITS

@[expose, reducible, rust_const "core::f64::DIGITS"]
def core.f64.DIGITS : U32 := core.f64.F64.DIGITS

@[expose, rust_const "core::f64::EPSILON"]
def core.f64.EPSILON : Float := core.f64.F64.EPSILON

@[expose, rust_const "core::f64::MIN"]
def core.f64.MIN : Float := core.f64.F64.MIN

@[expose, rust_const "core::f64::MIN_POSITIVE"]
def core.f64.MIN_POSITIVE : Float := core.f64.F64.MIN_POSITIVE

@[expose, rust_const "core::f64::MAX"]
def core.f64.MAX : Float := core.f64.F64.MAX

@[expose, reducible, rust_const "core::f64::MIN_EXP"]
def core.f64.MIN_EXP : I32 := core.f64.F64.MIN_EXP

@[expose, reducible, rust_const "core::f64::MAX_EXP"]
def core.f64.MAX_EXP : I32 := core.f64.F64.MAX_EXP

@[expose, reducible, rust_const "core::f64::MIN_10_EXP"]
def core.f64.MIN_10_EXP : I32 := core.f64.F64.MIN_10_EXP

@[expose, reducible, rust_const "core::f64::MAX_10_EXP"]
def core.f64.MAX_10_EXP : I32 := core.f64.F64.MAX_10_EXP

@[expose, rust_const "core::f64::INFINITY"]
def core.f64.INFINITY : Float := core.f64.F64.INFINITY

@[expose, rust_const "core::f64::NEG_INFINITY"]
def core.f64.NEG_INFINITY : Float := core.f64.F64.NEG_INFINITY

/-! ### `f32` constants -/

/-- `f32::EPSILON` (1.1920929e-7). -/
@[expose, rust_const "core::f32::{f32}::EPSILON"]
def core.f32.F32.EPSILON : Float32 := Float32.ofBits 0x34000000

/-- `f32::MIN` (-3.4028235e38). -/
@[expose, rust_const "core::f32::{f32}::MIN"]
def core.f32.F32.MIN : Float32 := Float32.ofBits 0xFF7FFFFF

/-- `f32::MAX` (3.4028235e38). -/
@[expose, rust_const "core::f32::{f32}::MAX"]
def core.f32.F32.MAX : Float32 := Float32.ofBits 0x7F7FFFFF

/-- `f32::MIN_POSITIVE` (1.1754944e-38). -/
@[expose, rust_const "core::f32::{f32}::MIN_POSITIVE"]
def core.f32.F32.MIN_POSITIVE : Float32 := Float32.ofBits 0x00800000

/-- `f32::INFINITY` (inf). -/
@[expose, rust_const "core::f32::{f32}::INFINITY"]
def core.f32.F32.INFINITY : Float32 := Float32.ofBits 0x7F800000

/-- `f32::NEG_INFINITY` (-inf). -/
@[expose, rust_const "core::f32::{f32}::NEG_INFINITY"]
def core.f32.F32.NEG_INFINITY : Float32 := Float32.ofBits 0xFF800000

/-- `f32::RADIX`. -/
@[expose, reducible, rust_const "core::f32::{f32}::RADIX"]
def core.f32.F32.RADIX : U32 := UScalar.ofNat 2

/-- `f32::MANTISSA_DIGITS`. -/
@[expose, reducible, rust_const "core::f32::{f32}::MANTISSA_DIGITS"]
def core.f32.F32.MANTISSA_DIGITS : U32 := UScalar.ofNat 24

/-- `f32::DIGITS`. -/
@[expose, reducible, rust_const "core::f32::{f32}::DIGITS"]
def core.f32.F32.DIGITS : U32 := UScalar.ofNat 6

/-- `f32::MIN_EXP`. -/
@[expose, reducible, rust_const "core::f32::{f32}::MIN_EXP"]
def core.f32.F32.MIN_EXP : I32 := IScalar.ofInt (-125)

/-- `f32::MAX_EXP`. -/
@[expose, reducible, rust_const "core::f32::{f32}::MAX_EXP"]
def core.f32.F32.MAX_EXP : I32 := IScalar.ofInt 128

/-- `f32::MIN_10_EXP`. -/
@[expose, reducible, rust_const "core::f32::{f32}::MIN_10_EXP"]
def core.f32.F32.MIN_10_EXP : I32 := IScalar.ofInt (-37)

/-- `f32::MAX_10_EXP`. -/
@[expose, reducible, rust_const "core::f32::{f32}::MAX_10_EXP"]
def core.f32.F32.MAX_10_EXP : I32 := IScalar.ofInt 38

/-! The `core::f32::consts` module (bits from Rust's `to_bits`). -/

/-- `core::f32::consts::PI` (3.1415927e0). -/
@[expose, rust_const "core::f32::consts::PI"]
def core.f32.consts.PI : Float32 := Float32.ofBits 0x40490FDB

/-- `core::f32::consts::TAU` (6.2831855e0). -/
@[expose, rust_const "core::f32::consts::TAU"]
def core.f32.consts.TAU : Float32 := Float32.ofBits 0x40C90FDB

/-- `core::f32::consts::GOLDEN_RATIO` (1.618034e0).
Unstable in Rust (`more_float_constants`). -/
@[expose, rust_const "core::f32::consts::GOLDEN_RATIO"]
def core.f32.consts.GOLDEN_RATIO : Float32 := Float32.ofBits 0x3FCF1BBD

/-- `core::f32::consts::EULER_GAMMA` (5.772157e-1).
Unstable in Rust (`more_float_constants`). -/
@[expose, rust_const "core::f32::consts::EULER_GAMMA"]
def core.f32.consts.EULER_GAMMA : Float32 := Float32.ofBits 0x3F13C468

/-- `core::f32::consts::FRAC_PI_2` (1.5707964e0). -/
@[expose, rust_const "core::f32::consts::FRAC_PI_2"]
def core.f32.consts.FRAC_PI_2 : Float32 := Float32.ofBits 0x3FC90FDB

/-- `core::f32::consts::FRAC_PI_3` (1.0471976e0). -/
@[expose, rust_const "core::f32::consts::FRAC_PI_3"]
def core.f32.consts.FRAC_PI_3 : Float32 := Float32.ofBits 0x3F860A92

/-- `core::f32::consts::FRAC_PI_4` (7.853982e-1). -/
@[expose, rust_const "core::f32::consts::FRAC_PI_4"]
def core.f32.consts.FRAC_PI_4 : Float32 := Float32.ofBits 0x3F490FDB

/-- `core::f32::consts::FRAC_PI_6` (5.235988e-1). -/
@[expose, rust_const "core::f32::consts::FRAC_PI_6"]
def core.f32.consts.FRAC_PI_6 : Float32 := Float32.ofBits 0x3F060A92

/-- `core::f32::consts::FRAC_PI_8` (3.926991e-1). -/
@[expose, rust_const "core::f32::consts::FRAC_PI_8"]
def core.f32.consts.FRAC_PI_8 : Float32 := Float32.ofBits 0x3EC90FDB

/-- `core::f32::consts::FRAC_1_PI` (3.1830987e-1). -/
@[expose, rust_const "core::f32::consts::FRAC_1_PI"]
def core.f32.consts.FRAC_1_PI : Float32 := Float32.ofBits 0x3EA2F983

/-- `core::f32::consts::FRAC_1_SQRT_PI` (5.641896e-1).
Unstable in Rust (`more_float_constants`). -/
@[expose, rust_const "core::f32::consts::FRAC_1_SQRT_PI"]
def core.f32.consts.FRAC_1_SQRT_PI : Float32 := Float32.ofBits 0x3F106EBB

/-- `core::f32::consts::FRAC_1_SQRT_2PI` (3.989423e-1).
Unstable in Rust (`more_float_constants`). -/
@[expose, rust_const "core::f32::consts::FRAC_1_SQRT_2PI"]
def core.f32.consts.FRAC_1_SQRT_2PI : Float32 := Float32.ofBits 0x3ECC422A

/-- `core::f32::consts::FRAC_2_PI` (6.3661975e-1). -/
@[expose, rust_const "core::f32::consts::FRAC_2_PI"]
def core.f32.consts.FRAC_2_PI : Float32 := Float32.ofBits 0x3F22F983

/-- `core::f32::consts::FRAC_2_SQRT_PI` (1.1283792e0). -/
@[expose, rust_const "core::f32::consts::FRAC_2_SQRT_PI"]
def core.f32.consts.FRAC_2_SQRT_PI : Float32 := Float32.ofBits 0x3F906EBB

/-- `core::f32::consts::SQRT_2` (1.4142135e0). -/
@[expose, rust_const "core::f32::consts::SQRT_2"]
def core.f32.consts.SQRT_2 : Float32 := Float32.ofBits 0x3FB504F3

/-- `core::f32::consts::FRAC_1_SQRT_2` (7.0710677e-1). -/
@[expose, rust_const "core::f32::consts::FRAC_1_SQRT_2"]
def core.f32.consts.FRAC_1_SQRT_2 : Float32 := Float32.ofBits 0x3F3504F3

/-- `core::f32::consts::SQRT_3` (1.7320508e0).
Unstable in Rust (`more_float_constants`). -/
@[expose, rust_const "core::f32::consts::SQRT_3"]
def core.f32.consts.SQRT_3 : Float32 := Float32.ofBits 0x3FDDB3D7

/-- `core::f32::consts::FRAC_1_SQRT_3` (5.7735026e-1).
Unstable in Rust (`more_float_constants`). -/
@[expose, rust_const "core::f32::consts::FRAC_1_SQRT_3"]
def core.f32.consts.FRAC_1_SQRT_3 : Float32 := Float32.ofBits 0x3F13CD3A

/-- `core::f32::consts::SQRT_5` (2.236068e0).
Unstable in Rust (`more_float_constants`). -/
@[expose, rust_const "core::f32::consts::SQRT_5"]
def core.f32.consts.SQRT_5 : Float32 := Float32.ofBits 0x400F1BBD

/-- `core::f32::consts::FRAC_1_SQRT_5` (4.472136e-1).
Unstable in Rust (`more_float_constants`). -/
@[expose, rust_const "core::f32::consts::FRAC_1_SQRT_5"]
def core.f32.consts.FRAC_1_SQRT_5 : Float32 := Float32.ofBits 0x3EE4F92E

/-- `core::f32::consts::E` (2.7182817e0). -/
@[expose, rust_const "core::f32::consts::E"]
def core.f32.consts.E : Float32 := Float32.ofBits 0x402DF854

/-- `core::f32::consts::LOG2_E` (1.442695e0). -/
@[expose, rust_const "core::f32::consts::LOG2_E"]
def core.f32.consts.LOG2_E : Float32 := Float32.ofBits 0x3FB8AA3B

/-- `core::f32::consts::LOG2_10` (3.321928e0). -/
@[expose, rust_const "core::f32::consts::LOG2_10"]
def core.f32.consts.LOG2_10 : Float32 := Float32.ofBits 0x40549A78

/-- `core::f32::consts::LOG10_E` (4.342945e-1). -/
@[expose, rust_const "core::f32::consts::LOG10_E"]
def core.f32.consts.LOG10_E : Float32 := Float32.ofBits 0x3EDE5BD9

/-- `core::f32::consts::LOG10_2` (3.0103e-1). -/
@[expose, rust_const "core::f32::consts::LOG10_2"]
def core.f32.consts.LOG10_2 : Float32 := Float32.ofBits 0x3E9A209B

/-- `core::f32::consts::LN_2` (6.931472e-1). -/
@[expose, rust_const "core::f32::consts::LN_2"]
def core.f32.consts.LN_2 : Float32 := Float32.ofBits 0x3F317218

/-- `core::f32::consts::LN_10` (2.3025851e0). -/
@[expose, rust_const "core::f32::consts::LN_10"]
def core.f32.consts.LN_10 : Float32 := Float32.ofBits 0x40135D8E

/-! The legacy module-level constants (`core::f32::EPSILON` and so on), equal to the
associated ones. -/

@[expose, reducible, rust_const "core::f32::RADIX"]
def core.f32.RADIX : U32 := core.f32.F32.RADIX

@[expose, reducible, rust_const "core::f32::MANTISSA_DIGITS"]
def core.f32.MANTISSA_DIGITS : U32 := core.f32.F32.MANTISSA_DIGITS

@[expose, reducible, rust_const "core::f32::DIGITS"]
def core.f32.DIGITS : U32 := core.f32.F32.DIGITS

@[expose, rust_const "core::f32::EPSILON"]
def core.f32.EPSILON : Float32 := core.f32.F32.EPSILON

@[expose, rust_const "core::f32::MIN"]
def core.f32.MIN : Float32 := core.f32.F32.MIN

@[expose, rust_const "core::f32::MIN_POSITIVE"]
def core.f32.MIN_POSITIVE : Float32 := core.f32.F32.MIN_POSITIVE

@[expose, rust_const "core::f32::MAX"]
def core.f32.MAX : Float32 := core.f32.F32.MAX

@[expose, reducible, rust_const "core::f32::MIN_EXP"]
def core.f32.MIN_EXP : I32 := core.f32.F32.MIN_EXP

@[expose, reducible, rust_const "core::f32::MAX_EXP"]
def core.f32.MAX_EXP : I32 := core.f32.F32.MAX_EXP

@[expose, reducible, rust_const "core::f32::MIN_10_EXP"]
def core.f32.MIN_10_EXP : I32 := core.f32.F32.MIN_10_EXP

@[expose, reducible, rust_const "core::f32::MAX_10_EXP"]
def core.f32.MAX_10_EXP : I32 := core.f32.F32.MAX_10_EXP

@[expose, rust_const "core::f32::INFINITY"]
def core.f32.INFINITY : Float32 := core.f32.F32.INFINITY

@[expose, rust_const "core::f32::NEG_INFINITY"]
def core.f32.NEG_INFINITY : Float32 := core.f32.F32.NEG_INFINITY

end Aeneas.Std
