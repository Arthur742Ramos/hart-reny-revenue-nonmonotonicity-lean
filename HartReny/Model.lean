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

end HartReny
