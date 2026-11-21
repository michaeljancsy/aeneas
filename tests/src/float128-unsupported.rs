//@ [!lean] skip
//@ [lean] known-failure
#![feature(f128)]
// Arithmetic on an unsupported float type is rejected with the same clear error as its type.
pub fn add(x: f128, y: f128) -> f128 {
    x + y
}
