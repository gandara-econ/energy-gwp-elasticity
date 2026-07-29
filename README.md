# Oil Supply Disruption and World GDP Impact

**Question:** What is the impact of the current oil supply disruption
(Hormuz closure, Bab el-Mandeb threat, and the Russian/Middle East
refinery crisis) on world GDP?

## Approach

This project derives a conversion factor from the long-run historical
relationship between world energy supply and world GDP, then applies
that factor to a full accounting of the current oil supply disruption to
estimate its impact on world GDP.

## Data sources

- **GWP:** World Bank, GDP (constant 2015 US$), indicator `NY.GDP.MKTP.KD`.
  Official wide-format download, parsed directly (no hand-transcription).
- **Energy:** OECD/DP_LIVE, `WLD.PRYENRGSUPPLY.TOT.MLN_TOE.A` ("World,
  Primary energy supply, Total, Million tonnes oil equivalent, Annual").
  Covers 1971-2021.
- **World fuel-mix breakdown (oil/gas/total, 2024):** Energy Institute
  Statistical Review + EIA, via Our World in Data — used only in Step 2 to
  split the disruption by fuel type.
- **World oil supply baseline:** EIA World Oil Transit Chokepoints report,
  1H 2025 edition (104.4 mb/d).

## Finding 1: The energy-to-GDP conversion factor

**Conversion factor: 0.79** (R²=0.77, 1971-2021, n=51) — meaning a 1%
change in world energy supply has historically corresponded to
approximately a 0.79% change in world GDP.

This relationship is far tighter than a simple cost-share view of energy
would suggest.

**Chart 1:** GWP and world energy supply, both expressed as year-over-year
% change, on one shared axis — no index year, no rescaling, since both
series are already in the same unit. This is the growth-rate relationship
the conversion factor above is derived from.

## Finding 2: The 2026 disruption, fully accounted

The disruption is treated as three simultaneous, non-overlapping crises,
plus a fourth "borrowed time" factor:

| Component | Realized | Severe (Bab el-Mandeb/Yanbu shutdown) | Basis |
|---|---|---|---|
| Hormuz/Gulf flow disruption | 14.4 mb/d | 18.0 mb/d | IEA Oil Market Reports; current vessel-traffic collapse (~15/day vs. 88/day baseline) shows severity back at or beyond the original March peak |
| Russia refining (gross) | 1.4 mb/d | 1.4 mb/d | Energy Aspects/Bloomberg refining-throughput data, independently corroborated by Reuters' ~25% y-o-y fuel-output decline |
| Middle East refining capacity offline | 3.0 mb/d | 3.0 mb/d | IEA: "~3 mb/d of refining capacity in the region has already shut due to attacks and a lack of viable export outlets" |
| Reserve depletion rate | 6.3 mb/d | 6.3 mb/d | Cross-validated: EIA's own Short-Term Energy Outlook (6.3 mb/d, 2Q26 actual) and Energy Intelligence/Turner Mason (~6.5 mb/d) |
| **Total** | **25.1 mb/d** | **28.7 mb/d** | |
| % of world oil | 24.0% | 27.5% | |
| % of world primary energy | 8.22% | 9.30% | |
| **Implied GWP impact** | **6.52%** | **7.38%** | |

For comparison, the mainstream institutional range for this same event is
**0.6% (IMF/Oxford Economics moderate) to 1.2% (Oxford Economics
severe/prolonged)**.

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
  pass. Asian refiners' feedstock-constrained run cuts were deliberately
  **excluded** — that's a downstream symptom of the Hormuz crude shortage
  already counted above.
- **Reserve depletion** is "borrowed time," not a permanent loss: the rate
  at which the world (excluding Gulf holdings, which were never reaching
  the market anyway) has been spending down commercial and strategic oil
  stocks to mask the true scale of the shortfall. Once reserves are
  exhausted, this rate converts into real, unmasked shortfall on top of
  everything else. China's reserve behavior (it was net-building reserves
  for most of this period, only drawing modestly from May onward) is
  excluded from this rate's calculation, on the reasoning that oil sitting
  in reserves — built or drawn — is oil off the market either way.
- **Oil-on-water was deliberately excluded**, despite initially appearing
  to be a similar "borrowed time" factor. It reversed direction mid-crisis
  and the available data has real gaps, failing the reliability bar
  applied to every other figure in this project.

## Charts

- `01_gwp_vs_energy_growth_over_time.png` — GWP and world energy supply,
  year-over-year % change, one shared axis
- `02_growth_rate_relationship.png` — the growth-rate relationship behind
  the conversion factor, R²=0.77
- `03_gwp_impact_comparison.png` — institutional forecasts vs. this
  analysis, both disruption scenarios
- `04_disruption_component_buildup.png` — what's driving the total: the
  four-component stacked build-up, both scenarios

## Structure

- `data/raw/` — official World Bank and OECD downloads, and the fuel-mix
  source
- `01-elasticity-model/` — derives the conversion factor
- `02-disruption-impact/` — applies it to the full 2026 disruption
  accounting
- `output/figures/` — all four charts
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
- The conversion factor is fit on annual fluctuations across five decades
  (1971-2021); a modern-era-only subsample fits more tightly than the
  full window.
- The reserve-depletion rate (6.3 mb/d) and the Hormuz/Gulf figures
  (14.4/18.0 mb/d) both represent current, live-crisis conditions rather
  than a stable long-run average — they were chosen deliberately over more
  optimistic, now-outdated figures from earlier in the crisis.
- This is an ongoing, actively evolving situation. Figures reflect the
  best available data as of late July 2026 and should be expected to
  change as the conflict develops.

## Environment

R, tidyverse, `here()`.
