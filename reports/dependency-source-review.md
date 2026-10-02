# Independent dependency and source review

Reviewed 2026-10-02, read-only except for this report. Baseline published candidate: `a1ae211c429d7fdf1b69cddb0556293b1c4020b3`. Reviewed working branch: `render-compatible-mathlib`. No builds, Lean/workflow mutations, external writes, or third-party contacts were performed by this reviewer.

## Source and contract preservation

All 12 tracked authored Lean files, including `Challenge.lean`, `Solution.lean`, `HartReny.lean`, the eight `HartReny/` modules, and `scripts/Audit.lean`, were compared as bytes against the baseline Git objects and are identical. `comparator.json`, `formalization.yaml`, `lean-toolchain`, `reports/source-contract.json`, the generator, and `.github/workflows/render.yml` also remain byte-identical. The Challenge SHA256 remains `67bdb79dadccf4b1772790d8c59c334fc70a3f3ff743a054165d8b040e6dbf87`.

The research JSON remains exactly 30010 bytes with SHA256 `34bba31a6b55e82377f1ae7b159e6330ac668237a4e31487354dda9d1ae6faf4`.

The following source numerics therefore preserve the previously reviewed exact-source agreement: support `[10,13,46,47,80,100]`, the stated priors, all eleven menu outcomes, the 36 lexicographically indexed selected outcomes, both sparse certificates, exact revenues `408189937/5875650` and `30614162731/440673750`, and positive reversal gap `3752/20030625`. The source attribution remains [Hart–Reny Example E2/Proposition 9](https://math.huji.ac.il/~hart/papers/monot-m-20131121.pdf), printed pages 17–19. No novelty claim is added.

The binders also remain unchanged. `Valuation` is the full nonnegative real quadrant; `Feasible` requires allocation bounds, IR at every valuation, and IC for every pair of reports. Payments remain arbitrary reals. `optimalRevenue` is a supremum over all global mechanisms satisfying `Feasible`, using the explicitly finite iid expectation. The global menu maximizes utility and then payment, includes an outside option, and its prescribed grid payments are proved. The upper bound still restricts arbitrary real global competitors to the finite LP. Marginal and product dominance still quantify over every monotone real test function. This dependency adjustment makes no mathematical weakening.

The three Challenge theorem placeholders are unchanged, exactly the named Comparator targets. `definition_names` remains empty; permitted axioms remain `propext`, `Quot.sound`, and `Classical.choice`. A textual scan finds no admission, custom-axiom declaration, or `native_decide` in the library or Solution. This scan and source equality do not replace a fresh elaboration and authored-declaration axiom audit under the changed dependencies.

## Dependency identity review

Lean remains `leanprover/lean4:v4.35.0-rc3`. The direct Mathlib pin changes from `19cdde90293121f0047bb385278520a5cb5392c0` to `5e043698502894993991089b2dd893867c0db5c2` in both the Lakefile and root manifest. The actual Mathlib checkout is at the new revision and its `lean-toolchain` is also rc3. Every inherited package name/revision in the root manifest agrees with the new Mathlib checkout's own manifest. This is a coherent dependency update, not an isolated hand-edited overlap.

The supplied rc3 Verso manifest and actual root Lake manifest overlap on exactly `Cli` and `plausible`. Normalized repository URLs and exact revisions match:

| Package | rc3 common revision |
|---|---|
| Cli | `843844fa601dd56767b1eb22b7ada5b64d5e567a` |
| plausible | `fb13df72ecefd8ddbf9291021d7f33a8673eb57b` |

The expected union including Verso is 13 packages. The diagnostic identifies the rc3 Verso release as `8fc7a297f14d5adc1a551b5b4ecf283c08bd691f`. The rc2 reference manifest instead uses Cli `2842b9871b04862f944c032e34052cb9448ccb71` and plausible `e50948299c4dc4a4c21b1c34b6a6a4fddc19f912`, consistent with the supplied rc2 reference information. Prior rc2 rendering success is contextual evidence only; it does not establish hosted rc3 rendering success.

## Official renderer and gate policy

The local trusted pipeline checkout is exactly `65f0154ed776cd26c224254aa57b379137f28b0d` and has no tracked working-tree diff. Reading its `scripts/render_challenge.py` confirms that release candidates resolve to the exact corresponding Verso release, and `merge_renderer_manifest` rejects same-name packages with differing normalized Git repository/revision identities. The new overlaps satisfy that unchanged comparison. The trusted audit, sanitizer, sandbox, and per-file `8 * 1024 * 1024` byte bound are not edited or bypassed.

The rendering workflow is byte-identical to the baseline and pins that same trusted pipeline. The mechanical workflow changes only `request_id` from `hartreny0001` to `hartreny0002`; it still calls the official reusable `submission.yml` at the exact matching pipeline SHA, uses `mode: full`, and uses `execution_profile: palomar-standard-v1`. This request identifier adjustment does not alter gates or policy.

## Prose and evidence limits

The diagnostic report explicitly calls the local manifest merge a diagnostic, distinguishes it from hosted rendering, and requires fresh rebuild, axiom audit, kernel replay, official mechanical and rendering reports. This is appropriate. Historical reports retain their original Mathlib revision and are described as historical rather than retroactively reattributed to the new dependency pin.

During review the README's initial unqualified `renderer-compatible` wording was raised with the authoring agent. That adjective was subsequently removed: the README states the exact Mathlib pin and retains its distinction between mechanical preflight, rendering, review, and registration. No theorem-scope prose change was required.

## Conclusion

Pass for exact-source preservation, mathematical contract preservation, coherent rc3 dependency identities, and unchanged official policy. No numerical or scope discrepancy was found. This is not a compilation, axiom-audit, kernel-replay, hosted-mechanical, hosted-rendering, or submission approval. Readiness remains conditional on fresh exact-candidate reports for those gates.
