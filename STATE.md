# PROJECT STATE — Oil Supply Disruption and World GDP Impact

**Last updated:** 2026-07-28
**Current status:** Full accounting complete. Conversion factor derived
and validated; 2026 disruption accounted for across four components
(Hormuz/Bab el-Mandeb flow, Russia refining, Middle East refining,
reserve depletion); five charts and a full results table produced.
Pushed to GitHub. Forecast/interpretive document ("what this means in
real terms") is the next deliverable, not yet drafted.

## Where things stand right now
- R scripts complete and verified (both run cleanly, numbers match
  hand-calculations exactly).
- Energy-to-GDP conversion factor: **0.79** (R²=0.77, 1971-2021).
- Full disruption accounting finalized: realized = 25.1 mb/d (6.52%
  implied GDP impact), severe/Bab el-Mandeb-Yanbu-shutdown = 28.7 mb/d
  (7.38% implied GDP impact). See README for the full component
  breakdown and sourcing.
- Five charts total, all built and contrast-checked.
- README rewritten to document the full methodology, sourcing, and
  caveats end to end.

## Key decisions made (and why)
- **Reserve depletion treated as "borrowed time," added to the
  disruption total, not netted against it** — reserves masking the
  crisis now means a larger, not smaller, real shortfall once they're
  exhausted.
- **Oil-on-water excluded** — reversed direction mid-crisis, and the
  available series has real gaps.
- **China's reserve behavior excluded from the reserve-rate calculation**
  — it was net-building for most of the crisis, but oil in reserves
  (built or drawn) is oil off the market either way.
- **Russia refining used gross (1.4 mb/d), not netted (0.9 mb/d)** —
  redirected raw crude doesn't produce usable fuel until it's refined
  somewhere.
- **Asian refiners' feedstock-constrained run cuts excluded** — downstream
  symptom of the Hormuz crude shortage already counted.
- **World oil baseline set at 104.4 mb/d** (EIA World Oil Transit
  Chokepoints, 1H25).

## Immediate next steps
1. **Draft the "what this means in real terms" document** — discussed and
   agreed: framed explicitly as a forecast/position, not a neutral
   consensus finding, arguing that the true scale of impact is larger
   than institutional forecasts currently reflect and has not yet fully
   materialized.
