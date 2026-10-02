# Local validation of the dependency adjustment

All eleven serial build targets passed with Lean v4.35.0-rc3 and Mathlib
5e043698502894993991089b2dd893867c0db5c2. LEAN_NUM_THREADS=1 bounded the
local checks. The exact primal feasibility/revenues, dual certificate
identities and nonnegativity, global extension/restriction, and dominance
proofs compiled with authored Lean source unchanged.

The fresh authored-declaration audit passed all 233 declarations with only
propext, Quot.sound, and Classical.choice. See dependency-axiom-audit.txt.
The authentic bundled Comparator, Lean default kernel, NanoDa and con-ron
all accepted the solution. See dependency-kernel-replay.txt.

The macOS replay uses Lake's documented no-sandbox option; this is local
supporting evidence, not the authoritative hosted full preflight. Fresh
exact-candidate hosted mechanical and trusted-rendering/sanitizer reports
remain separate required gates. No intake or registration was performed.
