module
public import Mathlib.Basic.Real.Basic
public import Mathlib.Data.Finset.Max
public import Mathlib.Algebra.BigOperators.Field
public import Mathlib.Tactic.NormNum
public import Mathlib.Tactic.Linarith
public import Mathlib.Tactic.FinCases
public import Mathlib.Tactic.Ring
public import Mathlib.Algebra.Order.BigOperators.Group.List
public import Mathlib.Data.Rat.BigOperators
public import Mathlib.Algebra.BigOperators.Fin
public import Mathlib.Algebra.Order.Archimedean.Real.Basic

/-! Exact reference contracts for Hart–Reny Example E2/Proposition 9.
The three `sorry` bodies below are reference-only placeholders for the named
Comparator targets. Solution and the library contain no admissions or custom
axioms. All semantic definitions and their dependencies are fully specified.
-/
@[expose] public section
namespace HartReny
open Finset

abbrev Valuation := {v : ℝ × ℝ // 0 ≤ v.1 ∧ 0 ≤ v.2}

structure Outcome where
  q₁ : ℝ
  q₂ : ℝ
  payment : ℝ

def utility (v : Valuation) (o : Outcome) : ℝ :=
  v.val.1 * o.q₁ + v.val.2 * o.q₂ - o.payment

def AllocationValid (o : Outcome) : Prop :=
  0 ≤ o.q₁ ∧ o.q₁ ≤ 1 ∧ 0 ≤ o.q₂ ∧ o.q₂ ≤ 1

abbrev Mechanism := Valuation → Outcome

/-- IC and IR on the entire nonnegative real quadrant, with arbitrary real
payments and allocations in the unit square. -/
def Feasible (M : Mechanism) : Prop :=
  (∀ v, AllocationValid (M v)) ∧ (∀ v, 0 ≤ utility v (M v)) ∧
  (∀ v w, utility v (M w) ≤ utility v (M v))

def Best {n : ℕ} (menu : Fin n → Outcome) (v : Valuation) (k : Fin n) : Prop :=
  (∀ j, utility v (menu j) ≤ utility v (menu k)) ∧
  (∀ j, utility v (menu j) = utility v (menu k) →
    (menu j).payment ≤ (menu k).payment)

theorem exists_best {n : ℕ} (hn : 0 < n) (menu : Fin n → Outcome)
    (v : Valuation) : ∃ k, Best menu v k := by
  classical
  have ne : (univ : Finset (Fin n)).Nonempty := ⟨⟨0, hn⟩, mem_univ _⟩
  obtain ⟨k, _, hk⟩ := exists_max_image univ (fun j => utility v (menu j)) ne
  let tied := univ.filter fun j => utility v (menu j) = utility v (menu k)
  have ht : tied.Nonempty := ⟨k, by simp [tied]⟩
  obtain ⟨m, hm, hmax⟩ := exists_max_image tied (fun j => (menu j).payment) ht
  have heq : utility v (menu m) = utility v (menu k) := (mem_filter.mp hm).2
  refine ⟨m, ?_, ?_⟩
  · intro j
    rw [heq]
    exact hk j (mem_univ _)
  · intro j hj
    apply hmax j
    simp [tied, hj, heq]

noncomputable def bestIndex {n : ℕ} (hn : 0 < n) (menu : Fin n → Outcome)
    (v : Valuation) : Fin n := Classical.choose (exists_best hn menu v)

theorem bestIndex_spec {n : ℕ} (hn : 0 < n) (menu : Fin n → Outcome)
    (v : Valuation) : Best menu v (bestIndex hn menu v) :=
  Classical.choose_spec (exists_best hn menu v)

noncomputable def menuMechanism {n : ℕ} (hn : 0 < n)
    (menu : Fin n → Outcome) : Mechanism := fun v => menu (bestIndex hn menu v)

/-- Utility maximization, including an outside option, defines a globally
IC/IR mechanism. The choice also maximizes payment among utility ties. -/
theorem menuMechanism_feasible {n : ℕ} (hn : 0 < n) (menu : Fin n → Outcome)
    (valid : ∀ k, AllocationValid (menu k))
    (outside : ∃ k, menu k = ⟨0, 0, 0⟩) :
    Feasible (menuMechanism hn menu) := by
  refine ⟨fun v => valid _, ?_, ?_⟩
  · intro v
    obtain ⟨k, hk⟩ := outside
    have h := (bestIndex_spec hn menu v).1 k
    simpa [hk, utility, menuMechanism] using h
  · intro v w
    exact (bestIndex_spec hn menu v).1 _

/-- Any prescribed utility and payment maximizer gives the same payment as
the global menu mechanism, even if allocations tie. -/
theorem menuMechanism_payment {n : ℕ} (hn : 0 < n) (menu : Fin n → Outcome)
    (v : Valuation) (k : Fin n) (hk : Best menu v k) :
    (menuMechanism hn menu v).payment = (menu k).payment := by
  have hm := bestIndex_spec hn menu v
  have hu : utility v (menu k) = utility v (menu (bestIndex hn menu v)) :=
    le_antisymm (hm.1 k) (hk.1 _)
  exact le_antisymm (hk.2 _ hu.symm) (hm.2 k hu)

open Finset

abbrev Grid := Fin 6 × Fin 6
abbrev Variable := Grid × Fin 3

def values : Fin 6 → ℚ := ![10, 13, 46, 47, 80, 100]
def prior₁ : Fin 6 → ℚ := ![4/15, 0, 1/90, 1/3, 7/30, 7/45]
def prior₂ : Fin 6 → ℚ := ![2399/9000, 1/9000, 1/90, 1/3, 7/30, 7/45]

theorem values_nonnegative (i : Fin 6) : 0 ≤ values i := by
  fin_cases i <;> norm_num [values]

def grid (i : Grid) : Valuation :=
  ⟨((values i.1 : ℝ), (values i.2 : ℝ)), by
    constructor
    · change (0 : ℝ) ≤ (values i.1 : ℝ)
      exact_mod_cast values_nonnegative i.1
    · change (0 : ℝ) ≤ (values i.2 : ℝ)
      exact_mod_cast values_nonnegative i.2⟩

def revenue (p : Fin 6 → ℚ) (M : Mechanism) : ℝ :=
  ∑ i : Grid, ((p i.1 * p i.2 : ℚ) : ℝ) * (M (grid i)).payment

noncomputable def optimalRevenue (p : Fin 6 → ℚ) : ℝ :=
  sSup {r : ℝ | ∃ M : Mechanism, Feasible M ∧ revenue p M = r}

def IsOptimal (p : Fin 6 → ℚ) (M : Mechanism) (r : ℝ) : Prop :=
  Feasible M ∧ revenue p M = r ∧ ∀ N : Mechanism, Feasible N → revenue p N ≤ r

theorem optimalRevenue_of_isOptimal (p : Fin 6 → ℚ) (M : Mechanism) (r : ℝ)
    (h : IsOptimal p M r) : optimalRevenue p = r := by
  apply csSup_eq_of_is_forall_le_of_forall_le_imp_ge
  · exact ⟨r, M, h.1, h.2.1⟩
  · rintro x ⟨N, hN, rfl⟩
    exact h.2.2 N hN
  · intro b hb
    exact hb r ⟨M, h.1, h.2.1⟩

def menuData : Fin 11 → ℚ × ℚ × ℚ :=
  ![(0,0,0), (32/1187,384/13057,34240/13057),
    (384/13057,32/1187,34240/13057), (35/1187,35/1187,3258/1187),
    (32/1187,5647/5935,90672/1187), (5647/5935,32/1187,90672/1187),
    (35/1187,5647/5935,90810/1187), (5647/5935,35/1187,90810/1187),
    (0,1,80), (1,0,80), (1,1,126)]

def menu (k : Fin 11) : Outcome :=
  ⟨menuData k |>.1, menuData k |>.2.1, menuData k |>.2.2⟩

def chosen : Grid → Fin 11 := fun i =>
  (![0,0,0,0,8,8, 0,0,0,0,4,8, 0,0,0,1,6,10,
     0,0,2,3,10,10, 9,5,7,10,10,10, 9,9,10,10,10,10] : Fin 36 → Fin 11)
    ⟨6 * i.1.val + i.2.val, by omega⟩

noncomputable def optimalMechanism : Mechanism := menuMechanism (by decide : 0 < 11) menu

def revenue₁ : ℚ := 408189937 / 5875650
def revenue₂ : ℚ := 30614162731 / 440673750
def reversalGap : ℚ := 3752 / 20030625

open Finset

def MarginalDominates (p q : Fin 6 → ℚ) : Prop :=
  ∀ f : ℝ → ℝ, Monotone f →
    (∑ i, (p i : ℝ) * f (values i)) ≤ ∑ i, (q i : ℝ) * f (values i)

def ProductDominates (p q : Fin 6 → ℚ) : Prop :=
  ∀ f : Valuation → ℝ, Monotone f →
    (∑ i : Grid, ((p i.1 * p i.2 : ℚ) : ℝ) * f (grid i)) ≤
      ∑ i : Grid, ((q i.1 * q i.2 : ℚ) : ℝ) * f (grid i)


theorem exact_global_optima :
    IsOptimal prior₁ optimalMechanism (revenue₁ : ℝ) ∧
    IsOptimal prior₂ optimalMechanism (revenue₂ : ℝ) := by
  sorry

theorem exact_optimal_revenues :
    optimalRevenue prior₁ = (revenue₁ : ℝ) ∧
    optimalRevenue prior₂ = (revenue₂ : ℝ) ∧
    optimalRevenue prior₁ - optimalRevenue prior₂ = (reversalGap : ℝ) ∧
    0 < (reversalGap : ℝ) := by
  sorry

theorem iid_revenue_nonmonotonicity :
    MarginalDominates prior₁ prior₂ ∧ ProductDominates prior₁ prior₂ ∧
    optimalRevenue prior₂ < optimalRevenue prior₁ := by
  sorry

end HartReny
