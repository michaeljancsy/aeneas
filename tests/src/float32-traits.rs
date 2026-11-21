//@ [!lean] skip
#![feature(register_tool)]
#![register_tool(verify)]

// The f32 counterpart of issue-828-float.rs: derived Clone/PartialEq, Vec clone, and Copy.
#[derive(Clone, PartialEq)]
pub enum BucketReduction {
    Failure,
    Success,
    OverConsumption(f32),
}

pub fn test_create() -> BucketReduction {
    BucketReduction::OverConsumption(1.5)
}

pub fn test_divide(x: f32, y: f32) -> BucketReduction {
    BucketReduction::OverConsumption(x / y)
}

// Must use the concrete Float32 type, even with autoImplicit off.
pub fn pick(x: f32, y: f32, first: bool) -> f32 {
    if first {
        x
    } else {
        y
    }
}

pub fn clone_values(values: &Vec<f32>) -> Vec<f32> {
    values.clone()
}

/// Uses `Copy` for f32 through a generic bound.
pub fn duplicate<T: Copy>(x: T) -> (T, T) {
    (x, x)
}

pub fn duplicate_f32(x: f32) -> (f32, f32) {
    duplicate(x)
}

#[verify::test]
pub fn test_bucket() {
    assert!(test_create() == BucketReduction::OverConsumption(1.5));
    assert!(test_divide(3.0, 2.0) == test_create());
    assert!(test_create().clone() == test_create());
    assert!(pick(1.0, 2.0, true) == 1.0);
    assert!(pick(1.0, 2.0, false) == 2.0);
    assert!(BucketReduction::OverConsumption(0.0) == BucketReduction::OverConsumption(-0.0));
    let nan_bucket = test_divide(0.0, 0.0);
    assert!(nan_bucket != nan_bucket);
    let mut source = Vec::new();
    source.push(1.0);
    source.push(-0.0);
    let values = clone_values(&source);
    assert!(values[0] == 1.0);
    assert!(1.0 / values[1] == -1.0 / 0.0);
    let (a, b) = duplicate_f32(2.5);
    assert!(a == 2.5 && b == 2.5);
}

#[cfg(test)]
mod tests {
    #[test]
    fn native_bucket() {
        super::test_bucket();
    }
}
