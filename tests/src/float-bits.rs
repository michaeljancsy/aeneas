//@ [!lean] skip
#![feature(register_tool)]
#![register_tool(verify)]
#![feature(more_float_constants)]
//! Float bits, classification, sign and the standard constants. The constants and methods
//! are modelled in the Lean standard library (no axioms). NaN payloads and signs are not
//! modelled (Lean has a single NaN), so the tests only use NaN where Rust and the model agree.

pub fn div32(x: f32, y: f32) -> f32 {
    x / y
}
pub fn div64(x: f64, y: f64) -> f64 {
    x / y
}

#[verify::test]
pub fn test_bits32() {
    assert!(1.0f32.to_bits() == 0x3f80_0000);
    assert!((-0.0f32).to_bits() == 0x8000_0000);
    assert!(f32::from_bits(0x4049_0fdb) == 3.14159265);
    assert!(f32::from_bits(1).to_bits() == 1);
    assert!(f32::from_bits(0xff80_0000) == f32::NEG_INFINITY);
    assert!(f32::from_bits(0x7fc0_0000).is_nan());
    assert!(f32::from_bits(0x7fc0_0000).to_bits() == 0x7fc0_0000);
    assert!(f32::from_bits(0x7f80_0001).is_nan());
    assert!(div32(0.0, 0.0).is_nan());
    assert!(!1.0f32.is_nan());
    assert!(f32::INFINITY.is_infinite());
    assert!(f32::NEG_INFINITY.is_infinite());
    assert!(!f32::MAX.is_infinite());
    assert!(!div32(0.0, 0.0).is_infinite());
}

#[verify::test]
pub fn test_classify32() {
    assert!(1.0f32.is_normal());
    assert!(f32::MIN_POSITIVE.is_normal());
    assert!(f32::MAX.is_normal());
    assert!(!0.0f32.is_normal());
    assert!(!f32::INFINITY.is_normal());
    assert!(!div32(0.0, 0.0).is_normal());
    assert!(!f32::from_bits(1).is_normal());
    assert!(f32::from_bits(1).is_subnormal());
    assert!(f32::from_bits(0x807f_ffff).is_subnormal());
    assert!(!f32::MIN_POSITIVE.is_subnormal());
    assert!(!0.0f32.is_subnormal());
    assert!(!(-0.0f32).is_subnormal());
    assert!(!div32(0.0, 0.0).is_subnormal());
    assert!(0.0f32.is_sign_positive());
    assert!((-0.0f32).is_sign_negative());
    assert!(!(-0.0f32).is_sign_positive());
    assert!(f32::NEG_INFINITY.is_sign_negative());
    assert!(f32::INFINITY.is_sign_positive());
    assert!(f32::from_bits(0x7fc0_0000).is_sign_positive());
}

#[verify::test]
pub fn test_sign32() {
    assert!(3.5f32.signum() == 1.0);
    assert!((-3.5f32).signum() == -1.0);
    assert!(0.0f32.signum().to_bits() == 0x3f80_0000);
    assert!((-0.0f32).signum().to_bits() == 0xbf80_0000);
    assert!(f32::NEG_INFINITY.signum() == -1.0);
    assert!(div32(0.0, 0.0).signum().is_nan());
    assert!(3.5f32.copysign(-0.0) == -3.5);
    assert!((-3.5f32).copysign(1.0) == 3.5);
    assert!(0.0f32.copysign(-1.0).to_bits() == 0x8000_0000);
    assert!(f32::INFINITY.copysign(-2.0) == f32::NEG_INFINITY);
    assert!(1.0f32.copysign(f32::from_bits(0x7fc0_0000)) == 1.0);
    assert!(div32(0.0, 0.0).copysign(-1.0).is_nan());
    assert!(2.0f32.recip() == 0.5);
    assert!(3.0f32.recip() == 0.333333343);
    assert!(0.0f32.recip() == f32::INFINITY);
    assert!((-0.0f32).recip() == f32::NEG_INFINITY);
    assert!(f32::INFINITY.recip().to_bits() == 0);
    assert!(f32::MAX.recip().is_subnormal());
    assert!(f32::from_bits(1).recip() == f32::INFINITY);
    assert!(div32(0.0, 0.0).recip().is_nan());
}

#[verify::test]
pub fn test_consts32() {
    use core::f32::consts;
    assert!(consts::PI.to_bits() == 0x4049_0fdb);
    assert!(consts::TAU.to_bits() == 0x40c9_0fdb);
    assert!(consts::GOLDEN_RATIO.to_bits() == 0x3fcf_1bbd);
    assert!(consts::EULER_GAMMA.to_bits() == 0x3f13_c468);
    assert!(consts::FRAC_PI_2.to_bits() == 0x3fc9_0fdb);
    assert!(consts::FRAC_PI_3.to_bits() == 0x3f86_0a92);
    assert!(consts::FRAC_PI_4.to_bits() == 0x3f49_0fdb);
    assert!(consts::FRAC_PI_6.to_bits() == 0x3f06_0a92);
    assert!(consts::FRAC_PI_8.to_bits() == 0x3ec9_0fdb);
    assert!(consts::FRAC_1_PI.to_bits() == 0x3ea2_f983);
    assert!(consts::FRAC_1_SQRT_PI.to_bits() == 0x3f10_6ebb);
    assert!(consts::FRAC_1_SQRT_2PI.to_bits() == 0x3ecc_422a);
    assert!(consts::FRAC_2_PI.to_bits() == 0x3f22_f983);
    assert!(consts::FRAC_2_SQRT_PI.to_bits() == 0x3f90_6ebb);
    assert!(consts::SQRT_2.to_bits() == 0x3fb5_04f3);
    assert!(consts::FRAC_1_SQRT_2.to_bits() == 0x3f35_04f3);
    assert!(consts::SQRT_3.to_bits() == 0x3fdd_b3d7);
    assert!(consts::FRAC_1_SQRT_3.to_bits() == 0x3f13_cd3a);
    assert!(consts::SQRT_5.to_bits() == 0x400f_1bbd);
    assert!(consts::FRAC_1_SQRT_5.to_bits() == 0x3ee4_f92e);
    assert!(consts::E.to_bits() == 0x402d_f854);
    assert!(consts::LOG2_E.to_bits() == 0x3fb8_aa3b);
    assert!(consts::LOG2_10.to_bits() == 0x4054_9a78);
    assert!(consts::LOG10_E.to_bits() == 0x3ede_5bd9);
    assert!(consts::LOG10_2.to_bits() == 0x3e9a_209b);
    assert!(consts::LN_2.to_bits() == 0x3f31_7218);
    assert!(consts::LN_10.to_bits() == 0x4013_5d8e);
    assert!(f32::EPSILON.to_bits() == 0x3400_0000);
    assert!(f32::MIN.to_bits() == 0xff7f_ffff);
    assert!(f32::MAX.to_bits() == 0x7f7f_ffff);
    assert!(f32::MIN_POSITIVE.to_bits() == 0x0080_0000);
    assert!(f32::INFINITY.to_bits() == 0x7f80_0000);
    assert!(f32::NEG_INFINITY.to_bits() == 0xff80_0000);
    assert!(f32::RADIX == 2);
    assert!(f32::MANTISSA_DIGITS == 24);
    assert!(f32::DIGITS == 6);
    assert!(f32::MIN_EXP == -125);
    assert!(f32::MAX_EXP == 128);
    assert!(f32::MIN_10_EXP == -37);
    assert!(f32::MAX_10_EXP == 38);
    assert!(1.0f32 + f32::EPSILON > 1.0);
    assert!(1.0f32 + f32::EPSILON / 2.0 == 1.0);
}

#[verify::test]
pub fn test_bits64() {
    assert!(1.0f64.to_bits() == 0x3ff0_0000_0000_0000);
    assert!((-0.0f64).to_bits() == 0x8000_0000_0000_0000);
    assert!(f64::from_bits(0x4009_21fb_5444_2d18) == 3.141592653589793);
    assert!(f64::from_bits(1).to_bits() == 1);
    assert!(f64::from_bits(0xfff0_0000_0000_0000) == f64::NEG_INFINITY);
    assert!(f64::from_bits(0x7ff8_0000_0000_0000).is_nan());
    assert!(f64::from_bits(0x7ff8_0000_0000_0000).to_bits() == 0x7ff8_0000_0000_0000);
    assert!(f64::from_bits(0x7ff0_0000_0000_0001).is_nan());
    assert!(div64(0.0, 0.0).is_nan());
    assert!(!1.0f64.is_nan());
    assert!(f64::INFINITY.is_infinite());
    assert!(f64::NEG_INFINITY.is_infinite());
    assert!(!f64::MAX.is_infinite());
    assert!(!div64(0.0, 0.0).is_infinite());
}

#[verify::test]
pub fn test_classify64() {
    assert!(1.0f64.is_normal());
    assert!(f64::MIN_POSITIVE.is_normal());
    assert!(f64::MAX.is_normal());
    assert!(!0.0f64.is_normal());
    assert!(!f64::INFINITY.is_normal());
    assert!(!div64(0.0, 0.0).is_normal());
    assert!(!f64::from_bits(1).is_normal());
    assert!(f64::from_bits(1).is_subnormal());
    assert!(f64::from_bits(0x800f_ffff_ffff_ffff).is_subnormal());
    assert!(!f64::MIN_POSITIVE.is_subnormal());
    assert!(!0.0f64.is_subnormal());
    assert!(!div64(0.0, 0.0).is_subnormal());
    assert!(0.0f64.is_sign_positive());
    assert!((-0.0f64).is_sign_negative());
    assert!(!(-0.0f64).is_sign_positive());
    assert!(f64::NEG_INFINITY.is_sign_negative());
    assert!(f64::from_bits(0x7ff8_0000_0000_0000).is_sign_positive());
}

#[verify::test]
pub fn test_sign64() {
    assert!(3.5f64.signum() == 1.0);
    assert!((-3.5f64).signum() == -1.0);
    assert!(0.0f64.signum().to_bits() == 0x3ff0_0000_0000_0000);
    assert!((-0.0f64).signum().to_bits() == 0xbff0_0000_0000_0000);
    assert!(div64(0.0, 0.0).signum().is_nan());
    assert!(3.5f64.copysign(-0.0) == -3.5);
    assert!(0.0f64.copysign(-1.0).to_bits() == 0x8000_0000_0000_0000);
    assert!(f64::INFINITY.copysign(-2.0) == f64::NEG_INFINITY);
    assert!(1.0f64.copysign(f64::from_bits(0x7ff8_0000_0000_0000)) == 1.0);
    assert!(div64(0.0, 0.0).copysign(-1.0).is_nan());
    assert!(2.0f64.recip() == 0.5);
    assert!(3.0f64.recip() == 0.3333333333333333);
    assert!((-0.0f64).recip() == f64::NEG_INFINITY);
    assert!(f64::MAX.recip().is_subnormal());
    assert!(div64(0.0, 0.0).recip().is_nan());
}

#[verify::test]
pub fn test_consts64() {
    use core::f64::consts;
    assert!(consts::PI.to_bits() == 0x4009_21fb_5444_2d18);
    assert!(consts::TAU.to_bits() == 0x4019_21fb_5444_2d18);
    assert!(consts::GOLDEN_RATIO.to_bits() == 0x3ff9_e377_9b97_f4a8);
    assert!(consts::EULER_GAMMA.to_bits() == 0x3fe2_788c_fc6f_b619);
    assert!(consts::FRAC_PI_2.to_bits() == 0x3ff9_21fb_5444_2d18);
    assert!(consts::FRAC_PI_3.to_bits() == 0x3ff0_c152_382d_7366);
    assert!(consts::FRAC_PI_4.to_bits() == 0x3fe9_21fb_5444_2d18);
    assert!(consts::FRAC_PI_6.to_bits() == 0x3fe0_c152_382d_7366);
    assert!(consts::FRAC_PI_8.to_bits() == 0x3fd9_21fb_5444_2d18);
    assert!(consts::FRAC_1_PI.to_bits() == 0x3fd4_5f30_6dc9_c883);
    assert!(consts::FRAC_1_SQRT_PI.to_bits() == 0x3fe2_0dd7_5042_9b6d);
    assert!(consts::FRAC_1_SQRT_2PI.to_bits() == 0x3fd9_8845_33d4_3651);
    assert!(consts::FRAC_2_PI.to_bits() == 0x3fe4_5f30_6dc9_c883);
    assert!(consts::FRAC_2_SQRT_PI.to_bits() == 0x3ff2_0dd7_5042_9b6d);
    assert!(consts::SQRT_2.to_bits() == 0x3ff6_a09e_667f_3bcd);
    assert!(consts::FRAC_1_SQRT_2.to_bits() == 0x3fe6_a09e_667f_3bcd);
    assert!(consts::SQRT_3.to_bits() == 0x3ffb_b67a_e858_4caa);
    assert!(consts::FRAC_1_SQRT_3.to_bits() == 0x3fe2_79a7_4590_331c);
    assert!(consts::SQRT_5.to_bits() == 0x4001_e377_9b97_f4a8);
    assert!(consts::FRAC_1_SQRT_5.to_bits() == 0x3fdc_9f25_c5bf_edd9);
    assert!(consts::E.to_bits() == 0x4005_bf0a_8b14_5769);
    assert!(consts::LOG2_E.to_bits() == 0x3ff7_1547_652b_82fe);
    assert!(consts::LOG2_10.to_bits() == 0x400a_934f_0979_a371);
    assert!(consts::LOG10_E.to_bits() == 0x3fdb_cb7b_1526_e50e);
    assert!(consts::LOG10_2.to_bits() == 0x3fd3_4413_509f_79ff);
    assert!(consts::LN_2.to_bits() == 0x3fe6_2e42_fefa_39ef);
    assert!(consts::LN_10.to_bits() == 0x4002_6bb1_bbb5_5516);
    assert!(f64::EPSILON.to_bits() == 0x3cb0_0000_0000_0000);
    assert!(f64::MIN.to_bits() == 0xffef_ffff_ffff_ffff);
    assert!(f64::MAX.to_bits() == 0x7fef_ffff_ffff_ffff);
    assert!(f64::MIN_POSITIVE.to_bits() == 0x0010_0000_0000_0000);
    assert!(f64::INFINITY.to_bits() == 0x7ff0_0000_0000_0000);
    assert!(f64::NEG_INFINITY.to_bits() == 0xfff0_0000_0000_0000);
    assert!(f64::RADIX == 2);
    assert!(f64::MANTISSA_DIGITS == 53);
    assert!(f64::DIGITS == 15);
    assert!(f64::MIN_EXP == -1021);
    assert!(f64::MAX_EXP == 1024);
    assert!(f64::MIN_10_EXP == -307);
    assert!(f64::MAX_10_EXP == 308);
    assert!(1.0f64 + f64::EPSILON > 1.0);
    assert!(1.0f64 + f64::EPSILON / 2.0 == 1.0);
}

/// The legacy module-level constants are the associated ones.
#[allow(deprecated, deprecated_in_future)]
#[verify::test]
pub fn test_legacy_consts() {
    assert!(core::f32::EPSILON.to_bits() == f32::EPSILON.to_bits());
    assert!(core::f32::MAX.to_bits() == f32::MAX.to_bits());
    assert!(core::f32::MIN_POSITIVE.to_bits() == f32::MIN_POSITIVE.to_bits());
    assert!(core::f32::NEG_INFINITY.to_bits() == f32::NEG_INFINITY.to_bits());
    assert!(core::f32::MANTISSA_DIGITS == 24);
    assert!(core::f64::EPSILON.to_bits() == f64::EPSILON.to_bits());
    assert!(core::f64::MIN.to_bits() == f64::MIN.to_bits());
    assert!(core::f64::INFINITY.to_bits() == f64::INFINITY.to_bits());
    assert!(core::f64::MIN_EXP == -1021);
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn native() {
        test_bits32();
        test_classify32();
        test_sign32();
        test_consts32();
        test_bits64();
        test_classify64();
        test_sign64();
        test_consts64();
        test_legacy_consts();
    }
}
