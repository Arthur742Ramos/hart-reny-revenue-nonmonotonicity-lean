module
public import HartReny.Certificates
public import HartReny.Restriction
public import HartReny.Primal
public import HartReny.Dominance

@[expose] public section
namespace HartReny

/-- The global menu mechanism attains each exact revenue, and every globally
IC/IR real mechanism has revenue at most that value. -/
theorem exact_global_optima :
    IsOptimal prior₁ optimalMechanism (revenue₁ : ℝ) ∧
    IsOptimal prior₂ optimalMechanism (revenue₂ : ℝ) := by
  constructor
  · refine ⟨optimalMechanism_feasible, primal_revenue₁, ?_⟩
    exact global_revenue_bound prior₁ revenue₁ certificate₁
      certificate₁_nonnegative certificate₁_coefficients certificate₁_bound
  · refine ⟨optimalMechanism_feasible, primal_revenue₂, ?_⟩
    exact global_revenue_bound prior₂ revenue₂ certificate₂
      certificate₂_nonnegative certificate₂_coefficients certificate₂_bound

/-- Exact unrestricted optimal revenues and their strictly positive reversal
gap, with a common globally feasible mechanism attaining both optima. -/
theorem exact_optimal_revenues :
    optimalRevenue prior₁ = (revenue₁ : ℝ) ∧
    optimalRevenue prior₂ = (revenue₂ : ℝ) ∧
    optimalRevenue prior₁ - optimalRevenue prior₂ = (reversalGap : ℝ) ∧
    0 < (reversalGap : ℝ) := by
  have h₁ := optimalRevenue_of_isOptimal prior₁ optimalMechanism _ exact_global_optima.1
  have h₂ := optimalRevenue_of_isOptimal prior₂ optimalMechanism _ exact_global_optima.2
  refine ⟨h₁, h₂, ?_, ?_⟩
  · rw [h₁, h₂]
    norm_num [revenue₁, revenue₂, reversalGap]
  · norm_num [reversalGap]

/-- Hart–Reny Example E2 / Proposition 9: the second marginal and its iid
product stochastically dominate the first, but unrestricted optimal revenue
strictly decreases. -/
theorem iid_revenue_nonmonotonicity :
    MarginalDominates prior₁ prior₂ ∧ ProductDominates prior₁ prior₂ ∧
    optimalRevenue prior₂ < optimalRevenue prior₁ := by
  refine ⟨marginal_stochastic_dominance, iid_stochastic_dominance, ?_⟩
  have h := exact_optimal_revenues
  linarith [h.2.2.1, h.2.2.2]

end HartReny
