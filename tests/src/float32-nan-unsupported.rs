//@ [!lean] skip
//@ [lean] known-failure
// Charon's textual encoding does not retain NaN payload bits (#1507).
pub fn nan() -> f32 {
    const { 0.0f32 / 0.0f32 }
}
