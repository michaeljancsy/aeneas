//@ [!coq] skip
//@ [coq] known-failure
// Float casts are only supported by the Lean backend; other backends report a clear error.
pub fn to_float(x: u64) -> f64 {
    x as f64
}
