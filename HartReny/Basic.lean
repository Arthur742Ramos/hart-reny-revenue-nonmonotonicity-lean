module
public import Mathlib.Algebra.Order.Archimedean.Real.Basic
public import HartReny.Model
public import HartReny.LinearProgram

@[expose] public section

namespace HartReny
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

def basis (i : Variable) (a : ℚ) : Variable → ℚ := fun j => if j = i then a else 0

inductive Constraint where
  | ir (i : Grid)
  | ic (i j : Grid)
  | upper (i : Grid) (g : Fin 2)
  | lower (i : Grid) (g : Fin 2)
  deriving DecidableEq

def constraintRow : Constraint → Row Variable
  | .ir i => ⟨basis (i,0) (-values i.1) + basis (i,1) (-values i.2) + basis (i,2) 1, 0⟩
  | .ic i j => ⟨basis (i,0) (-values i.1) + basis (i,1) (-values i.2) +
      basis (i,2) 1 + basis (j,0) (values i.1) + basis (j,1) (values i.2) +
      basis (j,2) (-1), 0⟩
  | .upper i g => ⟨basis (i, g.castLE (by decide)) 1, 1⟩
  | .lower i g => ⟨basis (i, g.castLE (by decide)) (-1), 0⟩

def objective (p : Fin 6 → ℚ) (j : Variable) : ℚ :=
  if j.2 = 2 then p j.1.1 * p j.1.2 else 0

def mechanismVector (M : Mechanism) (j : Variable) : ℝ :=
  (![ (M (grid j.1)).q₁, (M (grid j.1)).q₂, (M (grid j.1)).payment] : Fin 3 → ℝ) j.2

def dualRows (certificate : List (ℚ × Constraint)) : List (ℚ × Row Variable) :=
  certificate.map fun r => (r.1, constraintRow r.2)

end HartReny
