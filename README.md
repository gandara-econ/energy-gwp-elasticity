# World Energy Supply and Gross World Product: An Elasticity Test

**Question:** How sensitive is world output (Gross World Product) to changes
in world primary energy supply — and what does that imply for the ongoing
2026 energy disruption (Hormuz closure, Bab el-Mandeb threat, and the
Russian/Middle East refinery crisis)?

## Approach

Mainstream production functions treat energy's contribution to GDP as
roughly equal to its cost share of the economy (~3-5%). A heterodox
framework — Steve Keen, with Robert Ayres and Russell Standish (2019,
*Ecological Economics*; extended in Keen's 2025 chapter "The Role of
Energy in Economics") — argues this badly understates energy's true role.
Their argument: energy has no substitute in production (labour without
energy is inert; capital without energy is just idle machinery), so a
Leontief (fixed-proportions) production function fits the data better than
the Cobb-Douglas form mainstream economics defaults to, implying an output
elasticity of energy close to 1, not close to 0.

This project independently re-estimates that elasticity using Keen's own
cited data sources — not an approximation of them — and then applies the
result to the real, ongoing 2026 disruption to see what each framework
implies for global GDP, using as complete an accounting of the disruption
as the available data supports.

## Data sources

- **GWP:** World Bank, GDP (constant 2015 US$), indicator `NY.GDP.MKTP.KD`.
  Confirmed via Keen's own footnotes as his source. Official wide-format
  download, parsed directly (no hand-transcription).
- **Energy:** OECD/DP_LIVE, `WLD.PRYENRGSUPPLY.TOT.MLN_TOE.A` ("World,
  Primary energy supply, Total, Million tonnes oil equivalent, Annual").
  Also confirmed via Keen's footnotes. Covers 1971-2021, closely matching
  his stated 1971-2019 window.
- **World fuel-mix breakdown (oil/gas/total, 2024):** Energy Institute
  Statistical Review + EIA, via Our World in Data — used only in Step 2 to
  split the disruption by fuel type, since the OECD series above is a
  single aggregate total with no fuel-type split.
- **World oil supply baseline:** EIA World Oil Transit Chokepoints report,
  1H 2025 edition (104.4 mb/d) — corrected mid-project from an earlier,
  rounder 107 mb/d estimate.

**Retired:** the Maddison Project PPP-adjusted GWP series was tested
against an interim energy series early in this project and did *not* tell
a contradictory story (elasticity 0.94 vs. 0.86 using the interim energy
pairing — both far above the mainstream ~0.03-0.05 prediction). Retired in
favor of Keen's exact source regardless of that result, not because the
PPP data was disproven. Kept in `data/raw/archive/` for the record.

## Finding 1: The elasticity

**Output elasticity of energy: 0.79** (R²=0.77, 1971-2021, n=51), using
Keen's exact data pairing on both sides for the first time in this
project's history.

This is far above the mainstream cost-share prediction (~0.03-0.05) — not
a close call. It sits below Keen's own reported figure for the same
pairing (0.97), an honest, unresolved gap: possible causes include data
revisions since his April 2025 chapter, a window extending two years
further (2021 vs. his 2019), or an unspecified detail of his exact
regression setup. The qualitative finding replicates cleanly even though
the precise number doesn't: this project's own robustness check found the
same "modern era fits tighter than the full historical window" pattern
Keen's own reported statistics show (his R²=0.70 across the full 1971-2019
window is lower than the 0.82+ this project finds when restricted to
1990+ subsamples).

**Chart 1 convention note:** built with dual independent y-axes, matching
Keen's own presentation style (confirmed directly against his chart, not
assumed) — energy on its own left axis, GWP on its own right axis, each
auto-scaled to its own range. This convention will visually flatter any
two co-trending series into looking closely aligned, regardless of their
true relative growth rates (GWP has in fact grown faster than energy
throughout this period). The growth-rate elasticity in Chart 2 is the
claim this project actually rests on, not the visual alignment in Chart 1
alone. See the script header in `01-elasticity-model.R` for the full
reasoning behind this chart-type choice.

## Finding 2: The 2026 disruption, fully accounted

The disruption is treated as three simultaneous, non-overlapping crises,
plus a fourth "borrowed time" factor:

| Component | Realized | Severe (Bab el-Mandeb/Yanbu shutdown) | Basis |
|---|---|---|---|
| Hormuz/Gulf flow disruption | 14.4 mb/d | 18.0 mb/d | IEA Oil Market Reports; current vessel-traffic collapse (~15/day vs. 88/day baseline) shows severity back at or beyond the original March peak |
| Russia refining (gross) | 1.4 mb/d | 1.4 mb/d | Energy Aspects/Bloomberg refining-throughput data, independently corroborated by Reuters' ~25% y-o-y fuel-output decline |
| Middle East refining capacity offline | 3.0 mb/d | 3.0 mb/d | IEA: "~3 mb/d of refining capacity in the region has already shut due to attacks and a lack of viable export outlets" |
| Reserve depletion rate | 6.3 mb/d | 6.3 mb/d | Cross-validated: EIA's own Short-Term Energy Outlook (6.3 mb/d, 2Q26 actual) and Energy Intelligence/Turner Mason (~6.5 mb/d) — two independent institutions, two different methodologies, converging closely |
| **Total** | **25.1 mb/d** | **28.7 mb/d** | |
| % of world oil | 24.0% | 27.5% | |
| % of world primary energy | 8.22% | 9.30% | |
| **Implied GWP impact** | **6.52%** | **7.38%** | |

For comparison, the mainstream institutional range for this same event is
**0.6% (IMF/Oxford Economics moderate) to 1.2% (Oxford Economics
severe/prolonged)** — this analysis implies roughly **10-12x** that range.

### Why four components, not one

- **Hormuz/Bab el-Mandeb** is upstream crude extraction — wells shut in
  because there's nowhere to ship the oil. The severe scenario adds the
  Yanbu bypass shutdown: Saudi Arabia's Petroline pipe has 5-7 mb/d of
  capacity, but Yanbu's *port* can load only ~3-4 mb/d onto tankers
  (Aramco's own Red Sea refineries consume ~2 mb/d before any export
  crude reaches the terminal) — the port, not the pipe, is the real
  constraint. The UAE's separate ADCOP/Fujairah bypass is unaffected by
  this scenario; it exits directly into the Gulf of Oman, never touching
  the Red Sea.
- **Refining capacity (Middle East + Russia)** is downstream conversion
  capacity — a genuinely separate physical asset from crude wells. Tested
  against a specific criterion before inclusion: *"would this loss still
  exist even if Gulf crude extraction fully recovered tomorrow?"* Both
  pass — refineries destroyed by direct attack don't come back just
  because crude starts flowing again. Asian refiners' feedstock-
  constrained run cuts were deliberately **excluded** — that's a
  downstream symptom of the Hormuz crude shortage already counted above,
  and including it too would double-count the same barrels.
- **Reserve depletion** is "borrowed time," not a permanent loss: the rate
  at which the world (excluding Gulf holdings, which were never reaching
  the market anyway) has been spending down commercial and strategic oil
  stocks to mask the true scale of the shortfall. Once reserves are
  exhausted, this rate converts into real, unmasked shortfall on top of
  everything else. China's reserve behavior (it was net-*building*
  reserves for most of this period, only drawing modestly from May
  onward) is excluded from this rate's calculation, on the reasoning that
  oil sitting in reserves — built or drawn — is oil off the market either
  way, so a build in one country doesn't net against a draw elsewhere for
  purposes of "how much is being masked from the real economy."
- **Oil-on-water was deliberately excluded**, despite initially appearing
  to be a similar "borrowed time" factor. It reversed direction mid-crisis
  (fell sharply in March as tanker sailings collapsed, then rose in April
  and June as some traffic found longer alternate routes), and the
  available data has real gaps (no clean March split, no May figure at
  all). This failed the same reliability bar applied to every other
  figure in this project, so it was left out rather than estimated with
  false precision.

## Charts

- `01_gwp_vs_energy_dual_axis.png` — GWP and world energy supply, dual
  independent axes (Keen's convention)
- `01b_gwp_vs_energy_growth_over_time.png` — year-over-year % change for
  both series, over time (the "delta" panel)
- `02_growth_rate_relationship.png` — the actual elasticity: growth-rate
  scatter with fitted line, R²=0.77
- `03_gwp_impact_comparison.png` — institutional forecasts vs. this
  analysis, both disruption scenarios
- `04_disruption_component_buildup.png` — what's driving the total: the
  four-component stacked build-up, both scenarios

## Structure

- `data/raw/` — official World Bank and OECD downloads, the fuel-mix
  source, and the retired Maddison PPP series (archived)
- `01-elasticity-model/` — estimates and validates the elasticity
- `02-disruption-impact/` — applies it to the full 2026 disruption
  accounting
- `output/figures/` — all five charts
- `output/tables/` — full component results, both scenarios
- `data/processed/` — assembled datasets (local; regenerable, gitignored)

## Reproduce

Open the `.Rproj`, then:
```r
source(here::here("01-elasticity-model/01-elasticity-model.R"))
source(here::here("02-disruption-impact/02-disruption-impact.R"))
```
Requires `tidyverse` and `here`.

## Caveats

- Assumes the causal direction runs energy → GWP, not the reverse.
- The elasticity is fit on annual fluctuations across five decades
  (1971-2021); the modern-era-only subsample fits more tightly than the
  full window, an unresolved pattern also present in Keen's own reported
  statistics for the equivalent split.
- The 0.79 vs. Keen's reported 0.97 gap, for what should be identical data,
  is not resolved.
- The reserve-depletion rate (6.3 mb/d) and the Hormuz/Gulf figures
  (14.4/18.0 mb/d) both represent current, live-crisis conditions rather
  than a stable long-run average — they were chosen deliberately over more
  optimistic, now-outdated figures from earlier in the crisis (e.g., a
  "improved June" Hormuz recovery that has since reversed, and an EIA
  forecast of easing reserve pressure in Q3 that assumes a de-escalation
  that hadn't materialized as of this writing).
- This is an ongoing, actively evolving situation. Figures reflect the
  best available data as of late July 2026 and should be expected to
  change as the conflict develops.

## Citation

Keen, S., Ayres, R.U., and Standish, R. (2019), "A Note on the Role of
Energy in Production," *Ecological Economics*, 157, 40-46.

Keen, S. (2025), "The Role of Energy in Economics," Chapter 9 of *Money
and Macroeconomics from First Principles* (substack.com/@profstevekeen).

## Environment

R, tidyverse, `here()`.
