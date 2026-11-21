//@ [!lean] skip
//@ [lean] known-failure
//@ [lean] aeneas-args=-test-units
// Concrete evaluation of a float cast reports the same message as float arithmetic.
pub fn cast(x: f64) -> u32 {
    x as u32
}

pub fn test_cast() {
    assert!(cast(1.5) == 1);
}
