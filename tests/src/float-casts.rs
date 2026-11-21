//@ [!lean] skip
#![feature(register_tool)]
#![register_tool(verify)]
//! Numeric casts (`as`) to and from floats. Rust truncates float-to-integer casts toward
//! zero, sends NaN to 0 and saturates; integer-to-float and f64-to-f32 casts round to nearest.

pub fn div64(x: f64, y: f64) -> f64 {
    x / y
}
pub fn div32(x: f32, y: f32) -> f32 {
    x / y
}

pub fn f64_to_f32(x: f64) -> f32 {
    x as f32
}
pub fn f32_to_f64(x: f32) -> f64 {
    x as f64
}

pub fn f64_to_u8(x: f64) -> u8 {
    x as u8
}
pub fn f64_to_u64(x: f64) -> u64 {
    x as u64
}
pub fn f64_to_u128(x: f64) -> u128 {
    x as u128
}
pub fn f64_to_usize(x: f64) -> usize {
    x as usize
}
pub fn f64_to_i8(x: f64) -> i8 {
    x as i8
}
pub fn f64_to_i32(x: f64) -> i32 {
    x as i32
}
pub fn f64_to_i64(x: f64) -> i64 {
    x as i64
}
pub fn f64_to_i128(x: f64) -> i128 {
    x as i128
}
pub fn f32_to_u32(x: f32) -> u32 {
    x as u32
}
pub fn f32_to_u128(x: f32) -> u128 {
    x as u128
}
pub fn f32_to_i16(x: f32) -> i16 {
    x as i16
}
pub fn f32_to_isize(x: f32) -> isize {
    x as isize
}

pub fn f32_to_i128(x: f32) -> i128 {
    x as i128
}
pub fn u32_to_f32(x: u32) -> f32 {
    x as f32
}
pub fn u64_to_f32(x: u64) -> f32 {
    x as f32
}
pub fn i64_to_f32(x: i64) -> f32 {
    x as f32
}
pub fn i128_to_f64(x: i128) -> f64 {
    x as f64
}
pub fn u8_to_f32(x: u8) -> f32 {
    x as f32
}
pub fn u64_to_f64(x: u64) -> f64 {
    x as f64
}
pub fn u128_to_f32(x: u128) -> f32 {
    x as f32
}
pub fn u128_to_f64(x: u128) -> f64 {
    x as f64
}
pub fn usize_to_f64(x: usize) -> f64 {
    x as f64
}
pub fn i32_to_f32(x: i32) -> f32 {
    x as f32
}
pub fn i64_to_f64(x: i64) -> f64 {
    x as f64
}
pub fn i128_to_f32(x: i128) -> f32 {
    x as f32
}
pub fn isize_to_f32(x: isize) -> f32 {
    x as f32
}

#[verify::test]
pub fn test_float_to_float() {
    assert!(f64_to_f32(0.1) == 0.1);
    assert!(f64_to_f32(1e40) == div32(1.0, 0.0));
    assert!(f64_to_f32(-1e40) == div32(-1.0, 0.0));
    assert!(f64_to_f32(1e-50) == 0.0);
    assert!(div32(1.0, f64_to_f32(-1e-50)) == div32(-1.0, 0.0));
    assert!(f64_to_f32(16777217.0) == 16777216.0);
    assert!(f64_to_f32(16777219.0) == 16777220.0);
    let inf = div64(1.0, 0.0);
    assert!(f64_to_f32(inf) == div32(1.0, 0.0));
    let nan = div64(0.0, 0.0);
    let nan32 = f64_to_f32(nan);
    assert!(nan32 != nan32);
    assert!(f32_to_f64(0.1) == 0.10000000149011612);
    assert!(f32_to_f64(1e-45) == 1.401298464324817e-45);
    assert!(f32_to_f64(div32(1.0, 0.0)) == inf);
}

#[verify::test]
pub fn test_float_to_int() {
    let nan = div64(0.0, 0.0);
    let inf = div64(1.0, 0.0);
    assert!(f64_to_u8(300.0) == 255);
    assert!(f64_to_u8(255.9) == 255);
    assert!(f64_to_u8(-5.0) == 0);
    assert!(f64_to_u8(-0.9) == 0);
    assert!(f64_to_u8(nan) == 0);
    assert!(f64_to_u64(inf) == 18446744073709551615);
    assert!(f64_to_u64(1e19) == 10000000000000000000);
    assert!(f64_to_u128(1e30) == 1000000000000000019884624838656);
    assert!(f64_to_usize(42.7) == 42);
    assert!(f64_to_i8(-128.9) == -128);
    assert!(f64_to_i8(-129.0) == -128);
    assert!(f64_to_i8(127.9) == 127);
    assert!(f64_to_i32(-0.9) == 0);
    assert!(f64_to_i32(2.5) == 2);
    assert!(f64_to_i32(-2.5) == -2);
    assert!(f64_to_i32(nan) == 0);
    assert!(f64_to_i64(1e300) == 9223372036854775807);
    assert!(f64_to_i64(-inf) == -9223372036854775808);
    assert!(f64_to_i128(-1e30) == -1000000000000000019884624838656);
    assert!(f32_to_u32(4294967296.0) == 4294967295);
    assert!(f32_to_u32(-1.0) == 0);
    assert!(f32_to_u128(3.40282347e38) == 340282346638528859811704183484516925440);
    assert!(f32_to_i16(-40000.0) == -32768);
    assert!(f32_to_i16(32767.9) == 32767);
    assert!(f32_to_isize(-7.99) == -7);
}

#[verify::test]
pub fn test_int_to_float() {
    assert!(u8_to_f32(255) == 255.0);
    assert!(u64_to_f64(18446744073709551615) == 18446744073709551616.0);
    assert!(u64_to_f64(9007199254740993) == 9007199254740992.0);
    assert!(u128_to_f32(340282366920938463463374607431768211455) == div32(1.0, 0.0));
    assert!(u128_to_f64(340282366920938463463374607431768211455) == 3.402823669209385e38);
    assert!(usize_to_f64(7) == 7.0);
    assert!(i32_to_f32(16777217) == 16777216.0);
    assert!(i32_to_f32(16777219) == 16777220.0);
    assert!(i32_to_f32(-16777219) == -16777220.0);
    assert!(i64_to_f64(-9223372036854775808) == -9223372036854775808.0);
    assert!(i128_to_f32(-170141183460469231731687303715884105728) == -1.70141183e38);
    assert!(isize_to_f32(-3) == -3.0);
    assert!(div32(1.0, i32_to_f32(0)) == div32(1.0, 0.0));
}

#[verify::test]
pub fn test_edge_cases() {
    let nan32 = div32(0.0, 0.0);
    let inf32 = div32(1.0, 0.0);
    let ninf32 = div32(-1.0, 0.0);
    let inf64 = div64(1.0, 0.0);
    // f32 sources: NaN, infinities, saturation and truncation.
    assert!(f32_to_u32(nan32) == 0);
    assert!(f32_to_u32(inf32) == 4294967295);
    assert!(f32_to_i16(nan32) == 0);
    assert!(f32_to_i16(ninf32) == -32768);
    // isize saturation depends on the platform's pointer width, so only a portable value here.
    assert!(f32_to_isize(-100000.5) == -100000);
    assert!(f32_to_i128(ninf32) == -170141183460469231731687303715884105728);
    assert!(f32_to_i128(nan32) == 0);
    // Truncation (not saturation) just below the top of the range.
    assert!(f64_to_u8(254.9) == 254);
    assert!(f64_to_i8(126.9) == 126);
    // 128-bit saturation.
    assert!(f64_to_u128(inf64) == 340282366920938463463374607431768211455);
    assert!(f64_to_u128(-1.0) == 0);
    assert!(f64_to_i128(1e40) == 170141183460469231731687303715884105727);
    // Signed zeros, observed through division.
    assert!(div32(1.0, f64_to_f32(-0.0)) == ninf32);
    assert!(div32(1.0, f64_to_f32(1e-50)) == inf32);
    assert!(div64(1.0, f32_to_f64(-0.0)) == div64(-1.0, 0.0));
    assert!(div32(1.0, u32_to_f32(0)) == inf32);
    assert!(div64(1.0, i128_to_f64(0)) == inf64);
    // NaN stays NaN from f32 to f64.
    let nan64 = f32_to_f64(nan32);
    assert!(nan64 != nan64);
    // Rounding of wide integers.
    assert!(u64_to_f32(16777217) == 16777216.0);
    assert!(i64_to_f32(-16777219) == -16777220.0);
    assert!(i128_to_f64(-1267650600228229401496703205377) == -1267650600228229401496703205376.0);
    assert!(u128_to_f64(18446744073709551617) == 18446744073709551616.0);
    // The u128 -> f32 overflow boundary: 2^128 - 2^103 is a tie that rounds to infinity.
    assert!(u128_to_f32(340282356779733661637539395458142568448) == inf32);
    assert!(u128_to_f32(340282356779733661637539395458142568447) == 3.40282347e38);
    assert!(u128_to_f32(340282346638528859811704183484516925440) == 3.40282347e38);
}

#[cfg(test)]
mod tests {
    #[test]
    fn native_casts() {
        super::test_float_to_float();
        super::test_float_to_int();
        super::test_int_to_float();
        super::test_edge_cases();
    }
}
