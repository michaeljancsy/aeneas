//@ [!lean] skip
#![feature(register_tool)]
#![register_tool(verify)]
//! `PartialOrd` and `Default` for f32/f64, called through the traits (generic code and derives).
//! `partial_cmp` is `None` when either side is NaN; `-0.0` and `+0.0` compare `Equal`; `lt`,
//! `le`, `gt` and `ge` are false when either side is NaN. `Default` is `0.0`.
use std::cmp::Ordering;

/// Encodes a comparison result as an integer, so the tests only compare integers.
pub fn code(o: Option<Ordering>) -> i32 {
    match o {
        None => 2,
        Some(Ordering::Less) => -1,
        Some(Ordering::Equal) => 0,
        Some(Ordering::Greater) => 1,
    }
}

/// Generic code: the trait methods are called through the `PartialOrd` instance.
pub fn cmp_generic<T: PartialOrd>(x: &T, y: &T) -> i32 {
    code(x.partial_cmp(y))
}

/// Packs `lt`, `le`, `gt` and `ge` into bits 0 to 3, called through the trait.
pub fn ops_generic<T: PartialOrd>(x: &T, y: &T) -> u32 {
    let mut r = 0;
    if x.lt(y) {
        r += 1;
    }
    if x.le(y) {
        r += 2;
    }
    if x.gt(y) {
        r += 4;
    }
    if x.ge(y) {
        r += 8;
    }
    r
}

pub fn default_generic<T: Default>() -> T {
    T::default()
}

/// Direct calls on concrete types.
pub fn cmp64(x: f64, y: f64) -> i32 {
    code(x.partial_cmp(&y))
}
pub fn cmp32(x: f32, y: f32) -> i32 {
    code(x.partial_cmp(&y))
}
pub fn ops64(x: f64, y: f64) -> u32 {
    ops_generic(&x, &y)
}
pub fn ops32(x: f32, y: f32) -> u32 {
    ops_generic(&x, &y)
}
pub fn default64() -> f64 {
    f64::default()
}
pub fn default32() -> f32 {
    <f32 as Default>::default()
}

pub fn div64(x: f64, y: f64) -> f64 {
    x / y
}
pub fn div32(x: f32, y: f32) -> f32 {
    x / y
}

/// Derived `PartialOrd` compares fields lexicographically with `partial_cmp`.
#[derive(Clone, Copy, PartialEq, PartialOrd, Default)]
pub struct Sample {
    pub time: f64,
    pub level: f32,
}

/// Derived `PartialOrd` on an enum compares variants by order first, then fields.
#[derive(Clone, Copy, PartialEq, PartialOrd, Default)]
pub enum Gain {
    #[default]
    Off,
    Linear(f32),
    Decibels(f64, f32),
}

pub fn cmp_sample(x: &Sample, y: &Sample) -> i32 {
    code(x.partial_cmp(y))
}
pub fn lt_sample(x: &Sample, y: &Sample) -> bool {
    x < y
}
pub fn cmp_gain(x: &Gain, y: &Gain) -> i32 {
    code(x.partial_cmp(y))
}
pub fn le_gain(x: &Gain, y: &Gain) -> bool {
    x <= y
}

#[verify::test]
pub fn test_partial_cmp64() {
    let nan = div64(0.0, 0.0);
    let inf = div64(1.0, 0.0);
    let ninf = div64(-1.0, 0.0);
    assert!(cmp64(1.0, 2.0) == -1);
    assert!(cmp64(2.0, 2.0) == 0);
    assert!(cmp64(3.0, 2.0) == 1);
    assert!(cmp64(-0.0, 0.0) == 0);
    assert!(cmp64(0.0, -0.0) == 0);
    assert!(cmp64(nan, 1.0) == 2);
    assert!(cmp64(1.0, nan) == 2);
    assert!(cmp64(nan, nan) == 2);
    assert!(cmp64(nan, inf) == 2);
    assert!(cmp64(inf, inf) == 0);
    assert!(cmp64(ninf, inf) == -1);
    assert!(cmp64(inf, 1.0e308) == 1);
    assert!(cmp64(ninf, -1.0e308) == -1);
    assert!(cmp64(-1.5, -2.5) == 1);
    assert!(cmp64(5.0e-324, 0.0) == 1);
    assert!(cmp64(-5.0e-324, -0.0) == -1);
    assert!(cmp_generic(&1.0f64, &nan) == 2);
    assert!(cmp_generic(&-0.0f64, &0.0) == 0);
}

#[verify::test]
pub fn test_partial_cmp32() {
    let nan = div32(0.0, 0.0);
    let inf = div32(1.0, 0.0);
    let ninf = div32(-1.0, 0.0);
    assert!(cmp32(1.0, 2.0) == -1);
    assert!(cmp32(2.0, 2.0) == 0);
    assert!(cmp32(3.0, 2.0) == 1);
    assert!(cmp32(-0.0, 0.0) == 0);
    assert!(cmp32(nan, 1.0) == 2);
    assert!(cmp32(1.0, nan) == 2);
    assert!(cmp32(nan, nan) == 2);
    assert!(cmp32(inf, inf) == 0);
    assert!(cmp32(ninf, inf) == -1);
    assert!(cmp32(inf, 3.0e38) == 1);
    assert!(cmp32(-1.5, -2.5) == 1);
    assert!(cmp32(1.0e-45, 0.0) == 1);
    assert!(cmp_generic(&nan, &nan) == 2);
    assert!(cmp_generic(&0.0f32, &-0.0) == 0);
}

#[verify::test]
pub fn test_ops() {
    let nan64 = div64(0.0, 0.0);
    let nan32 = div32(0.0, 0.0);
    // lt = 1, le = 2, gt = 4, ge = 8
    assert!(ops64(1.0, 2.0) == 3);
    assert!(ops64(2.0, 2.0) == 10);
    assert!(ops64(3.0, 2.0) == 12);
    assert!(ops64(-0.0, 0.0) == 10);
    assert!(ops64(nan64, 1.0) == 0);
    assert!(ops64(1.0, nan64) == 0);
    assert!(ops64(nan64, nan64) == 0);
    assert!(ops32(1.0, 2.0) == 3);
    assert!(ops32(2.0, 2.0) == 10);
    assert!(ops32(3.0, 2.0) == 12);
    assert!(ops32(0.0, -0.0) == 10);
    assert!(ops32(nan32, 1.0) == 0);
    assert!(ops32(nan32, nan32) == 0);
}

#[verify::test]
pub fn test_default() {
    let z64 = default64();
    let z32 = default32();
    assert!(z64 == 0.0);
    assert!(z32 == 0.0);
    // The default is +0.0, not -0.0.
    assert!(1.0 / z64 == div64(1.0, 0.0));
    assert!(1.0 / z32 == div32(1.0, 0.0));
    let g64: f64 = default_generic();
    let g32: f32 = default_generic();
    assert!(g64 == 0.0 && g32 == 0.0);
}

#[verify::test]
pub fn test_derived() {
    let nan64 = div64(0.0, 0.0);
    let nan32 = div32(0.0, 0.0);
    let a = Sample {
        time: 1.0,
        level: 0.5,
    };
    let b = Sample {
        time: 1.0,
        level: 0.75,
    };
    let c = Sample {
        time: 2.0,
        level: 0.0,
    };
    assert!(cmp_sample(&a, &b) == -1);
    assert!(cmp_sample(&b, &a) == 1);
    assert!(cmp_sample(&a, &a) == 0);
    assert!(cmp_sample(&b, &c) == -1);
    assert!(lt_sample(&a, &c));
    assert!(!lt_sample(&c, &a));
    // -0.0 == +0.0 in the first field, so the second field decides.
    let z0 = Sample {
        time: 0.0,
        level: 1.0,
    };
    let z1 = Sample {
        time: -0.0,
        level: 2.0,
    };
    assert!(cmp_sample(&z0, &z1) == -1);
    // NaN in the first field makes the whole comparison `None`.
    let n = Sample {
        time: nan64,
        level: 1.0,
    };
    assert!(cmp_sample(&n, &a) == 2);
    assert!(!lt_sample(&n, &a) && !lt_sample(&a, &n));
    // NaN in the second field matters only when the first fields are equal.
    let m = Sample {
        time: 1.0,
        level: nan32,
    };
    assert!(cmp_sample(&m, &a) == 2);
    assert!(cmp_sample(&m, &c) == -1);
    // Enums: variant order first, then the fields.
    let off = Gain::Off;
    let lin = Gain::Linear(0.5);
    let db = Gain::Decibels(-6.0, 1.0);
    assert!(cmp_gain(&off, &lin) == -1);
    assert!(cmp_gain(&db, &lin) == 1);
    assert!(cmp_gain(&lin, &Gain::Linear(0.25)) == 1);
    assert!(cmp_gain(&db, &Gain::Decibels(-6.0, 2.0)) == -1);
    assert!(cmp_gain(&Gain::Linear(nan32), &lin) == 2);
    assert!(cmp_gain(&Gain::Linear(nan32), &off) == 1);
    assert!(le_gain(&off, &off));
    assert!(!le_gain(&Gain::Linear(nan32), &Gain::Linear(nan32)));
    // Derived `Default`.
    let s: Sample = default_generic();
    assert!(s.time == 0.0 && s.level == 0.0);
    assert!(cmp_gain(&default_generic(), &off) == 0);
}

#[cfg(test)]
mod tests {
    #[test]
    fn native_float_ordering() {
        super::test_partial_cmp64();
        super::test_partial_cmp32();
        super::test_ops();
        super::test_default();
        super::test_derived();
    }
}
