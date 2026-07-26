# =============================================================
# World Energy Supply and Gross World Product: An Elasticity Test
# Step 1: Estimate and validate the output elasticity of energy
#
# Question: how sensitive is world output (GWP) to changes in
# world primary energy supply? Mainstream production functions
# treat energy's contribution as roughly equal to its cost share
# of GDP (an output elasticity of ~0.03-0.05). An alternative
# framework -- an energy-based production function developed by
# Keen, Ayres & Standish (2019, Ecological Economics; extended in
# Keen's 2025 "The Role of Energy in Economics") -- argues this
# understates energy's true role, and reports an output elasticity
# close to 1, using Gross World Product against Primary Energy
# Supply.
#
# STANDARD DATA SOURCE (per 2026-07-26 decision -- PPP retired):
#   GWP    -- World Bank, GDP (constant 2015 US$), indicator
#             NY.GDP.MKTP.KD. Keen's own cited source (confirmed
#             via his footnotes). Official wide-format download
#             parsed directly below.
#   Energy -- OECD/DP_LIVE, WLD.PRYENRGSUPPLY.TOT.MLN_TOE.A
#             ("World, Primary energy supply, Total, Million toe,
#             Annual"). Keen's own cited energy source (confirmed
#             via his footnotes) -- both sides of this regression
#             match his exact data pairing, not an approximation.
#
# RETIRED: the Maddison Project PPP-adjusted GWP series was tested
# against an interim energy series (see data/raw/archive/) and did
# NOT tell a contradictory story (elasticity 0.94 vs 0.86 there --
# both far above the mainstream ~0.03-0.05 prediction). Retired per
# instruction regardless, not because the PPP data was disproven.
#
# CHART 1 CONVENTION (2026-07-26 review): built with dual
# independent y-axes, matching Keen's own presentation style
# (confirmed against his actual chart) rather than an indexed
# common-base chart. Each axis is auto-scaled to its own series --
# this is mechanically guaranteed to make two co-trending series
# look closely aligned regardless of their true relative growth
# rates (GWP grows faster than energy here; see the growth-rate
# elasticity in Chart 2 for the claim this project actually rests
# on, not the visual alignment in Chart 1 alone).
#
# Author: Erik Gandara
# =============================================================

# --- Setup ---
library(tidyverse)
library(here)

# --- Load GWP: official World Bank download, wide format ---
wb_raw <- read_csv(here("data/raw/worldbank_gdp_constant2015usd_raw.csv"), skip = 4)

gwp <- wb_raw |>
  filter(`Country Name` == "World") |>
  select(matches("^[0-9]{4}$")) |>
  pivot_longer(everything(), names_to = "Year", values_to = "GDP") |>
  mutate(Year = as.integer(Year)) |>
  drop_na()

# --- Load world primary energy supply: OECD/DP_LIVE, PRYENRGSUPPLY ---
energy_raw <- read_csv(here("data/raw/oecd_pryenrgsupply_world.csv"))
names(energy_raw) <- c("Year", "energy")
energy <- energy_raw |> drop_na()

# --- Join into one aligned annual table ---
m <- gwp |>
  inner_join(energy, by = "Year") |>
  arrange(Year) |>
  mutate(
    gwp_growth    = (GDP / lag(GDP) - 1) * 100,
    energy_growth = (energy / lag(energy) - 1) * 100
  )

g <- m |> drop_na(gwp_growth, energy_growth)

# --- Correlations (levels and growth rates) ---
levels_corr <- cor(m$GDP, m$energy)
growth_corr <- cor(g$gwp_growth, g$energy_growth)

# --- Output elasticity: regress %change in GWP on %change in energy ---
fit <- lm(gwp_growth ~ energy_growth, data = g)
slope     <- unname(coef(fit)["energy_growth"])
intercept <- unname(coef(fit)["(Intercept)"])
r2        <- summary(fit)$r.squared

cat(sprintf("Years: %d-%d (n=%d)\n", min(m$Year), max(m$Year), nrow(m)))
cat(sprintf("Levels correlation:      r = %.4f\n", levels_corr))
cat(sprintf("Growth-rate correlation: r = %.4f\n", growth_corr))
cat(sprintf("Output elasticity of energy: %.3f  (R2 = %.3f, intercept = %.2f)\n",
            slope, r2, intercept))

# --- Save the fitted elasticity for Step 2 to use ---
write_lines(as.character(round(slope, 3)), here("data/processed/elasticity.txt"))
write_csv(g, here("data/processed/growth_rates.csv"))
write_csv(m, here("data/processed/gwp_energy_combined.csv"))


# =============================================================
# CHART 1: Dual independent axes (see header note above)
# =============================================================
# Linear transform mapping energy's range onto GWP's range, so both
# series can be drawn on one continuous y scale; sec_axis() then
# relabels the left axis back to energy's native units. This is the
# standard, deliberate way ggplot2 supports dual axes -- it requires
# the transform to be explicit rather than automatic, precisely to
# avoid the kind of unexamined axis choice this project ran into
# earlier with an indexed version of this same chart.
b_scale <- (max(m$GDP) - min(m$GDP)) / (max(m$energy) - min(m$energy))
a_scale <- min(m$GDP) - b_scale * min(m$energy)

plot_data <- m |>
  transmute(
    Year,
    `GWP` = GDP,
    `Energy (World)` = a_scale + b_scale * energy
  ) |>
  pivot_longer(-Year, names_to = "series", values_to = "value")

ggplot(plot_data, aes(x = Year, y = value, color = series)) +
  geom_line(linewidth = 1.1) +
  scale_color_manual(values = c("Energy (World)" = "#d9822b", "GWP" = "#c0392b")) +
  scale_y_continuous(
    name = "GWP (constant 2015 US$)",
    sec.axis = sec_axis(~ (. - a_scale) / b_scale,
                         name = "Energy (Million tonnes oil equivalent)")
  ) +
  labs(
    title = "GWP and World Energy Supply",
    subtitle = "Each axis independently scaled to its own series -- see script header",
    x = NULL, color = NULL
  ) +
  theme_minimal() +
  theme(legend.position = c(0.15, 0.9))

ggsave(here("output/figures/01_gwp_vs_energy_dual_axis.png"), width = 9.5, height = 6, dpi = 300, bg = "white")


# =============================================================
# CHART 1b: Growth rates over time (the missing "delta" panel --
# matches the middle panel of Keen's own three-panel presentation:
# levels [Chart 1] / growth-rate time series [this chart] /
# growth-rate scatter [Chart 2]).
# =============================================================
delta_data <- g |>
  select(Year, energy_growth, gwp_growth) |>
  pivot_longer(-Year, names_to = "series", values_to = "value")

ggplot(delta_data, aes(x = Year, y = value, color = series)) +
  geom_line(linewidth = 1.1) +
  geom_hline(yintercept = 0, linewidth = 0.3, color = "grey60") +
  scale_color_manual(
    values = c(energy_growth = "#d9822b", gwp_growth = "#c0392b"),
    labels = c(energy_growth = "Energy (World)", gwp_growth = "GWP")
  ) +
  labs(
    title = "Changes in GWP and World Energy Supply",
    subtitle = "Year-over-year % change",
    x = NULL, y = "% change per year", color = NULL
  ) +
  theme_minimal()

ggsave(here("output/figures/01b_gwp_vs_energy_growth_over_time.png"),
       width = 9.5, height = 5.5, dpi = 300, bg = "white")


# =============================================================
# CHART 2: Growth-rate scatter with fitted elasticity line
# =============================================================
ggplot(g, aes(x = energy_growth, y = gwp_growth)) +
  geom_point(color = "#1f3a5f", size = 2.4, alpha = 0.75) +
  geom_smooth(method = "lm", se = FALSE, color = "#c0392b", linewidth = 1.1) +
  geom_hline(yintercept = 0, linewidth = 0.3, color = "grey60") +
  geom_vline(xintercept = 0, linewidth = 0.3, color = "grey60") +
  annotate("text", x = min(g$energy_growth), y = max(g$gwp_growth),
           label = sprintf("R\u00b2 = %.2f", r2), hjust = 0, fontface = "bold", size = 4.5) +
  labs(
    title = "World GWP Growth Tracks World Energy Growth Closely",
    subtitle = sprintf("Year-over-Year, %d-%d", min(g$Year), max(g$Year)),
    x = "Annual change in world primary energy supply (%)",
    y = "Annual change in Gross World Product (%)"
  ) +
  theme_minimal()

ggsave(here("output/figures/02_growth_rate_relationship.png"), width = 8, height = 6.5, dpi = 300, bg = "white")

cat("\nCharts saved to output/figures/\n")
cat(sprintf("Elasticity (%.3f) saved to data/processed/elasticity.txt for step 2.\n", slope))
