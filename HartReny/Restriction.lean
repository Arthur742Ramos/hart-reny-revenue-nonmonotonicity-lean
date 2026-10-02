module
public import HartReny.Basic

@[expose] public section

namespace HartReny
open Finset

theorem dot_basis (i : Variable) (a : ℚ) (x : Variable → ℝ) :
    dot (basis i a) x = (a : ℝ) * x i := by
  simp [dot, basis, apply_ite, ite_mul]

theorem dot_add (a b : Variable → ℚ) (x : Variable → ℝ) :
    dot (a + b) x = dot a x + dot b x := by
  simp [dot, Rat.cast_add, add_mul, sum_add_distrib]

/-- Restriction of any globally feasible real mechanism satisfies each
finite linear-program inequality. No finite-menu assumption is imposed. -/
theorem restriction_feasible (M : Mechanism) (hM : Feasible M) (c : Constraint) :
    dot (constraintRow c).coeff (mechanismVector M) ≤ (constraintRow c).bound := by
  cases c with
  | ir i =>
    have h := hM.2.1 (grid i)
    simp [constraintRow, dot_add, dot_basis, mechanismVector, grid, utility] at *
    linarith
  | ic i j =>
    have h := hM.2.2 (grid i) (grid j)
    simp [constraintRow, dot_add, dot_basis, mechanismVector, grid, utility] at *
    linarith
  | upper i g =>
    fin_cases g
    · simpa [constraintRow, dot_basis, mechanismVector] using (hM.1 (grid i)).2.1
    · simpa [constraintRow, dot_basis, mechanismVector] using (hM.1 (grid i)).2.2.2
  | lower i g =>
    fin_cases g
    · simpa [constraintRow, dot_basis, mechanismVector] using (hM.1 (grid i)).1
    · simpa [constraintRow, dot_basis, mechanismVector] using (hM.1 (grid i)).2.2.1

theorem dot_objective (p : Fin 6 → ℚ) (M : Mechanism) :
    dot (objective p) (mechanismVector M) = revenue p M := by
  simp [dot, objective, mechanismVector, revenue, Fintype.sum_prod_type,
    Fin.sum_univ_succ]

theorem global_revenue_bound (p : Fin 6 → ℚ) (r : ℚ)
    (certificate : List (ℚ × Constraint))
    (hn : ∀ t ∈ dualRows certificate, 0 ≤ t.1)
    (hc : ∀ i, weightedCoefficients (dualRows certificate) i = objective p i)
    (hb : weightedBound (dualRows certificate) = r)
    (M : Mechanism) (hM : Feasible M) : revenue p M ≤ (r : ℝ) := by
  rw [← dot_objective]
  apply finite_weak_duality (dualRows certificate) (objective p) r hn hc hb
  intro t ht
  obtain ⟨c, _, rfl⟩ := List.mem_map.mp ht
  exact restriction_feasible M hM c.2

end HartReny
