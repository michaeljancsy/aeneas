import Aeneas.Std.FloatRound

set_option autoImplicit false

/-! The rounding functions and `mul_add` in `Aeneas.Std.FloatRound` are defined through Lean's
logical float model. Check them against Lean's native functions (compiled C `floor`, `ceil`,
`round`, `fma` and their `f32` versions) on special and pseudo-random values. -/

open Aeneas.Std

/-- Pseudo-random 64-bit words (xorshift). -/
def nextWord (s : UInt64) : UInt64 :=
  let s := s ^^^ (s <<< 13)
  let s := s ^^^ (s >>> 7)
  s ^^^ (s <<< 17)

/-- A binary64 word whose value has magnitude between `2^-8` and `2^60`, so that it is often
close to (or exactly halfway between) integers. -/
def moderate64 (w : UInt64) : UInt64 :=
  (w &&& (0x800FFFFFFFFFFFF0 : UInt64)) |||
    (((1015 : UInt64) + ((w >>> 52) &&& 0x7F) % 68) <<< 52)

/-- A binary32 word whose value has magnitude between `2^-8` and `2^31`. -/
def moderate32 (w : UInt32) : UInt32 :=
  (w &&& (0x807FFFF0 : UInt32)) ||| (((119 : UInt32) + ((w >>> 23) &&& 0x3F) % 40) <<< 23)

/-- Zeros, halves, values next to integers, binary64 integer thresholds (`2^52`, `2^53`),
subnormals, the largest finite value, infinities and NaN. -/
def special64 : List UInt64 :=
  [0, 0x8000000000000000, 0x3FE0000000000000, 0xBFE0000000000000, 0x3FF8000000000000,
   0xC004000000000000, 0x4004000000000000, 0x3FDFFFFFFFFFFFFF, 0xBFDFFFFFFFFFFFFF,
   0x3FE0000000000001, 0x432FFFFFFFFFFFFF, 0xC32FFFFFFFFFFFFF, 0x4330000000000000,
   0x4330000000000001, 0x4340000000000001, 0x4320000000000001, 1, 0x8000000000000001,
   0x000FFFFFFFFFFFFF, 0x0010000000000000, 0x7FEFFFFFFFFFFFFF, 0x7FF0000000000000,
   0xFFF0000000000000, 0x7FF8000000000000, 0x3FEFFFFFFFFFFFFF, 0x3FF0000000000001]

/-- The same kinds of values for binary32 (`2^23`, `2^24` thresholds). -/
def special32 : List UInt32 :=
  [0, 0x80000000, 0x3F000000, 0xBF000000, 0x3FC00000, 0xC0200000, 0x40200000, 0x3EFFFFFF,
   0xBEFFFFFF, 0x3F000001, 0x4AFFFFFF, 0xCAFFFFFF, 0x4B000000, 0x4B000001, 0x4B800001,
   0x4A800001, 1, 0x80000001, 0x007FFFFF, 0x00800000, 0x7F7FFFFF, 0x7F800000, 0xFF800000,
   0x7FC00000, 0x3F7FFFFF, 0x3F800001]

def same64 (a b : Float) : Bool := if b.isNaN then a.isNaN else a.toBits == b.toBits

def same32 (a b : Float32) : Bool := if b.isNaN then a.isNaN else a.toBits == b.toBits

def checkUnary64 (w : UInt64) : Bool :=
  let x := Float.ofBits w
  same64 (std.f64.floor x) x.floor && same64 (std.f64.ceil x) x.ceil &&
    same64 (std.f64.round x) x.round

def checkUnary32 (w : UInt32) : Bool :=
  let x := Float32.ofBits w
  same32 (std.f32.floor x) x.floor && same32 (std.f32.ceil x) x.ceil &&
    same32 (std.f32.round x) x.round

/-- The model's fused multiply-add against the native one, including the cancelling sum
`a * b - fl(a * b)`. -/
def checkFma64 (a b c : UInt64) : Bool :=
  let (x, y, z) := (Float.ofBits a, Float.ofBits b, Float.ofBits c)
  let model (x y z : Float) := Float.ofModel (x.toModel.fma y.toModel z.toModel)
  same64 (model x y z) (x.fma y z) && same64 (model x y (-(x * y))) (x.fma y (-(x * y)))

def checkFma32 (a b c : UInt32) : Bool :=
  let (x, y, z) := (Float32.ofBits a, Float32.ofBits b, Float32.ofBits c)
  let model (x y z : Float32) := Float32.ofModel (x.toModel.fma y.toModel z.toModel)
  same32 (model x y z) (x.fma y z) && same32 (model x y (-(x * y))) (x.fma y (-(x * y)))

/-- Number of failing checks among the special values (all triples for `fma`) and `n`
pseudo-random draws of each kind. -/
def failures (n : Nat) : Nat := Id.run do
  let mut bad := (special64.filter (fun w => !checkUnary64 w)).length +
    (special32.filter (fun w => !checkUnary32 w)).length
  for a in special64 do
    for b in special64 do
      for c in special64 do
        unless checkFma64 a b c do bad := bad + 1
  for a in special32 do
    for b in special32 do
      for c in special32 do
        unless checkFma32 a b c do bad := bad + 1
  let mut s : UInt64 := 0x9E3779B97F4A7C15
  for _ in [0:n] do
    let s₁ := nextWord s
    let s₂ := nextWord s₁
    let s₃ := nextWord s₂
    s := s₃
    unless checkUnary64 s₁ && checkUnary64 (moderate64 s₁) do bad := bad + 1
    unless checkUnary32 s₁.toUInt32 && checkUnary32 (moderate32 s₂.toUInt32) do
      bad := bad + 1
    unless checkFma64 s₁ s₂ s₃ && checkFma64 (moderate64 s₁) (moderate64 s₂) (moderate64 s₃) do
      bad := bad + 1
    let (u₁, u₂, u₃) := (s₁.toUInt32, s₂.toUInt32, s₃.toUInt32)
    unless checkFma32 u₁ u₂ u₃ && checkFma32 (moderate32 u₁) (moderate32 u₂) (moderate32 u₃) do
      bad := bad + 1
  return bad

#guard failures 5000 == 0

/-! `clamp` fails unless `lo ≤ hi`, so also when a bound is NaN. -/

#guard (Option.ofResult (core.f64.clamp 1 2 1)).isNone
#guard (Option.ofResult (core.f64.clamp 1 (0 / 0) 1)).isNone
#guard (Option.ofResult (core.f32.clamp 1 0 (0 / 0))).isNone
#guard (core.f32.clamp 3 0 1).reducesTo 1

/-! For zeros of opposite signs, `min` and `max` return one of the two zeros. -/

#guard core.f64.min (-0) 0 == 0 && core.f64.min 0 (-0) == 0
#guard core.f64.max (-0) 0 == 0 && core.f64.max 0 (-0) == 0
#guard core.f32.min (-0) 0 == 0 && core.f32.min 0 (-0) == 0
#guard core.f32.max (-0) 0 == 0 && core.f32.max 0 (-0) == 0
