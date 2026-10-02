"""Produce a closed exact statement surface without local imports.

Only the three compared research theorems have reference placeholders. Every
definition and supporting proof appearing in the statement closure is copied
verbatim from the library; the Solution does not import the Challenge.
"""
from pathlib import Path

root = Path(__file__).resolve().parent.parent

def body(file):
    source = (root / file).read_text()
    return source.split('namespace HartReny\n', 1)[1].rsplit('\nend HartReny', 1)[0]

model = body('HartReny/Model.lean')
basic = body('HartReny/Basic.lean').split('\ndef basis ', 1)[0]
dominance = body('HartReny/Dominance.lean').split('/-- The explicit transport', 1)[0]
proof = body('HartReny/Proof.lean')
names = ['exact_global_optima', 'exact_optimal_revenues', 'iid_revenue_nonmonotonicity']
contracts = []
for name in names:
    start = proof.index('theorem ' + name)
    statement = proof[start:].split(' := by', 1)[0]
    contracts.append(statement + ' := by\n  sorry\n')

imports = '\n'.join(line for line in (root/'HartReny/Model.lean').read_text().splitlines()
                    if line.startswith('public import Mathlib.'))
imports += '\npublic import Mathlib.Algebra.Order.Archimedean.Real.Basic\n'
source = '''module
'''+imports+'''
/-! Exact reference contracts for Hart–Reny Example E2/Proposition 9.
The three `sorry` bodies below are reference-only placeholders for the named
Comparator targets. Solution and the library contain no admissions or custom
axioms. All semantic definitions and their dependencies are fully specified.
-/
@[expose] public section
namespace HartReny
'''+model+'\n'+basic+'\n'+dominance+'\n'+ '\n'.join(contracts)+'\nend HartReny\n'
(root/'Challenge.lean').write_text(source)
