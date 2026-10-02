# Independent source and certificate review

Reviewed 2026-10-02. This is an exact-source and mathematical-scope review, not a completed Lean proof audit. No Lean files or external resources were modified.

## Source agreement

Primary source: [Hart and Reny, November 21, 2013 manuscript](https://math.huji.ac.il/~hart/papers/monot-m-20131121.pdf), Example E2 and Proposition 9, printed pages 17–19 (zero-based PDF pages 16–18). The model on printed page 4 uses all nonnegative real valuations, allocation coordinates in [0,1], real payments, global IC/IR, and maximal expected revenue. Figure 2 supplies the 11 outcomes. The manuscript explicitly identifies its fractions as exact. The [journal publication](https://www.econtheory.org/ojs/index.php/te/article/viewArticle/20150893/0) is Theoretical Economics 10 (2015), 893–922.

The certificate support, both marginal priors, all menu entries, all 36 selected outcomes in lexicographic type order, and both exact revenue fractions agree with those manuscript pages. The first prior assigns zero mass to 13; the second moves 1/9000 from 10 to 13. The paper's uniqueness wording should be understood on the relevant support: unrestricted uniqueness of functions away from that support is not established by a finite LP.

## Independent exact calculation

Input `research/hart-reny-research-certificates.json` is readable JSON, exactly 30010 bytes, SHA256 `34bba31a6b55e82377f1ae7b159e6330ac668237a4e31487354dda9d1ae6faf4`.

A separate Python `fractions.Fraction` calculation, using the signed constraint convention in the delegation, verified:

- Both marginals have nonnegative weights summing to one.
- Every menu allocation coordinate lies in [0,1].
- All 36 IR constraints and all 1296 IC constraints hold.
- Each selected outcome maximizes utility over all 11 menu entries; among tied maximizers its payment is maximal.
- For each of the 83 and 108 supplied nonzero dual multipliers, the multiplier is nonnegative. Summing the constraint coefficient vectors gives exactly the iid expected-payment objective: allocation coefficients zero, payment coefficient at type (i,j) equal to p(i)p(j).
- The summed right-hand sides match the primal revenues `408189937/5875650` and `30614162731/440673750`.
- Their exact difference is `3752/20030625 > 0`.

These calculations validate the research data independently of the solver. They do not replace kernel-checked Lean coefficient identities or feasibility proofs.

## Required theorem semantics

For a finite menu with an outside option, choose at every nonnegative real valuation an outcome maximizing utility, then maximize payment among utility maximizers. Both stages have a maximizer because the menu is finite. The outside option proves IR. Any outcome chosen at a misreport is still a menu member, so maximality at the truthful valuation proves global IC. Its allocation bounds follow from bounds on every menu entry.

The grid calculation must connect this global choice to the selected outcome data. Equality of outcomes is stronger than needed: utility/payment maximality and equality of the selected payment suffice for the exact expectation. Payment tie-breaking is essential when an indifferent buyer could otherwise choose a smaller payment.

For the upper bound, start with an arbitrary real-valued global mechanism satisfying allocation bounds and global IC/IR. Its restriction to the 36 valuations satisfies the certificate's finite constraints. Weak duality then bounds the finite expected payment. This argument quantifies over all globally feasible mechanisms, rather than only mechanisms taking values in the supplied menu.

The lower bound is an attained revenue from the constructed global mechanism. Combined with the universal upper bound, it proves unrestricted optimality. If a supremum is defined, prove nonemptiness and boundedness before using real `sSup` identities; an attained greatest revenue formulation also states the needed result directly.

Finite support makes the expectation a finite sum. The paper additionally discusses payment measurability. A theorem deliberately using finite expectations over arbitrary global functions gives the same upper bound even for functions without a measurability hypothesis. For an explicit connection to probability-measure integrals, include measurability or prove it for the finite menu selector. A deterministic index rule after utility/payment ties gives regions described by finitely many linear inequalities and is measurable.

An explicit marginal coupling sends mass 2399/9000 from 10 to 10, mass 1/9000 from 10 to 13, and leaves the other positive masses fixed. Each pair has increasing valuation. Its independent product yields a coordinatewise increasing coupling between the iid products. Prove both marginals of each coupling and total mass, or equivalently prove the finite monotone-test-function inequality from this coupling. Coupling domination and strict revenue reversal together are the final research-level result.

## Prior-art search and claim limits

Authenticated GitHub repository searches for `hart-reny`, `Hart Reny Lean`, and `revenue nonmonotonicity` returned no repositories. A control search for `auction lean` returned existing auction formalization projects, including [metareflection/vickrey](https://github.com/metareflection/vickrey), and the user's Myerson, Border, and Bulow–Klemperer repositories. This control confirms that the repository-search connector produced results, but repository metadata search is not an exhaustive code search.

The current [Mathlib import index](https://leanprover-community.github.io/mathlib4_docs/Mathlib.html) had no matches for `GameTheory`, `Auction`, or `Revenue`. This is a narrow negative observation about module names, not proof that no relevant declaration exists.

General web queries for the exact topic plus Lean/Isabelle returned no identifiable formalization. The search responses were often irrelevant. Direct AFP topic/auction entry URLs were unavailable to the web tool. A GitHub code-search attempt failed argument binding, and direct shell GitHub API access was network-blocked. Consequently the defensible claim is only: **no prior formalization was located in the searches performed**. Do not claim the first formalization, an exhaustive prior-art review, or mathematical novelty of the counterexample.

## Review conclusion

The supplied data agrees with the source and supports the intended certificate strategy. No numerical discrepancy or mathematical obstruction was found. Completion still requires Lean proofs of global menu selection, universal restriction/duality, exact optimality, coupling, and reversal; final authored-declaration axiom audit and platform gates remain outside this review.
