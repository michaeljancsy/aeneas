//@ [!fstar] skip
//@ [fstar] known-failure
// Float casts are only supported by the Lean backend (see float-casts.rs); other backends
// report a float-specific error.
pub fn cast(x: f64) -> u64 {
    x as u64
}
