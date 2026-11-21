//@ [!lean] skip
//@ [lean] known-failure
#![feature(f16)]
// The Lean backend supports only f32 and f64: other float types must be rejected
// instead of emitting an undefined `F16` type that would become an auto-bound implicit.
pub fn pick(x: f16, y: f16, first: bool) -> f16 {
    if first {
        x
    } else {
        y
    }
}
