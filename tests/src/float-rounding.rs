//@ [!lean] skip
#![feature(register_tool)]
#![register_tool(verify)]
//! Rounding to an integer (`floor`, `ceil`, `trunc`, `round`, `round_ties_even`, `fract`),
//! `min`, `max`, `clamp` and `mul_add` on `f32` and `f64`. Signed zeros are told apart by
//! dividing `1.0` by them.

pub fn div64(x: f64, y: f64) -> f64 {
    x / y
}
pub fn div32(x: f32, y: f32) -> f32 {
    x / y
}

pub fn floor64(x: f64) -> f64 {
    x.floor()
}
pub fn ceil64(x: f64) -> f64 {
    x.ceil()
}
pub fn trunc64(x: f64) -> f64 {
    x.trunc()
}
pub fn round64(x: f64) -> f64 {
    x.round()
}
pub fn round_ties_even64(x: f64) -> f64 {
    x.round_ties_even()
}
pub fn fract64(x: f64) -> f64 {
    x.fract()
}
pub fn min64(x: f64, y: f64) -> f64 {
    x.min(y)
}
pub fn max64(x: f64, y: f64) -> f64 {
    x.max(y)
}
pub fn clamp64(x: f64, lo: f64, hi: f64) -> f64 {
    x.clamp(lo, hi)
}
pub fn mul_add64(x: f64, a: f64, b: f64) -> f64 {
    x.mul_add(a, b)
}

pub fn floor32(x: f32) -> f32 {
    x.floor()
}
pub fn ceil32(x: f32) -> f32 {
    x.ceil()
}
pub fn trunc32(x: f32) -> f32 {
    x.trunc()
}
pub fn round32(x: f32) -> f32 {
    x.round()
}
pub fn round_ties_even32(x: f32) -> f32 {
    x.round_ties_even()
}
pub fn fract32(x: f32) -> f32 {
    x.fract()
}
pub fn min32(x: f32, y: f32) -> f32 {
    x.min(y)
}
pub fn max32(x: f32, y: f32) -> f32 {
    x.max(y)
}
pub fn clamp32(x: f32, lo: f32, hi: f32) -> f32 {
    x.clamp(lo, hi)
}
pub fn mul_add32(x: f32, a: f32, b: f32) -> f32 {
    x.mul_add(a, b)
}

pub fn is_neg_zero64(x: f64) -> bool {
    x == 0.0 && div64(1.0, x) < 0.0
}
pub fn is_pos_zero64(x: f64) -> bool {
    x == 0.0 && div64(1.0, x) > 0.0
}
pub fn is_neg_zero32(x: f32) -> bool {
    x == 0.0 && div32(1.0, x) < 0.0
}
pub fn is_pos_zero32(x: f32) -> bool {
    x == 0.0 && div32(1.0, x) > 0.0
}

#[verify::test]
pub fn test_round64() {
    let inf = div64(1.0, 0.0);
    let nan = div64(0.0, 0.0);
    // floor
    assert!(floor64(1.5) == 1.0);
    assert!(floor64(-1.5) == -2.0);
    assert!(floor64(-0.5) == -1.0);
    assert!(is_pos_zero64(floor64(0.5)));
    assert!(is_neg_zero64(floor64(-0.0)));
    assert!(is_pos_zero64(floor64(5e-324)));
    assert!(floor64(-5e-324) == -1.0);
    assert!(floor64(4503599627370495.5) == 4503599627370495.0);
    assert!(floor64(1e300) == 1e300);
    assert!(floor64(-inf) == -inf);
    let r = floor64(nan);
    assert!(r != r);
    // ceil
    assert!(ceil64(1.5) == 2.0);
    assert!(ceil64(-1.5) == -1.0);
    assert!(is_neg_zero64(ceil64(-0.5)));
    assert!(ceil64(5e-324) == 1.0);
    assert!(is_neg_zero64(ceil64(-5e-324)));
    assert!(ceil64(-4503599627370495.5) == -4503599627370495.0);
    assert!(ceil64(inf) == inf);
    // trunc
    assert!(trunc64(2.7) == 2.0);
    assert!(trunc64(-2.7) == -2.0);
    assert!(is_neg_zero64(trunc64(-0.3)));
    assert!(trunc64(-1e300) == -1e300);
    let r = trunc64(nan);
    assert!(r != r);
    // round: ties away from zero
    assert!(round64(2.5) == 3.0);
    assert!(round64(-2.5) == -3.0);
    assert!(round64(0.5) == 1.0);
    assert!(round64(-0.5) == -1.0);
    assert!(is_pos_zero64(round64(0.49999999999999994)));
    assert!(is_neg_zero64(round64(-0.4)));
    assert!(round64(4503599627370497.0) == 4503599627370497.0);
    assert!(round64(2.4999999999999996) == 2.0);
    // round_ties_even
    assert!(round_ties_even64(2.5) == 2.0);
    assert!(round_ties_even64(3.5) == 4.0);
    assert!(round_ties_even64(-2.5) == -2.0);
    assert!(is_neg_zero64(round_ties_even64(-0.5)));
    assert!(is_pos_zero64(round_ties_even64(0.5)));
    assert!(round_ties_even64(0.5000000000000001) == 1.0);
    assert!(round_ties_even64(4503599627370495.5) == 4503599627370496.0);
    assert!(round_ties_even64(-inf) == -inf);
    // fract
    assert!(fract64(3.75) == 0.75);
    assert!(fract64(-3.75) == -0.75);
    assert!(is_pos_zero64(fract64(-1.0)));
    assert!(is_pos_zero64(fract64(-0.0)));
    assert!(fract64(1e300) == 0.0);
    assert!(fract64(5e-324) == 5e-324);
    let r = fract64(inf);
    assert!(r != r);
}

#[verify::test]
pub fn test_min_max_clamp64() {
    let inf = div64(1.0, 0.0);
    let nan = div64(0.0, 0.0);
    assert!(min64(1.0, 2.0) == 1.0);
    assert!(min64(2.0, -1.0) == -1.0);
    assert!(min64(nan, 1.0) == 1.0);
    assert!(min64(1.0, nan) == 1.0);
    assert!(min64(-inf, nan) == -inf);
    let r = min64(nan, nan);
    assert!(r != r);
    assert!(max64(1.0, 2.0) == 2.0);
    assert!(max64(nan, -1.0) == -1.0);
    assert!(max64(-1.0, nan) == -1.0);
    assert!(max64(inf, 1e308) == inf);
    let r = max64(nan, nan);
    assert!(r != r);
    assert!(clamp64(-3.0, -2.0, 1.0) == -2.0);
    assert!(clamp64(0.0, -2.0, 1.0) == 0.0);
    assert!(clamp64(2.0, -2.0, 1.0) == 1.0);
    assert!(clamp64(inf, -2.0, 1.0) == 1.0);
    assert!(clamp64(5.0, 5.0, 5.0) == 5.0);
    assert!(is_neg_zero64(clamp64(-1.0, -0.0, 1.0)));
    let r = clamp64(nan, -2.0, 1.0);
    assert!(r != r);
}

#[verify::test]
pub fn test_mul_add64() {
    let inf = div64(1.0, 0.0);
    assert!(mul_add64(10.0, 4.0, 60.0) == 100.0);
    // (1 + eps) * (1 - eps) - 1 = -eps^2, which an unfused multiply-add loses.
    let eps = 2.220446049250313e-16;
    assert!(mul_add64(1.0 + eps, 1.0 - eps, -1.0) == -eps * eps);
    assert!(mul_add64(0.1, 10.0, -1.0) == 5.551115123125783e-17);
    assert!(mul_add64(1e308, 10.0, -inf) == -inf);
    assert!(mul_add64(1e308, 10.0, -1e308) == inf);
    assert!(is_pos_zero64(mul_add64(1.0, 1.0, -1.0)));
    assert!(is_neg_zero64(mul_add64(-0.0, 1.0, -0.0)));
    let r = mul_add64(inf, 0.0, 1.0);
    assert!(r != r);
    let r = mul_add64(inf, 1.0, -inf);
    assert!(r != r);
}

#[verify::test]
pub fn test_round32() {
    let inf = div32(1.0, 0.0);
    let nan = div32(0.0, 0.0);
    assert!(floor32(-1.5) == -2.0);
    assert!(is_neg_zero32(floor32(-0.0)));
    assert!(floor32(-1e-45) == -1.0);
    assert!(floor32(8388607.5) == 8388607.0);
    assert!(floor32(3e38) == 3e38);
    assert!(ceil32(1.5) == 2.0);
    assert!(is_neg_zero32(ceil32(-0.5)));
    assert!(ceil32(1e-45) == 1.0);
    assert!(trunc32(-2.7) == -2.0);
    assert!(is_neg_zero32(trunc32(-0.3)));
    assert!(round32(2.5) == 3.0);
    assert!(round32(-2.5) == -3.0);
    assert!(is_pos_zero32(round32(0.49999997)));
    assert!(round32(8388609.0) == 8388609.0);
    assert!(round_ties_even32(2.5) == 2.0);
    assert!(round_ties_even32(3.5) == 4.0);
    assert!(is_neg_zero32(round_ties_even32(-0.5)));
    assert!(round_ties_even32(8388607.5) == 8388608.0);
    assert!(fract32(3.75) == 0.75);
    assert!(fract32(-3.75) == -0.75);
    assert!(is_pos_zero32(fract32(-1.0)));
    let r = fract32(-inf);
    assert!(r != r);
    let r = round32(nan);
    assert!(r != r);
    assert!(ceil32(-inf) == -inf);
}

#[verify::test]
pub fn test_min_max_clamp_mul_add32() {
    let inf = div32(1.0, 0.0);
    let nan = div32(0.0, 0.0);
    assert!(min32(1.0, 2.0) == 1.0);
    assert!(min32(nan, 1.0) == 1.0);
    assert!(min32(1.0, nan) == 1.0);
    assert!(max32(nan, -1.0) == -1.0);
    assert!(max32(-inf, -3e38) == -3e38);
    let r = max32(nan, nan);
    assert!(r != r);
    assert!(clamp32(-3.0, -2.0, 1.0) == -2.0);
    assert!(clamp32(2.0, -2.0, 1.0) == 1.0);
    assert!(is_neg_zero32(clamp32(-1.0, -0.0, 1.0)));
    let r = clamp32(nan, -2.0, 1.0);
    assert!(r != r);
    let eps = 1.1920929e-7;
    assert!(mul_add32(1.0 + eps, 1.0 - eps, -1.0) == -eps * eps);
    assert!(mul_add32(0.1, 10.0, -1.0) == 1.4901161e-8);
    assert!(mul_add32(3e38, 10.0, -3e38) == inf);
    let r = mul_add32(inf, 0.0, 1.0);
    assert!(r != r);
}

#[cfg(test)]
mod tests {
    #[test]
    fn native_rounding() {
        super::test_round64();
        super::test_min_max_clamp64();
        super::test_mul_add64();
        super::test_round32();
        super::test_min_max_clamp_mul_add32();
    }
}
