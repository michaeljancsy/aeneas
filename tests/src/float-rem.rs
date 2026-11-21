//@ [!lean] skip
#![feature(register_tool)]
#![register_tool(verify)]
//! The remainder `%` on floats. Rust's float `%` is C's `fmod`: the result is
//! `x - trunc(x / y) * y` computed exactly, with the sign of `x`. It is NaN if `x` is
//! infinite, `y` is zero, or either is NaN, and `x` if `y` is infinite and `x` finite.

pub fn rem64(x: f64, y: f64) -> f64 {
    x % y
}
pub fn rem32(x: f32, y: f32) -> f32 {
    x % y
}
pub fn div64(x: f64, y: f64) -> f64 {
    x / y
}
pub fn div32(x: f32, y: f32) -> f32 {
    x / y
}

#[verify::test]
pub fn test_rem64() {
    let inf = div64(1.0, 0.0);
    let nan = div64(0.0, 0.0);
    // Signs: the result has the sign of `x`.
    assert!(rem64(5.5, 2.0) == 1.5);
    assert!(rem64(-5.5, 2.0) == -1.5);
    assert!(rem64(5.5, -2.0) == 1.5);
    assert!(rem64(-5.5, -2.0) == -1.5);
    // Exact, with no rounding error.
    assert!(rem64(1.0, 0.1) == 0.09999999999999995);
    assert!(rem64(1e300, 7.0) == 1.0);
    assert!(rem64(-1e300, 7.0) == -1.0);
    assert!(rem64(1.7976931348623157e308, 1.5) == 0.5);
    assert!(rem64(9007199254740992.0, 10.0) == 2.0);
    assert!(rem64(1e16, 7.0) == 4.0);
    assert!(rem64(1e-300, 3e-310) == 1.0000308012634e-310);
    assert!(rem64(1.7976931348623157e308, 5e-324) == 0.0);
    assert!(rem64(2.5e-323, 1e-323) == 5e-324);
    assert!(rem64(3.0, 7.0) == 3.0);
    // A zero result has the sign of `x`.
    assert!(div64(1.0, rem64(4.0, 2.0)) == inf);
    assert!(div64(1.0, rem64(-4.0, 2.0)) == -inf);
    assert!(div64(1.0, rem64(-4.0, -2.0)) == -inf);
    assert!(div64(1.0, rem64(-0.0, 1.0)) == -inf);
    // Infinite divisor: `x` unchanged.
    assert!(rem64(3.5, inf) == 3.5);
    assert!(rem64(-3.5, -inf) == -3.5);
    assert!(div64(1.0, rem64(-0.0, inf)) == -inf);
    // NaN cases.
    let r = rem64(inf, 2.0);
    assert!(r != r);
    let r = rem64(-inf, inf);
    assert!(r != r);
    let r = rem64(2.0, 0.0);
    assert!(r != r);
    let r = rem64(0.0, -0.0);
    assert!(r != r);
    let r = rem64(nan, 2.0);
    assert!(r != r);
    let r = rem64(2.0, nan);
    assert!(r != r);
}

#[verify::test]
pub fn test_rem32() {
    let inf = div32(1.0, 0.0);
    let nan = div32(0.0, 0.0);
    assert!(rem32(5.5, 2.0) == 1.5);
    assert!(rem32(-5.5, 2.0) == -1.5);
    assert!(rem32(5.5, -2.0) == 1.5);
    assert!(rem32(1.0, 0.1) == 0.09999999);
    assert!(rem32(-1e10, 3.3) == -0.29611063);
    assert!(rem32(1e30, 1e-30) == 8.166816e-31);
    assert!(rem32(1e-30, 1e30) == 1e-30);
    assert!(rem32(7e-45, 3e-45) == 1e-45);
    assert!(div32(1.0, rem32(16777215.0, 0.75)) == inf);
    assert!(div32(1.0, rem32(-16777215.0, 0.75)) == -inf);
    assert!(rem32(3.5, -inf) == 3.5);
    let r = rem32(inf, 2.0);
    assert!(r != r);
    let r = rem32(2.0, 0.0);
    assert!(r != r);
    let r = rem32(nan, 1.0);
    assert!(r != r);
}

#[cfg(test)]
mod tests {
    #[test]
    fn native_rem() {
        super::test_rem64();
        super::test_rem32();
    }
}
