# PROJECT STATE — World Energy Supply and Gross World Product

**Last updated:** 2026-07-26
**Current status:** Ported from an initial Python build to R (matching the
rest of the portfolio). Analysis complete and reproducible; not yet run
inside RStudio locally to confirm the port executes cleanly — do that
first, before trusting the regenerated figures/tables.
**One-line goal:** Test whether world GWP is tightly or loosely coupled to
world energy supply using Keen's own data sources, then apply the result
to estimate the GWP impact of the 2026 energy disruption.

## Where things stand right now
- Full R port complete: `01-elasticity-model.R`, `02-disruption-impact.R`,
  `.Rproj`, `.gitignore`, README, STATE.
- Data sources finalized: World Bank `NY.GDP.MKTP.KD` (GWP) + OECD
  `PRYENRGSUPPLY` (energy) — Keen's exact pairing, confirmed via his own
  footnotes.
- Core finding: elasticity = 0.79 (R²=0.77, 1971-2021) — see README for
  the honest gap against Keen's own reported 0.97 for this pairing.
- 2026 disruption applied: implied GWP impact = 3.7%, vs. institutional
  0.6-1.2%.
- Chart 1 rebuilt with dual independent y-axes to match Keen's own
  presentation convention (was previously an indexed-to-100 chart, which
  is legitimate but visually argues the opposite point — see README).

## Known risk, not yet resolved
**This R port has not been executed.** The Python version was verified to
run end-to-end and produce these exact numbers; the R port is a faithful
translation but R syntax/package behavior (especially `sec_axis()` for the
dual-axis chart, and `pivot_longer`/`fct_inorder` usage) has not been
confirmed to execute without error. Run both scripts in RStudio first and
report back anything that breaks before treating the R-generated figures
as final.

## Key decisions made (and why)
- **PPP retired as GWP standard, constant-2015-USD adopted instead:**
  matches Keen's own cited source exactly; the retired PPP series didn't
  actually contradict this one, but the decision stands regardless.
- **Dual-axis chart convention adopted for Chart 1:** faithfulness to
  Keen's own presentation was judged more important than the (also
  legitimate) indexed-to-100 alternative, once it was confirmed his own
  chart uses this convention.
- **Fuel-mix breakdown kept on OWID/Energy Institute data:** the OECD
  series is a single aggregate total with no oil/gas breakdown, so this
  supplementary use is a different, compatible role for that dataset, not
  a reversion to the retired approach.

## Open questions / unresolved
- Why does this reproduction (0.79) not match Keen's own reported 0.97 for
  what should be the identical data pairing? Candidate explanations (data
  vintage/revisions, 2-year-longer window, unspecified regression detail)
  are listed but not confirmed.
- Full-history (1971+) vs. modern-era-only (1990+) elasticity gap remains
  unexplained — same open question as in the earlier PPP-based version of
  this analysis.
- Whether to pursue the Bab el-Mandeb/Russia disruption estimate further,
  or treat 3.7% as the standing headline number.

## Immediate next steps
1. Run both R scripts locally in RStudio; fix anything that breaks.
2. Confirm the regenerated figures match what was produced by the Python
   version (elasticity 0.793, GWP impact 3.7%, dual-axis Chart 1 visually
   matching Keen's convention).
3. Push to GitHub once confirmed working.
4. Decide whether to chase the Keen-reported-0.97-vs-reproduced-0.79 gap
   further, or note it as an open limitation and move on.

## Reference
**Prior Python build:** superseded by this R port; not retained in this
repo.
**Keen's chapter:** profstevekeen.substack.com/p/the-role-of-energy-in-economics
(Chapter 9 of *Money and Macroeconomics from First Principles*)
**Keen's earlier paper:** Keen, Ayres & Standish (2019), "A Note on the
Role of Energy in Production," *Ecological Economics*.
