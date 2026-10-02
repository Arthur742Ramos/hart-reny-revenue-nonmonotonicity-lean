module
public import Mathlib.Algebra.BigOperators.Field
public import Mathlib.Basic.Real.Basic
public import Mathlib.Tactic.NormNum
public import Mathlib.Tactic.Linarith
public import Mathlib.Tactic.FinCases
public import Mathlib.Tactic.Ring
public import Mathlib.Algebra.Order.BigOperators.Group.List
public import Mathlib.Data.Rat.BigOperators
public import Mathlib.Algebra.BigOperators.Fin

@[expose] public section

namespace HartReny
open Finset

/-- A finite linear inequality with exact rational data and real unknowns. -/
structure Row (ι : Type) where
  coeff : ι → ℚ
  bound : ℚ

def dot {ι : Type} [Fintype ι] (a : ι → ℚ) (x : ι → ℝ) : ℝ :=
  ∑ i, (a i : ℝ) * x i

def weightedCoefficients {ι : Type} (rows : List (ℚ × Row ι)) (i : ι) : ℚ :=
  (rows.map fun r => r.1 * r.2.coeff i).sum

def weightedBound {ι : Type} (rows : List (ℚ × Row ι)) : ℚ :=
  (rows.map fun r => r.1 * r.2.bound).sum

theorem weighted_identity {ι : Type} [Fintype ι]
    (rows : List (ℚ × Row ι)) (x : ι → ℝ) :
    (rows.map fun r => (r.1 : ℝ) * dot r.2.coeff x).sum =
      dot (weightedCoefficients rows) x := by
  induction rows with
  | nil => simp [dot, weightedCoefficients]
  | cons r rows ih =>
    simp only [List.map_cons, List.sum_cons, ih]
    simp only [weightedCoefficients, List.map_cons, List.sum_cons, dot,
      Rat.cast_add, Rat.cast_mul, add_mul, Finset.sum_add_distrib,
      Finset.mul_sum, mul_assoc]

/-- Weak duality over arbitrary real unknowns. Only rational coefficient
identities and nonnegative rational multipliers are required. -/
theorem finite_weak_duality {ι : Type} [Fintype ι]
    (rows : List (ℚ × Row ι)) (objective : ι → ℚ) (upper : ℚ)
    (nonnegative : ∀ r ∈ rows, 0 ≤ r.1)
    (coefficients : ∀ i, weightedCoefficients rows i = objective i)
    (bound : weightedBound rows = upper)
    (x : ι → ℝ) (feasible : ∀ r ∈ rows, dot r.2.coeff x ≤ r.2.bound) :
    dot objective x ≤ (upper : ℝ) := by
  have h : (rows.map fun r => (r.1 : ℝ) * dot r.2.coeff x).sum ≤
      (rows.map fun r => ((r.1 * r.2.bound : ℚ) : ℝ)).sum := by
    apply List.sum_le_sum
    intro r hr
    simp only [Rat.cast_mul]
    apply mul_le_mul_of_nonneg_left
    · exact feasible r hr
    · exact_mod_cast nonnegative r hr
  rw [weighted_identity] at h
  have hc : weightedCoefficients rows = objective := funext coefficients
  rw [hc] at h
  have hb : (rows.map fun r => ((r.1 * r.2.bound : ℚ) : ℝ)).sum =
      (weightedBound rows : ℝ) := by
    simp [weightedBound, List.map_map, Function.comp_def]
  rw [hb, bound] at h
  exact h

end HartReny
