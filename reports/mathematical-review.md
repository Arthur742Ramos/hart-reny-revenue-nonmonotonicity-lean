# Independent mathematical review

Reviewed 2026-10-02 by a separate read-only reviewer. No Lean source was edited and no Lean build was started by this reviewer. This report distinguishes mathematical inspection and independent exact arithmetic from kernel checking.

## Reviewed contracts

`Valuation` is the entire nonnegative real quadrant. `Mechanism` maps every such valuation to real allocations and a real payment. `Feasible` imposes both allocation coordinates in [0,1], global IR, and IC for every pair of valuations. Neither the definition nor the universal revenue bound restricts the competitor to the proposed menu.

`Best` first maximizes utility and then payment among utility maximizers. Its finite existence proof takes two maxima. `menuMechanism_feasible` uses the menu outside option for IR and truthful utility maximality against the outcome selected at any misreport for global IC. Arbitrary choices remaining after both ties do not affect the grid payment: `menuMechanism_payment` proves equality of payments with any prescribed `Best` outcome. This suffices for finite-support expectations and avoids claiming equality of allocations when several outcomes tie.

The `revenue` weights are p(i)p(j), so the two coordinate marginals are identically distributed and independent. The probability lemma proves nonnegativity and unit mass. The `optimalRevenue` supremum ranges over all globally feasible mechanisms. The reusable `IsOptimal` predicate requires an attaining globally feasible mechanism plus a bound against every globally feasible competitor. This is the appropriate maximum formulation, and its conversion to `sSup` uses attainment and a universal bound.

Finite expectations are deliberate and valid for atomic priors even when competitors are arbitrary functions. The result is not presented as an equality with a general measure integral; no additional measurable-selector theorem is needed for its stated finite-expectation contract.

## Linear certificate argument

The IR row is -v(i)·q(i)+t(i) ≤ 0. The IC row is -v(i)·q(i)+t(i)+v(i)·q(j)-t(j) ≤ 0. The upper and lower allocation rows are q ≤ 1 and -q ≤ 0. These match global IC/IR after restricting a competitor to the 36 grid points.

`finite_weak_duality` permits arbitrary real unknowns and rational coefficients/multipliers. Summed coefficient equality cancels every allocation variable and gives precisely the expected-payment objective. All used row multipliers must be nonnegative and the summed rational right-hand side must equal the claimed revenue. This proof does not rely on an optimization solver or a finite-menu restriction of the upper bound. A sparse subset of constraints is sufficient: each such constraint follows from global feasibility.

Independent arithmetic with Python `fractions.Fraction` verified the JSON's 30010-byte size and SHA256 `34bba31a6b55e82377f1ae7b159e6330ac668237a4e31487354dda9d1ae6faf4`; parsed both Lean certificate definitions back to the JSON's constraint/multiplier lists; and checked all coefficients and right-hand sides independently. All 83 and 108 entries agree exactly. Their weighted vectors equal the iid payment objective; their bounds and the chosen-menu revenues are exactly 408189937/5875650 and 30614162731/440673750. At each of the 36 valuations the chosen menu outcome is utility maximal, IR, and payment maximal among ties. These arithmetic checks are supporting review evidence, not substitutes for Lean kernel proofs.

## Dominance argument

The marginal coupling sends 2399/9000 from 10 to 10 and 1/9000 from 10 to 13, leaving the other positive masses fixed. Its row sums are prior₁ and its column sums prior₂. All entries are nonnegative, and nonzero entries pair weakly ordered values. The product coupling is the independent product of these transports; it has the required iid row/column marginals and coordinatewise ordering.

`MarginalDominates` and `ProductDominates` quantify over every monotone real test function. `coupling_expectation_le` derives exactly these finite expectation inequalities, including possibly negative test functions. Because both distributions have finite support, every such expectation is defined. This matches first-order stochastic dominance and does not weaken it to selected test functions.

## Source scope

The support, priors, 11 outcomes, chosen grid payments, exact optimum fractions, and direction of reversal agree with [Hart–Reny's November 21, 2013 manuscript](https://math.huji.ac.il/~hart/papers/monot-m-20131121.pdf), Example E2/Proposition 9 and Figure 2, printed pages 17–19. The source model also uses global IC/IR on nonnegative real valuations. This project need not prove mechanism uniqueness or claim mathematical novelty to establish that proposition.

## Status and remaining obligations

Mathematical inspection found no weakened mechanism-optimality or dominance semantics in `Model`, `Basic`, `LinearProgram`, `Restriction`, `Primal`, `Dominance`, or `Certificates` as initially reviewed. The optimum/reversal glue was still being authored at this snapshot and must be inspected after completion. Compilation and authored-declaration standard-axiom auditing remain separate mandatory validation. In particular, the signed IR restriction proof may require arithmetic normalization instead of `simpa`; this is an elaboration issue, not a change to the mathematical contract.

## Final proof-glue inspection

Subsequently reviewed `HartReny/Proof.lean` and the updated `Restriction.lean`. `exact_global_optima` combines global feasibility, exact attained revenues, and certificate bounds for arbitrary global competitors. `exact_optimal_revenues` derives both unrestricted supremum identities and the exact difference `3752/20030625 > 0`. `iid_revenue_nonmonotonicity` combines marginal dominance, iid product dominance, and the strict decrease of unrestricted optimal revenue. These statements have the intended research-level meaning and no mathematical contract gap was found. The earlier IR normalization issue has been corrected to simplification followed by arithmetic reasoning.

This is a positive independent mathematical review of the proof strategy and final theorem semantics. It does not certify elaboration, an authored-declaration axiom audit, Palomar gates, or the official reusable submission workflow; those require the builder's mechanical evidence. No source uniqueness or novelty claim is endorsed.

## Final Challenge and metadata review

Reviewed the final `Challenge.lean`, `comparator.json`, `formalization.yaml`, `Solution.lean`, `HartReny.lean`, and `HartReny/Proof.lean` after the builder reported successful library compilation with Lean v4.35.0-rc3 and pinned current Mathlib. This reviewer still ran no Lean build.

A separate source comparison confirmed that the Model body, Basic body through the revenue constants, and the two dominance definitions are copied verbatim into Challenge. All three named theorem statements are verbatim matches with Proof. The only standalone admission bodies in Challenge are the three `sorry` placeholders for the three configured research theorem targets. Solution imports HartReny, which imports Proof and the proved library; none of those files imports Challenge. No admission, custom-axiom, or native_decide token occurs in that Solution/library import surface.

The local v4.35.0-rc3 implementation in `src/lean/lake/Lake/Check/Compare.lean` confirms the relevant comparison behavior: named theorem types seed a transitive worklist; ordinary reachable declarations must have identical ConstantInfo; only configured theorem/definition targets are treated as body holes. With `definition_names: []`, no semantic definition body is exempted. Thus all semantic dependencies of the compared statements are protected, including the real valuation/mechanism model, exact priors/menu, global selector, finite expectation/supremum, and dominance predicates. This does not mean every unused declaration in Challenge is independently compared: support helpers unreferenced by target types need not enter that closure. The [pinned Palomar declaration-closure note](https://github.com/PalomarRegistry/PalomarSubmission/blob/65f0154ed776cd26c224254aa57b379137f28b0d/docs/comparator-declaration-closure.md) agrees with this interpretation and documents named reference placeholders.

The metadata faithfully states global real valuation scope, arbitrary real payments, finite iid atomic expectations, utility/payment tie-breaking, both attained unrestricted suprema, and monotone-test-function dominance. Its three main results are the reviewed research-level contracts. It includes MSC2020 classifications and the requested three authors/maintainers. It makes no uniqueness, first-formalization, or new-counterexample claim. Its review status explicitly identifies separate independent agent reviews and disclaims external human peer review. The zero-admission/custom-axiom status pertains to the proved library/Solution, with Challenge's reference placeholders separately documented.

No Challenge-contract or metadata-scope mismatch was found. This report is an independent agent mathematical/source inspection, not external human peer review or a replacement for the Comparator, Lean, NanoDa, con-ron, axiom-audit, rendering, sanitizer, or official mechanical-preflight reports.
