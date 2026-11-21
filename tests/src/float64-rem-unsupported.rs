//@ [!fstar] skip
//@ [fstar] known-failure
// Only the Lean backend translates floats. Other backends report a float-specific error
// for the float remainder, as for the other float arithmetic operations.
pub fn remainder(x: f64, y: f64) -> f64 {
    x % y
}
