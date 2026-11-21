import Aeneas.Std.Float

set_option autoImplicit false

/-! The float casts in `Aeneas.Std.Float` are defined through Lean's logical float model. Check
them against Lean's native conversions (compiled C casts) on special and pseudo-random values. -/

open Aeneas.Std

/-- Pseudo-random 64-bit words (xorshift). -/
def nextWord (s : UInt64) : UInt64 :=
  let s := s ^^^ (s <<< 13)
  let s := s ^^^ (s >>> 7)
  s ^^^ (s <<< 17)

/-- Zeros, subnormals, powers of two, the largest finite value, infinities, NaN, and values on
and next to binary32 rounding boundaries and the binary32 overflow threshold. -/
def special64 : List UInt64 :=
  [0, 0x8000000000000000, 1, 0x000FFFFFFFFFFFFF, 0x0010000000000000, 0x7FEFFFFFFFFFFFFF,
   0x7FF0000000000000, 0xFFF0000000000000, 0x7FF8000000000000, 0x47EFFFFFE0000000,
   0x47EFFFFFF0000000, 0x47EFFFFFEFFFFFFF, 0x3690000000000000, 0x36A0000000000000,
   0x3810000000000000, 0x380FFFFFFFFFFFFF, 0x3FF0000010000000, 0x3FF0000030000000]

def check64to32 (w : UInt64) : Bool :=
  let x := Float.ofBits w
  let a := Float.castToFloat32 x
  let b := x.toFloat32
  if x.isNaN then a.isNaN && b.isNaN else a.toBits == b.toBits

def check32to64 (w : UInt32) : Bool :=
  let x := Float32.ofBits w
  let a := Float32.castToFloat x
  let b := x.toFloat
  if x.isNaN then a.isNaN && b.isNaN else a.toBits == b.toBits

def checkToU64 (w : UInt64) : Bool :=
  let x := Float.ofBits w
  (Float.toUScalar .U64 x).val == x.toUInt64.toNat

def checkU64ToFloat (w : UInt64) : Bool :=
  (UScalar.toFloat (⟨w.toBitVec⟩ : UScalar .U64)).toBits == w.toFloat.toBits &&
  (UScalar.toFloat32 (⟨w.toBitVec⟩ : UScalar .U64)).toBits == w.toFloat32.toBits

def checkAll (w : UInt64) : Bool :=
  check64to32 w && check32to64 (w >>> 32).toUInt32 && check32to64 w.toUInt32 &&
    checkToU64 w && checkU64ToFloat w

/-- Number of failing words among the special values and `n` pseudo-random ones. -/
def failures (n : Nat) : Nat := Id.run do
  let mut s : UInt64 := 0x9E3779B97F4A7C15
  let mut bad := (special64.filter (fun w => !checkAll w)).length
  for _ in [0:n] do
    s := nextWord s
    unless checkAll s do bad := bad + 1
  return bad

#guard failures 5000 == 0
