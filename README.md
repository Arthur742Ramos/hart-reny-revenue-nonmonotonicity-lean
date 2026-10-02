# Hart–Reny iid revenue nonmonotonicity

This project formalizes Example E2 and Proposition 9 of [Hart and Reny's
November 21, 2013 manuscript](https://math.huji.ac.il/~hart/papers/monot-m-20131121.pdf),
printed pages 17–19. It proves that raising an iid two-good valuation
distribution in first-order stochastic dominance can lower optimal revenue.
The mathematical counterexample is Hart and Reny's; no new counterexample or
priority claim is made.

The marginal support is `[10,13,46,47,80,100]`. The second distribution moves
mass `1/9000` from 10 to 13. The unrestricted optimal revenues are
`408189937/5875650` and `30614162731/440673750`; their difference is the positive
fraction `3752/20030625`.

`Valuation` is the entire nonnegative real quadrant. A mechanism chooses
two allocations in `[0,1]` and a real payment at every valuation. `Feasible`
requires global incentive compatibility and individual rationality. Revenue
is a finite expectation under the displayed atomic iid prior, and
`optimalRevenue` is its supremum over **all** globally feasible mechanisms.
The upper bound permits arbitrary real competitors.

The eleven-outcome menu includes the outside option. Its global mechanism
maximizes utility and then payment among utility ties. Lean proves global
IC/IR, checks the prescribed payments at all 36 grid types, and proves that
the menu attains both exact suprema. A reusable finite weak-duality theorem
turns nonnegative rational multipliers and exact coefficient identities into
bounds for arbitrary real unknowns. The two supplied sparse certificates
have 83 and 108 multipliers. Explicit marginal and independent product
couplings prove dominance for every monotone real test function.

Selected research results:

- `HartReny.exact_global_optima`: a common global mechanism attains both
  exact revenues, and every globally feasible competitor satisfies the bounds.
- `HartReny.exact_optimal_revenues`: both unrestricted supremum values and
  their positive exact gap.
- `HartReny.iid_revenue_nonmonotonicity`: marginal and product dominance
  together with strict optimal-revenue decrease.

The pinned toolchain is Lean `v4.35.0-rc3`, with current Mathlib commit
`19cdde90293121f0047bb385278520a5cb5392c0`. Build with `lake build`.
Run the authored-declaration audit with `lake env lean scripts/Audit.lean`.
`scripts/generate_certificates.py` deterministically transcribes the supplied
JSON; it does not prove anything or invoke a solver. Lean checks every
identity. No library or Solution proof uses admissions, custom axioms,
`native_decide`, or solver correctness assumptions.

The original Library JSON remains in the consumer's local `research/` directory
and is excluded from publication. The reviewed exact numerical data used in
the proof are fully specified by the public Lean definitions. The optional
generator is for a consumer who already holds that exact authorized input.

`Challenge.lean` imports only Mathlib and gives the exact semantic definitions.
Its three named theorem bodies are reference placeholders documented under
[Palomar's declaration-closure policy](https://github.com/PalomarRegistry/PalomarSubmission/blob/65f0154ed776cd26c224254aa57b379137f28b0d/docs/comparator-declaration-closure.md).
They are not imported by `Solution.lean`. Comparator checks the identical
contracts and their transitive definition closure. `definition_names` is
empty so no semantic definition body is treated as a hole.

Separate agent reviews are in `reports/source-review.md` and
`reports/mathematical-review.md`. These are independent agent inspections,
not external human peer review. The scope excludes mechanism uniqueness,
general-measure integral equivalences, and claims of being the first
formalization. Mechanical preflight, rendering, review, and registration
are distinct stages; see the final validation report for their actual status.

Authors and maintainers: Arthur Freitas Ramos, David Barros Hulak, and
Ruy Jose Guerra Barretto de Queiroz. License: Apache-2.0.
