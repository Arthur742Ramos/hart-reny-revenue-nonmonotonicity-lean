"""Encode the supplied exact certificate as ordinary Lean source.

This generator proves nothing. Every multiplier and coefficient identity is
checked independently by Lean's kernel; no solver is invoked.
"""
import hashlib
import json
from pathlib import Path

root = Path(__file__).resolve().parent.parent
raw = (root / 'research/hart-reny-research-certificates.json').read_bytes()
assert len(raw) == 30010
assert hashlib.sha256(raw).hexdigest() == '34bba31a6b55e82377f1ae7b159e6330ac668237a4e31487354dda9d1ae6faf4'
data = json.loads(raw)

def grid(i):
    assert 0 <= i < 36
    return f'({i // 6},{i % 6})'

lines = ['module', 'public import HartReny.Basic', '', '@[expose] public section', '', 'namespace HartReny',
         'set_option maxRecDepth 100000', 'set_option maxHeartbeats 8000000', '']
for n, dist in enumerate(data['distributions'], 1):
    suffix = ['₁', '₂'][n-1]
    lines += [f'def certificate{suffix} : List (ℚ × Constraint) := [']
    for idx, row in enumerate(dist['dual']):
        c = row['constraint']
        if c[0] == 'IC':
            expr = f'.ic {grid(c[1])} {grid(c[2])}'
        elif c[0] == 'IR':
            expr = f'.ir {grid(c[1])}'
        else:
            assert c[0] in ['upper', 'lower'] and c[2] in [0,1]
            expr = f'.{c[0]} {grid(c[1])} {c[2]}'
        end = ',' if idx + 1 < len(dist['dual']) else ']'
        lines += [f'  ({row["multiplier"]}, {expr}){end}']
    lines += ['', f'theorem certificate{suffix}_nonnegative :',
              f'    ∀ r ∈ dualRows certificate{suffix}, 0 ≤ r.1 := by',
              f'  norm_num [dualRows, certificate{suffix}]', '',
              f'theorem certificate{suffix}_coefficients :',
              f'    ∀ i, weightedCoefficients (dualRows certificate{suffix}) i = objective prior{suffix} i := by',
              '  intro ⟨⟨i,j⟩,k⟩',
              '  fin_cases i <;> fin_cases j <;> fin_cases k <;>',
              f'    norm_num [weightedCoefficients, dualRows, certificate{suffix}, constraintRow,',
              f'      basis, values, objective, prior{suffix}]', '',
              f'theorem certificate{suffix}_bound :',
              f'    weightedBound (dualRows certificate{suffix}) = revenue{suffix} := by',
              f'  norm_num [weightedBound, dualRows, certificate{suffix}, constraintRow, revenue{suffix}]', '']
lines += ['end HartReny', '']
(root / 'HartReny/Certificates.lean').write_text('\n'.join(lines))
