module
import all Solution
import all HartReny.Model
import all HartReny.LinearProgram
import all HartReny.Basic
import all HartReny.Restriction
import all HartReny.Dominance
import all HartReny.Primal
import all HartReny.Certificates
import all HartReny.Proof
import Lean.Util.CollectAxioms

open Lean in
run_cmd do
  let env ← getEnv
  let allowed := #[`propext, `Quot.sound, `Classical.choice]
  let mut count : Nat := 0
  for (name, _) in env.constants.toList do
    if let some idx := env.getModuleIdxFor? name then
      let mod := env.header.moduleNames[idx.toNat]!
      if mod == `Solution || mod == `HartReny || (`HartReny).isPrefixOf mod then
        count := count + 1
        let axioms ← collectAxioms name
        for ax in axioms do
          unless allowed.contains ax do
            throwError "Forbidden axiom {ax} in authored declaration {name}"
        logInfo m!"{name}: {axioms}"
  unless count > 80 do
    throwError "Incomplete authored-declaration audit: only {count} declarations"
  logInfo m!"PASS: audited all {count} authored declarations with only standard axioms."
