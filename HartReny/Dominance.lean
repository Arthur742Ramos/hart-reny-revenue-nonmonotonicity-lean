module
public import HartReny.Basic
public import Mathlib.Algebra.Order.BigOperators.Group.Finset

@[expose] public section

namespace HartReny
open Finset

def MarginalDominates (p q : Fin 6 → ℚ) : Prop :=
  ∀ f : ℝ → ℝ, Monotone f →
    (∑ i, (p i : ℝ) * f (values i)) ≤ ∑ i, (q i : ℝ) * f (values i)

def ProductDominates (p q : Fin 6 → ℚ) : Prop :=
  ∀ f : Valuation → ℝ, Monotone f →
    (∑ i : Grid, ((p i.1 * p i.2 : ℚ) : ℝ) * f (grid i)) ≤
      ∑ i : Grid, ((q i.1 * q i.2 : ℚ) : ℝ) * f (grid i)

/-- The explicit transport moves mass 1/9000 from value 10 to value 13. -/
def marginalCoupling (i j : Fin 6) : ℚ :=
  if i = j then (if i = 0 then prior₂ 0 else prior₁ i)
  else if i = 0 ∧ j = 1 then 1/9000 else 0

def productCoupling (i j : Grid) : ℚ :=
  marginalCoupling i.1 j.1 * marginalCoupling i.2 j.2

theorem priors_probability :
    (∀ i, 0 ≤ prior₁ i) ∧ (∑ i, prior₁ i) = 1 ∧
    (∀ i, 0 ≤ prior₂ i) ∧ (∑ i, prior₂ i) = 1 := by
  norm_num [prior₁, prior₂, Fin.sum_univ_succ]
  constructor <;> intro i <;> fin_cases i <;> norm_num

theorem marginalCoupling_nonnegative (i j : Fin 6) : 0 ≤ marginalCoupling i j := by
  fin_cases i <;> fin_cases j <;> norm_num [marginalCoupling, prior₁, prior₂]

theorem marginalCoupling_rows (i : Fin 6) :
    (∑ j, marginalCoupling i j) = prior₁ i := by
  fin_cases i <;> norm_num [marginalCoupling, prior₁, prior₂, Fin.sum_univ_succ]

theorem marginalCoupling_columns (j : Fin 6) :
    (∑ i, marginalCoupling i j) = prior₂ j := by
  fin_cases j <;> norm_num [marginalCoupling, prior₁, prior₂, Fin.sum_univ_succ]

theorem marginalCoupling_order (i j : Fin 6) (h : marginalCoupling i j ≠ 0) :
    values i ≤ values j := by
  fin_cases i <;> fin_cases j <;> norm_num [marginalCoupling, prior₁, prior₂, values] at *

theorem productCoupling_nonnegative (i j : Grid) : 0 ≤ productCoupling i j :=
  mul_nonneg (marginalCoupling_nonnegative _ _) (marginalCoupling_nonnegative _ _)

theorem productCoupling_rows (i : Grid) :
    (∑ j, productCoupling i j) = prior₁ i.1 * prior₁ i.2 := by
  simp [productCoupling, Fintype.sum_prod_type, ← mul_sum, ← sum_mul,
    marginalCoupling_rows]

theorem productCoupling_columns (j : Grid) :
    (∑ i, productCoupling i j) = prior₂ j.1 * prior₂ j.2 := by
  simp [productCoupling, Fintype.sum_prod_type, ← mul_sum, ← sum_mul,
    marginalCoupling_columns]

theorem productCoupling_order (i j : Grid) (h : productCoupling i j ≠ 0) :
    grid i ≤ grid j := by
  have h₁ := marginalCoupling_order i.1 j.1 (fun hz => h (by simp [productCoupling, hz]))
  have h₂ := marginalCoupling_order i.2 j.2 (fun hz => h (by simp [productCoupling, hz]))
  constructor
  · change (values i.1 : ℝ) ≤ (values j.1 : ℝ)
    exact_mod_cast h₁
  · change (values i.2 : ℝ) ≤ (values j.2 : ℝ)
    exact_mod_cast h₂

/-- A finite monotone coupling proves the expectation characterization of
first-order stochastic dominance. -/
theorem coupling_expectation_le {ι : Type} [Fintype ι]
    (p q : ι → ℚ) (c : ι → ι → ℚ) (f : ι → ℝ)
    (hn : ∀ i j, 0 ≤ c i j)
    (hr : ∀ i, (∑ j, c i j) = p i)
    (hc : ∀ j, (∑ i, c i j) = q j)
    (ho : ∀ i j, c i j ≠ 0 → f i ≤ f j) :
    (∑ i, (p i : ℝ) * f i) ≤ ∑ j, (q j : ℝ) * f j := by
  calc
    _ = ∑ i, ∑ j, (c i j : ℝ) * f i := by
      simp only [← hr, Rat.cast_sum, sum_mul]
    _ ≤ ∑ i, ∑ j, (c i j : ℝ) * f j := by
      apply sum_le_sum
      intro i _
      apply sum_le_sum
      intro j _
      by_cases hz : c i j = 0
      · simp [hz]
      · exact mul_le_mul_of_nonneg_left (ho i j hz) (by exact_mod_cast hn i j)
    _ = _ := by
      rw [sum_comm]
      simp only [← hc, Rat.cast_sum, sum_mul]

theorem marginal_stochastic_dominance : MarginalDominates prior₁ prior₂ := by
  intro f hf
  apply coupling_expectation_le prior₁ prior₂ marginalCoupling (fun i => f (values i))
    marginalCoupling_nonnegative marginalCoupling_rows marginalCoupling_columns
  intro i j hij
  apply hf
  exact_mod_cast marginalCoupling_order i j hij

theorem iid_stochastic_dominance : ProductDominates prior₁ prior₂ := by
  intro f hf
  apply coupling_expectation_le (fun i : Grid => prior₁ i.1 * prior₁ i.2)
    (fun i : Grid => prior₂ i.1 * prior₂ i.2) productCoupling (fun i => f (grid i))
    productCoupling_nonnegative productCoupling_rows productCoupling_columns
  intro i j hij
  exact hf (productCoupling_order i j hij)

end HartReny
