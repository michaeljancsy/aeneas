//@ [!lean] skip
#![feature(register_tool)]
#![register_tool(verify)]
//! Every float/integer cast pair, one function each, so that each width's translation is exercised.
//! The values are chosen so that a signed/unsigned mix-up in any width changes the result.
//! usize/isize use values that fit 32 bits, because their width depends on the platform.

pub fn f64_to_u8(x: f64) -> u8 {
    x as u8
}

pub fn f64_to_u16(x: f64) -> u16 {
    x as u16
}

pub fn f64_to_u32(x: f64) -> u32 {
    x as u32
}

pub fn f64_to_u64(x: f64) -> u64 {
    x as u64
}

pub fn f64_to_u128(x: f64) -> u128 {
    x as u128
}

pub fn f64_to_i8(x: f64) -> i8 {
    x as i8
}

pub fn f64_to_i16(x: f64) -> i16 {
    x as i16
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

pub fn f64_to_usize(x: f64) -> usize {
    x as usize
}

pub fn f64_to_isize(x: f64) -> isize {
    x as isize
}

pub fn u8_to_f64(x: u8) -> f64 {
    x as f64
}

pub fn u16_to_f64(x: u16) -> f64 {
    x as f64
}

pub fn u32_to_f64(x: u32) -> f64 {
    x as f64
}

pub fn u64_to_f64(x: u64) -> f64 {
    x as f64
}

pub fn u128_to_f64(x: u128) -> f64 {
    x as f64
}

pub fn usize_to_f64(x: usize) -> f64 {
    x as f64
}

pub fn i8_to_f64(x: i8) -> f64 {
    x as f64
}

pub fn i16_to_f64(x: i16) -> f64 {
    x as f64
}

pub fn i32_to_f64(x: i32) -> f64 {
    x as f64
}

pub fn i64_to_f64(x: i64) -> f64 {
    x as f64
}

pub fn i128_to_f64(x: i128) -> f64 {
    x as f64
}

pub fn isize_to_f64(x: isize) -> f64 {
    x as f64
}

pub fn f32_to_u8(x: f32) -> u8 {
    x as u8
}

pub fn f32_to_u16(x: f32) -> u16 {
    x as u16
}

pub fn f32_to_u32(x: f32) -> u32 {
    x as u32
}

pub fn f32_to_u64(x: f32) -> u64 {
    x as u64
}

pub fn f32_to_u128(x: f32) -> u128 {
    x as u128
}

pub fn f32_to_i8(x: f32) -> i8 {
    x as i8
}

pub fn f32_to_i16(x: f32) -> i16 {
    x as i16
}

pub fn f32_to_i32(x: f32) -> i32 {
    x as i32
}

pub fn f32_to_i64(x: f32) -> i64 {
    x as i64
}

pub fn f32_to_i128(x: f32) -> i128 {
    x as i128
}

pub fn f32_to_usize(x: f32) -> usize {
    x as usize
}

pub fn f32_to_isize(x: f32) -> isize {
    x as isize
}

pub fn u8_to_f32(x: u8) -> f32 {
    x as f32
}

pub fn u16_to_f32(x: u16) -> f32 {
    x as f32
}

pub fn u32_to_f32(x: u32) -> f32 {
    x as f32
}

pub fn u64_to_f32(x: u64) -> f32 {
    x as f32
}

pub fn u128_to_f32(x: u128) -> f32 {
    x as f32
}

pub fn usize_to_f32(x: usize) -> f32 {
    x as f32
}

pub fn i8_to_f32(x: i8) -> f32 {
    x as f32
}

pub fn i16_to_f32(x: i16) -> f32 {
    x as f32
}

pub fn i32_to_f32(x: i32) -> f32 {
    x as f32
}

pub fn i64_to_f32(x: i64) -> f32 {
    x as f32
}

pub fn i128_to_f32(x: i128) -> f32 {
    x as f32
}

pub fn isize_to_f32(x: isize) -> f32 {
    x as f32
}

/// A cast inside a larger body, next to fallible integer arithmetic.
pub fn scaled_index(x: f32, n: u32) -> u32 {
    (x * (n as f32)) as u32 + 1
}
/// Integer-to-float feeding float arithmetic.
pub fn mix(a: i16, b: f64) -> f64 {
    (a as f64) * b + 0.5
}

#[verify::test]
pub fn test_f64_to_ints() {
    assert!(f64_to_u8(-5.7) == 0);
    assert!(f64_to_u8(300.9) == 255);
    assert!(f64_to_u8(-40000.5) == 0);
    assert!(f64_to_u16(-5.7) == 0);
    assert!(f64_to_u16(300.9) == 300);
    assert!(f64_to_u16(-40000.5) == 0);
    assert!(f64_to_u32(-5.7) == 0);
    assert!(f64_to_u32(300.9) == 300);
    assert!(f64_to_u32(-40000.5) == 0);
    assert!(f64_to_u64(-5.7) == 0);
    assert!(f64_to_u64(300.9) == 300);
    assert!(f64_to_u64(-40000.5) == 0);
    assert!(f64_to_u128(-5.7) == 0);
    assert!(f64_to_u128(300.9) == 300);
    assert!(f64_to_u128(-40000.5) == 0);
    assert!(f64_to_i8(-5.7) == -5);
    assert!(f64_to_i8(300.9) == 127);
    assert!(f64_to_i8(-40000.5) == -128);
    assert!(f64_to_i16(-5.7) == -5);
    assert!(f64_to_i16(300.9) == 300);
    assert!(f64_to_i16(-40000.5) == -32768);
    assert!(f64_to_i32(-5.7) == -5);
    assert!(f64_to_i32(300.9) == 300);
    assert!(f64_to_i32(-40000.5) == -40000);
    assert!(f64_to_i64(-5.7) == -5);
    assert!(f64_to_i64(300.9) == 300);
    assert!(f64_to_i64(-40000.5) == -40000);
    assert!(f64_to_i128(-5.7) == -5);
    assert!(f64_to_i128(300.9) == 300);
    assert!(f64_to_i128(-40000.5) == -40000);
    assert!(f64_to_usize(-5.7) == 0);
    assert!(f64_to_usize(300.9) == 300);
    assert!(f64_to_isize(-5.7) == -5);
    assert!(f64_to_isize(300.9) == 300);
}

#[verify::test]
pub fn test_ints_to_f64() {
    assert!(u8_to_f64(200) == 200.0);
    assert!(u16_to_f64(40000) == 40000.0);
    assert!(u32_to_f64(3000000000) == 3000000000.0);
    assert!(u64_to_f64(18000000000000000000) == 18000000000000000000.0);
    assert!(
        u128_to_f64(300000000000000000000000000000000000000)
            == 300000000000000000000000000000000000000.0
    );
    assert!(usize_to_f64(40000) == 40000.0);
    assert!(i8_to_f64(-100) == -100.0);
    assert!(i16_to_f64(-30000) == -30000.0);
    assert!(i32_to_f64(-2000000000) == -2000000000.0);
    assert!(i64_to_f64(-9000000000000000000) == -9000000000000000000.0);
    assert!(
        i128_to_f64(-100000000000000000000000000000000000000)
            == -100000000000000000000000000000000000000.0
    );
    assert!(isize_to_f64(-30000) == -30000.0);
}

#[verify::test]
pub fn test_f32_to_ints() {
    assert!(f32_to_u8(-5.7) == 0);
    assert!(f32_to_u8(300.9) == 255);
    assert!(f32_to_u8(-40000.5) == 0);
    assert!(f32_to_u16(-5.7) == 0);
    assert!(f32_to_u16(300.9) == 300);
    assert!(f32_to_u16(-40000.5) == 0);
    assert!(f32_to_u32(-5.7) == 0);
    assert!(f32_to_u32(300.9) == 300);
    assert!(f32_to_u32(-40000.5) == 0);
    assert!(f32_to_u64(-5.7) == 0);
    assert!(f32_to_u64(300.9) == 300);
    assert!(f32_to_u64(-40000.5) == 0);
    assert!(f32_to_u128(-5.7) == 0);
    assert!(f32_to_u128(300.9) == 300);
    assert!(f32_to_u128(-40000.5) == 0);
    assert!(f32_to_i8(-5.7) == -5);
    assert!(f32_to_i8(300.9) == 127);
    assert!(f32_to_i8(-40000.5) == -128);
    assert!(f32_to_i16(-5.7) == -5);
    assert!(f32_to_i16(300.9) == 300);
    assert!(f32_to_i16(-40000.5) == -32768);
    assert!(f32_to_i32(-5.7) == -5);
    assert!(f32_to_i32(300.9) == 300);
    assert!(f32_to_i32(-40000.5) == -40000);
    assert!(f32_to_i64(-5.7) == -5);
    assert!(f32_to_i64(300.9) == 300);
    assert!(f32_to_i64(-40000.5) == -40000);
    assert!(f32_to_i128(-5.7) == -5);
    assert!(f32_to_i128(300.9) == 300);
    assert!(f32_to_i128(-40000.5) == -40000);
    assert!(f32_to_usize(-5.7) == 0);
    assert!(f32_to_usize(300.9) == 300);
    assert!(f32_to_isize(-5.7) == -5);
    assert!(f32_to_isize(300.9) == 300);
}

#[verify::test]
pub fn test_ints_to_f32() {
    assert!(u8_to_f32(200) == 200.0);
    assert!(u16_to_f32(40000) == 40000.0);
    assert!(u32_to_f32(3000000000) == 3000000000.0);
    assert!(u64_to_f32(18000000000000000000) == 18000000000000000000.0);
    assert!(
        u128_to_f32(300000000000000000000000000000000000000)
            == 300000000000000000000000000000000000000.0
    );
    assert!(usize_to_f32(40000) == 40000.0);
    assert!(i8_to_f32(-100) == -100.0);
    assert!(i16_to_f32(-30000) == -30000.0);
    assert!(i32_to_f32(-2000000000) == -2000000000.0);
    assert!(i64_to_f32(-9000000000000000000) == -9000000000000000000.0);
    assert!(
        i128_to_f32(-100000000000000000000000000000000000000)
            == -100000000000000000000000000000000000000.0
    );
    assert!(isize_to_f32(-30000) == -30000.0);
}

#[verify::test]
pub fn test_casts_in_bodies() {
    assert!(scaled_index(0.5, 10) == 6);
    assert!(scaled_index(2.75, 4) == 12);
    assert!(mix(-3, 2.0) == -5.5);
}

#[cfg(test)]
mod tests {
    #[test]
    fn native_widths() {
        super::test_f64_to_ints();
        super::test_ints_to_f64();
        super::test_f32_to_ints();
        super::test_ints_to_f32();
        super::test_casts_in_bodies();
    }
}
