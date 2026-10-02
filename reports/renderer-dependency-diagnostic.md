# Supported renderer dependency adjustment

The original candidate `a1ae211c429d7fdf1b69cddb0556293b1c4020b3` passed
the full mechanical preflight but failed rendering before HTML generation.
This branch preserves all authored Lean files byte for byte and retains
Lean `v4.35.0-rc3`. It pins Mathlib to its 2026-09-29 revision
`5e043698502894993991089b2dd893867c0db5c2`, immediately preceding the
dependency update which diverged from the official Verso release.

The unchanged official pipeline is
`65f0154ed776cd26c224254aa57b379137f28b0d`.
Its `scripts/render_challenge.py` resolves release-candidate toolchains to
the exact corresponding Verso release and refuses conflicting dependency
identities. For each package name, Git identity is package type, normalized
repository, and exact revision. The rule is preserved; no package is removed or replaced in the
renderer, and no trusted audit or sanitizer is bypassed.

For Verso `v4.35.0-rc3`, commit
`8fc7a297f14d5adc1a551b5b4ecf283c08bd691f`, both common dependencies match
the Lake-generated manifest of this candidate:

| Dependency | Matching Mathlib and Verso revision |
|---|---|
| plausible | `fb13df72ecefd8ddbf9291021d7f33a8673eb57b` |
| Cli | `843844fa601dd56767b1eb22b7ada5b64d5e567a` |

Calling the official, unmodified `merge_renderer_manifest` with the actual
Lake-generated source manifest succeeds and produces 13 packages. This is
a local diagnostic, not evidence of completed hosted rendering.
The saved Verso manifest was fetched again through GitHub at the exact
release commit and verified byte-identical, SHA256
`94dc7ca786cc5b60c3620b5a9b073326c6735c846be2b33ab58be0ad7d4696d6`.

As an independent compatibility comparison, the successful Gershkov and BCE
repositories use Lean `v4.35.0-rc2`, Mathlib
`065356127b1dc0016f66b7283ce0ce2c4055aa55`, and Verso release commit
`9f8096e40b31715b1d8d5997f15a0bd832f7e37d`. Their shared dependencies also
match exactly: plausible `e50948299c4dc4a4c21b1c34b6a6a4fddc19f912` and
Cli `2842b9871b04862f944c032e34052cb9448ccb71`.
Examples of successful rendering runs:

- https://github.com/Arthur742Ramos/gershkov-bic-dic-lean/actions/runs/37045694200
- https://github.com/Arthur742Ramos/bayes-correlated-equilibrium-lean/actions/runs/37021812952

This candidate uses the more recent rc3 toolchain and compatible Mathlib
revision rather than copying the older projects' toolchain. The original
source and mathematical reports remain historical records of the first
candidate. Fresh dependency review, rebuild, all-declaration axiom audit,
Comparator/default Lean/NanoDa/con-ron replay, and exact-candidate official
mechanical and rendering reports are required before readiness. Their
results must be read from the final handoff report, not inferred from this
successful manifest diagnostic.
