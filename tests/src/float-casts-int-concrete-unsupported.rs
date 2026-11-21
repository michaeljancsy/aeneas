//@ [!lean] skip
//@ [lean] known-failure
//@ [lean] aeneas-args=-test-units
// Concrete evaluation of an integer-to-float cast reports the same message as float arithmetic.
pub fn to_float(x: u32) -> f64 {
    x as f64
}

pub fn test_to_float() {
    assert!(to_float(3) == 3.0);
}
