//@ [!fstar] skip
//@ [fstar] known-failure
// Only the Lean backend translates floats. Other backends report a float-specific error
// for float arithmetic instead of failing earlier with a generic one.
pub fn add(x: f64, y: f64) -> f64 {
    x + y
}
