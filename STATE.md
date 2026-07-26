# PROJECT STATE — World Energy Supply and Gross World Product

**Last updated:** 2026-07-26 (session paused mid-task — read this section first)

## ⏸ SESSION PAUSED HERE — READ BEFORE DOING ANYTHING ELSE

**Committed state (in this repo, `.git` history, already pushed-ready):** single-scenario
disruption model, elasticity 0.793, GWP impact **3.7%**, using 14.4 mb/d had NOT yet been
integrated — the committed version still uses the older 12.8 mb/d oil-loss figure. This
is the last *approved and committed* state.

**Pending, NOT yet committed (built in `/tmp/scratch-disruption` in the sandbox, not in
this repo):** a two-scenario version of `02-disruption-impact.R`, built and test-run
successfully, awaiting the user's inspection/approval before being copied into this repo
and committed. If the sandbox scratch copy is gone (it will be, sandboxes don't persist
across sessions), **rebuild from the numbers below** rather than starting the research
over — the research behind these numbers is solid and cited, only the file needs
recreating.

**The two pending scenarios (verified, R-executed, both correct):**

| Scenario | Hormuz oil loss | + Russia net | Total oil loss | % of world oil | Energy lost | **GWP impact** |
|---|---|---|---|---|---|---|
| Realized | 14.4 mb/d | 0.9 mb/d | 15.3 mb/d | 14.3% | 5.17% of world primary energy | **4.1%** |
| Severe (Bab el-Mandeb/Yanbu shutdown) | 18.0 mb/d | 0.9 mb/d | 18.9 mb/d | 17.7% | 6.23% of world primary energy | **4.9%** |

**Reasoning behind the 14.4 and 18.0 figures (needed to rebuild if lost):**
- 14.4 mb/d = IEA's April/May 2026 "Gulf output below pre-war" figure, judged the better
  current-conditions estimate over the outdated-by-late-July "improved June" 9.4-12.8
  range, because current (mid-late July) Hormuz vessel traffic (~15/day vs. 88/day
  baseline, ~90% down y-o-y) has collapsed back to a severity comparable to or worse than
  the original March closure.
- 18.0 mb/d = 14.4 + ~3.6 mb/d from modeling a full Bab el-Mandeb closure shutting down
  Saudi Arabia's Yanbu bypass entirely. Key fact: Yanbu's *port* (not Petroline's *pipe*)
  is the real constraint — pipe capacity is 5-7 mb/d but Yanbu can only load ~3-4 mb/d
  onto tankers (Aramco's own Red Sea refineries consume ~2 mb/d first). UAE's separate
  ADCOP/Fujairah bypass (~1.1-1.8 mb/d) is unaffected by Bab el-Mandeb — it exits directly
  into the Gulf of Oman, never touching the Red Sea. Cross-check: gross Hormuz exposure
  (~20 mb/d) minus the only remaining bypass (ADCOP ~1.8 mb/d) ≈ 18.2 mb/d, consistent.
- Russia net (0.9 mb/d), gas/LNG (120 bcm/yr → 3% of world gas), and elasticity (0.793)
  are all unchanged from the committed version — see below for full sourcing.

**Chart 3 was redesigned once already this session** — first draft put white descriptor
text inside the bars (illegible against the lighter gray/tan institutional bars); fixed
by moving that context into the y-axis labels instead. The corrected version is the one
described above; if rebuilding, use axis-label descriptors, not in-bar text.

## Immediate next steps (in order)
1. Rebuild `02-disruption-impact.R` with the two-scenario logic above (or recover it if
   `/tmp/scratch-disruption` still exists in a live sandbox).
2. Get final user sign-off on the two-scenario chart.
3. Copy into this repo's `02-disruption-impact/`, rerun both scripts, commit.
4. Then: discuss what these numbers mean "in real terms" (user's stated next step,
   not yet started) — and decide whether a further phase of this project is warranted.
5. Push to GitHub (repo not yet created/pushed — see Reference section).

---

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
