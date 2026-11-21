//@ [!coq] skip
//@ [coq] known-failure
// Only the Lean backend translates floats. For other backends a float literal reaches
// extraction, which reports it as unsupported (and, without -abort-on-error, emits a
// placeholder so the rest of the crate is still translated).
pub fn one() -> f32 {
    1.0
}
