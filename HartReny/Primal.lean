module
public import HartReny.Basic

@[expose] public section

namespace HartReny
open Finset
set_option maxRecDepth 100000
set_option maxHeartbeats 4000000

theorem menu_valid (k : Fin 11) : AllocationValid (menu k) := by
  fin_cases k <;> norm_num [AllocationValid, menu, menuData]

theorem optimalMechanism_feasible : Feasible optimalMechanism := by
  apply menuMechanism_feasible
  · exact menu_valid
  · exact ⟨0, by norm_num [menu, menuData]⟩

/-- Each prescribed grid outcome maximizes utility; payment breaks ties in
the seller's favor. All 36 types and all eleven menu outcomes are checked. -/
theorem chosen_best (i : Grid) : Best menu (grid i) (chosen i) := by
  obtain ⟨i,j⟩ := i
  fin_cases i <;> fin_cases j <;>
    constructor <;> intro k <;> fin_cases k <;>
      norm_num [Best, utility, grid, values, menu, menuData, chosen]

/-- Allocation bounds, all 36 IR constraints and all 1296 IC constraints
for the supplied grid choices, derived from their menu utility maxima. -/
theorem chosen_constraints (i : Grid) :
    AllocationValid (menu (chosen i)) ∧
    0 ≤ utility (grid i) (menu (chosen i)) ∧
    ∀ j : Grid, utility (grid i) (menu (chosen j)) ≤
      utility (grid i) (menu (chosen i)) := by
  refine ⟨menu_valid _, ?_, fun j => (chosen_best i).1 _⟩
  have h := (chosen_best i).1 0
  simpa [menu, menuData, utility] using h

theorem optimalMechanism_grid_payment (i : Grid) :
    (optimalMechanism (grid i)).payment = (menu (chosen i)).payment :=
  menuMechanism_payment (by decide) menu (grid i) (chosen i) (chosen_best i)

theorem primal_revenue₁ : revenue prior₁ optimalMechanism = (revenue₁ : ℝ) := by
  simp only [revenue, optimalMechanism_grid_payment]
  norm_num [Fintype.sum_prod_type, Fin.sum_univ_succ, prior₁, menu, menuData,
    chosen, revenue₁]

theorem primal_revenue₂ : revenue prior₂ optimalMechanism = (revenue₂ : ℝ) := by
  simp only [revenue, optimalMechanism_grid_payment]
  norm_num [Fintype.sum_prod_type, Fin.sum_univ_succ, prior₂, menu, menuData,
    chosen, revenue₂]

end HartReny
