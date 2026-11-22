//@ [!lean] skip
#![feature(register_tool)]
#![register_tool(verify)]
//! Native IEEE binary32 operations: no Rust overflow panic on float arithmetic.
pub fn add(x: f32, y: f32) -> f32 {
    x + y
}
pub fn sub(x: f32, y: f32) -> f32 {
    x - y
}
pub fn mul(x: f32, y: f32) -> f32 {
    x * y
}
pub fn div(x: f32, y: f32) -> f32 {
    x / y
}
pub fn neg(x: f32) -> f32 {
    -x
}
pub fn eq(x: f32, y: f32) -> bool {
    x == y
}
pub fn ne(x: f32, y: f32) -> bool {
    x != y
}
pub fn lt(x: f32, y: f32) -> bool {
    x < y
}
pub fn le(x: f32, y: f32) -> bool {
    x <= y
}
pub fn gt(x: f32, y: f32) -> bool {
    x > y
}
pub fn ge(x: f32, y: f32) -> bool {
    x >= y
}
pub fn positive_zero() -> f32 {
    0.0
}
pub fn negative_zero() -> f32 {
    -0.0
}
pub fn literal() -> f32 {
    0.1
}
pub fn is_finite(x: f32) -> bool {
    x.is_finite()
}
pub fn abs(x: f32) -> f32 {
    x.abs()
}
pub fn sqrt(x: f32) -> f32 {
    x.sqrt()
}
pub fn subnormal() -> f32 {
    1e-45
}
pub fn max_finite() -> f32 {
    3.40282347e38
}
pub fn rounding_worst_case() -> f32 {
    1.00337183e-28
}
// Written as literals (the constants `f32::MIN_POSITIVE` and `f32::EPSILON` themselves
// are tested in `float-bits.rs`).
pub fn min_positive_normal() -> f32 {
    1.17549435e-38
}
pub fn epsilon() -> f32 {
    1.1920929e-7
}
pub fn positive_infinity() -> f32 {
    const { 1.0f32 / 0.0f32 }
}
pub fn negative_infinity() -> f32 {
    const { -1.0f32 / 0.0f32 }
}

#[verify::test]
pub fn test_arithmetic() {
    assert!(add(1.0, 2.0) == 3.0);
    assert!(sub(5.0, 2.0) == 3.0);
    assert!(mul(1.5, 2.0) == 3.0);
    assert!(div(6.0, 2.0) == 3.0);
    assert!(neg(3.0) == -3.0);
    assert!(lt(1.0, 2.0));
    assert!(le(1.0, 1.0));
    assert!(gt(2.0, 1.0));
    assert!(ge(1.0, 1.0));
}

#[verify::test]
pub fn test_ieee() {
    let nan = div(positive_zero(), positive_zero());
    assert!(ne(nan, nan));
    assert!(!eq(nan, nan));
    assert!(eq(positive_zero(), negative_zero()));
    assert!(!lt(nan, 1.0));
    assert!(!le(nan, 1.0));
    assert!(!gt(nan, 1.0));
    assert!(!ge(nan, 1.0));
    assert!(!is_finite(div(1.0, positive_zero())));
    assert!(!is_finite(nan));
    assert!(is_finite(max_finite()));
    assert!(subnormal() > 0.0);
    assert!(sqrt(4.0) == 2.0);
    assert!(abs(-2.0) == 2.0);
    assert!(!is_finite(mul(max_finite(), 2.0)));
    assert!(eq(
        div(1.0, negative_zero()),
        neg(div(1.0, positive_zero()))
    ));
}

/// Behaviour that tells binary32 apart from binary64: rounding at 24 bits, and signed
/// zero through operations.
#[verify::test]
pub fn test_binary32() {
    // 2^24 + 1 is not representable in binary32; it rounds back to 2^24.
    assert!(add(16777216.0, 1.0) == 16777216.0);
    // True in binary32, false in binary64.
    assert!(add(0.1, 0.2) == 0.3);
    assert!(sub(add(1.0, epsilon()), 1.0) == epsilon());
    assert!(add(1.0, div(epsilon(), 2.0)) == 1.0);
    // Signed zero, observed through division.
    assert!(div(1.0, neg(positive_zero())) == negative_infinity());
    assert!(div(1.0, abs(negative_zero())) == positive_infinity());
    assert!(div(1.0, sqrt(negative_zero())) == negative_infinity());
    let root = sqrt(-1.0);
    assert!(ne(root, root));
    assert!(rounding_worst_case() > 0.0);
    assert!(is_finite(min_positive_normal()));
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn native_operations() {
        test_arithmetic();
        test_ieee();
        test_binary32();
    }

    #[test]
    fn exact_literal_bits() {
        assert_eq!(positive_zero().to_bits(), 0);
        assert_eq!(negative_zero().to_bits(), 0x8000_0000);
        assert_eq!(literal().to_bits(), 0x3dcc_cccd);
        assert_eq!(subnormal().to_bits(), 1);
        assert_eq!(max_finite().to_bits(), 0x7f7f_ffff);
        assert_eq!(positive_infinity().to_bits(), 0x7f80_0000);
        assert_eq!(negative_infinity().to_bits(), 0xff80_0000);
        assert_eq!(rounding_worst_case().to_bits(), 0x10fe_628e);
        assert_eq!(min_positive_normal().to_bits(), 0x0080_0000);
        assert_eq!(epsilon().to_bits(), 0x3400_0000);
    }
}
