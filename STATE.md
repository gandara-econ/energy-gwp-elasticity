# PROJECT STATE — World Energy Supply and Gross World Product

**Last updated:** 2026-07-28
**Current status:** Full accounting complete. Elasticity estimated and
validated against Keen's exact data sources; 2026 disruption accounted for
across four components (Hormuz/Bab el-Mandeb flow, Russia refining, Middle
East refining, reserve depletion); five charts and a full results table
produced. Not yet pushed to GitHub. Not yet written up as a "what this
means in real terms" interpretive document — that's the deliberate next
step, paused for discussion before drafting.

## Where things stand right now
- R port complete and verified (elasticity script + disruption script both
  run cleanly, numbers match hand-calculations exactly).
- Elasticity: **0.79** (R²=0.77, 1971-2021), using Keen's own cited data
  pairing (World Bank `NY.GDP.MKTP.KD` + OECD `PRYENRGSUPPLY`) on both
  sides for the first time.
- Chart 1 rebuilt with dual independent axes to match Keen's own
  presentation convention, confirmed directly against a screenshot of his
  actual chart.
- Full disruption accounting finalized: realized = 25.1 mb/d (6.52% implied
  GWP impact), severe/Bab el-Mandeb-Yanbu-shutdown = 28.7 mb/d (7.38%
  implied GWP impact). See README for the full component breakdown and
  sourcing.
- Five charts total, all built and contrast-checked (caught and fixed two
  separate white-text-on-light-background legibility issues during this
  session — see git history / conversation record for details).
- README fully rewritten to document the whole methodology, sourcing, and
  caveats end to end.

## Key decisions made this session (and why)
- **Reserve depletion treated as "borrowed time," added to the disruption
  total, not netted against it** — the user's framing: reserves masking
  the crisis now means a larger, not smaller, real shortfall once they're
  exhausted.
- **Oil-on-water excluded** — reversed direction mid-crisis (fell in
  March, rose in April/June), and the available series has real gaps.
  Failed the same reliability bar applied everywhere else in this project,
  so left out rather than estimated with false precision.
- **China's reserve behavior excluded from the reserve-rate calculation**
  — it was net-building for most of the crisis, but oil in reserves
  (built or drawn) is oil off the market either way, so this doesn't
  offset the depletion measured in the US/Japan/EU.
- **Russia refining used gross (1.4 mb/d), not netted (0.9 mb/d)** in this
  fuel-product accounting — redirected raw crude doesn't produce usable
  fuel until it's refined somewhere, so the crude-supply netting logic
  used earlier in the project doesn't apply to a refined-product loss
  question.
- **Asian refiners' feedstock-constrained run cuts excluded** — downstream
  symptom of the Hormuz crude shortage already counted; including it too
  would double-count.
- **World oil baseline corrected to 104.4 mb/d** (EIA World Oil Transit
  Chokepoints, 1H25), from an earlier, rounder 107 mb/d estimate.

## Open questions / unresolved
- Why this reproduction (0.79) doesn't match Keen's own reported 0.97 for
  what should be the identical data pairing — still not resolved.
- Whether the situation has moved further since late July 2026 (this is
  an actively evolving conflict; every disruption figure here reflects a
  specific, dated snapshot, not a stable long-run state).

## Immediate next steps
1. Push to GitHub (not yet done — repo not yet created).
2. **Discuss appraisal of the situation** before drafting the "what this
   means in real terms" document — explicitly paused per instruction,
   waiting for that discussion before writing anything.
3. Once discussed: draft the real-terms interpretive document as a
   separate deliverable.

## Reference
**Keen's chapter:** profstevekeen.substack.com/p/the-role-of-energy-in-economics
(Chapter 9 of *Money and Macroeconomics from First Principles*)
**Keen's earlier paper:** Keen, Ayres & Standish (2019), "A Note on the
Role of Energy in Production," *Ecological Economics*.
