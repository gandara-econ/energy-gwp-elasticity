# World Energy Supply and Gross World Product: An Elasticity Test

**Question:** How sensitive is world output (Gross World Product) to changes
in world primary energy supply — and what does that imply for the 2026
Hormuz/Bab el-Mandeb/Russian-refinery energy disruption?

## Approach
Mainstream production functions treat energy's contribution to GDP as
roughly equal to its cost share (~3-5%). A heterodox framework — Keen,
Ayres & Standish (2019, *Ecological Economics*; extended in Keen's 2025
*The Role of Energy in Economics*) — argues this understates energy's true
role, since energy has no substitute (labour without energy is a corpse;
capital without energy is a sculpture) and estimates the true output
elasticity of energy at close to 1, using a Leontief (fixed-proportions)
production function rather than Cobb-Douglas.

This project independently re-estimates that elasticity using Keen's own
cited data sources, then applies the result to the actual, ongoing 2026
energy disruption to see what each framework implies for global GDP.

## Data
- **GWP:** World Bank, GDP (constant 2015 US$), `NY.GDP.MKTP.KD` — Keen's
  own cited source.
- **Energy:** OECD/DP_LIVE, `WLD.PRYENRGSUPPLY.TOT.MLN_TOE.A` (World,
  Primary energy supply, Total, Million tonnes oil equivalent, Annual) —
  Keen's own cited source. Both sides of this regression now match his
  exact pairing, not an approximation.
- **Fuel mix breakdown (oil/gas/total, 2024):** Energy Institute
  Statistical Review + EIA, via Our World in Data — used only in Step 2 to
  split the 2026 disruption by fuel type, since the OECD series above is a
  single aggregate total.

**Retired:** the Maddison Project PPP-adjusted GWP series was tested
against an interim energy series and did *not* tell a contradictory story
(elasticity 0.94 vs. 0.86 — both far above the mainstream prediction).
Retired per instruction regardless of that result; kept in
`data/raw/archive/` for the record.

## Finding
**Output elasticity of energy: 0.79** (R²=0.77, 1971-2021, n=51) — using
Keen's exact data pairing. Far above the mainstream cost-share prediction
(~0.03-0.05); below Keen's own reported 0.97 for the same pairing, an
honest gap not yet resolved (possible causes: data revisions since his
April 2025 chapter, a two-year-longer window here, or an unspecified
detail of his exact regression setup).

Applying this elasticity to the measured 2026 disruption (Hormuz-driven
oil losses + Russian refining losses net of documented redirection + LNG
losses) implies a **2026 GWP impact of roughly 3.7%** — three to six times
larger than the IMF/OECD/Oxford Economics institutional range of 0.6–1.2%
for the same event.

## Chart convention note
`01_gwp_vs_energy_dual_axis.png` uses **dual independent y-axes** (each
series auto-scaled to its own range), matching Keen's own presentation
style — confirmed directly against his actual chart. This convention
visually flatters any two co-trending series into looking closely aligned,
regardless of true relative growth rates; the growth-rate elasticity in
`02_growth_rate_relationship.png` is the claim this project actually rests
on, not the visual alignment in Chart 1 alone.

## Structure
- `data/raw/` — official World Bank and OECD downloads, plus the retired
  Maddison PPP series
- `01-elasticity-model/` — estimates and validates the elasticity
- `02-disruption-impact/` — applies it to the 2026 disruption
- `output/figures/` — the three charts
- `output/tables/` — disruption impact results
- `data/processed/` — assembled datasets (local; regenerable, gitignored)

## Reproduce
Open the `.Rproj`, then:
```r
source(here::here("01-elasticity-model/01-elasticity-model.R"))
source(here::here("02-disruption-impact/02-disruption-impact.R"))
```

## Caveats
- Assumes the causal direction runs energy → GWP, not the reverse.
- The elasticity is fit on annual fluctuations across five decades
  (1971-2021); the modern-era-only subsample (1990+) fits more tightly
  than the full window, an unresolved pattern also present in Keen's own
  reported statistics for the equivalent split.
- The Russia refining figure nets out documented crude redirection; a
  portion of the true net loss remains genuinely uncertain.

## Environment
R, tidyverse, `here()`.
