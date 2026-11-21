//@ [!lean] skip
//@ [lean] known-failure
#![feature(f16)]
// The Lean backend supports only f32 and f64: other float types are rejected with a
// clear error when their type is translated.
pub fn pick(x: f16, y: f16, first: bool) -> f16 {
    if first {
        x
    } else {
        y
    }
}
