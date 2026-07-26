# =============================================================
# World Energy Supply and Gross World Product: An Elasticity Test
# Step 2: Apply the estimated elasticity to the 2026 energy disruption
#
# Since February 2026, conflict in the Middle East has closed the
# Strait of Hormuz to most shipping (IEA: "the largest supply
# disruption in the history of the global oil market"), and
# renewed Houthi attacks have separately threatened the Bab el-
# Mandeb Strait. Simultaneously, sustained Ukrainian strikes on
# Russian refineries have cut Russian refining output to its
# lowest level since 2005. This step converts the combined,
# currently-measured disruption into a share of total world
# primary energy, and applies the elasticity from Step 1 to
# estimate an implied impact on Gross World Product -- set
# alongside published institutional forecasts (IMF, OECD, Oxford
# Economics) for comparison.
#
# All disruption figures below are sourced from IEA Oil Market
# Reports and Gas Market Reports (March-July 2026 editions) and
# contemporaneous reporting (Reuters, Bloomberg/Energy Aspects,
# Carnegie Endowment); see README for full citations.
#
# Author: Erik Gandara
# =============================================================

library(tidyverse)
library(here)

# --- Load the elasticity estimated in Step 1 ---
elasticity <- as.numeric(read_lines(here("data/processed/elasticity.txt")))

# --- World energy mix, 2024 (most recent complete year) ---
# Note: this uses the Energy Institute/EIA-via-OWID dataset for the
# oil/gas/total FUEL-MIX BREAKDOWN specifically -- a different use
# from the OECD/World Bank pairing in Step 1, needed because the
# OECD series used there is a single aggregate total, not broken
# out by fuel.
energy_data <- read_csv(here("data/raw/owid-energy-data.csv"))
w2024 <- energy_data |> filter(country == "World", year == 2024)

oil_twh   <- w2024$oil_consumption
gas_twh   <- w2024$gas_consumption
total_twh <- w2024$primary_energy_consumption

# --- Oil: IEA Oil Market Report, current conditions ---
# Global oil supply was ~107 mb/d pre-war; losses (vs. pre-war
# baseline) ranged from 9.4 mb/d (June, partial Hormuz reopening)
# to 12.8 mb/d (April trough). The July 20-21 Bab el-Mandeb
# blockade threatens the Saudi East-West Petroline bypass route
# that drove the June partial recovery, so the April figure is
# used as the better current-conditions estimate.
oil_baseline_mbd <- 107.0
hormuz_oil_loss_mbd <- 12.8

# --- Russia: refining loss net of documented redirection ---
# Refining throughput fell from a ~5.3 mb/d baseline to 3.91 mb/d
# (Energy Aspects/Bloomberg, July 2026) -- a gross loss of ~1.4
# mb/d. Reporting (Carnegie Endowment) documents Russia redirecting
# more crude to export rather than domestic refining (up to +0.5
# mb/d above the 2023-25 average in peak months), so 0.5 mb/d of
# the gross loss is treated as redirected rather than lost, leaving
# a net additional loss of 0.9 mb/d.
russia_refining_loss_mbd <- 1.4
russia_documented_redirection_mbd <- 0.5
russia_net_additional_mbd <- russia_refining_loss_mbd - russia_documented_redirection_mbd

total_oil_loss_mbd <- hormuz_oil_loss_mbd + russia_net_additional_mbd
oil_loss_pct <- total_oil_loss_mbd / oil_baseline_mbd

# --- Gas/LNG: IEA Gas Market Report ---
# ~10 bcm/month LNG supply loss while Hormuz is effectively closed
# (~120 bcm/yr run-rate) against total world gas consumption of
# ~4,000 bcm/yr. LNG trade is a minority share of total gas
# consumption (most gas moves by pipeline), so this loss is
# expressed against total gas, not LNG trade alone.
lng_loss_annualized_bcm <- 120
total_gas_consumption_bcm <- 4000
gas_loss_pct <- lng_loss_annualized_bcm / total_gas_consumption_bcm

# --- Convert to TWh and combine ---
oil_twh_lost <- oil_twh * oil_loss_pct
gas_twh_lost <- gas_twh * gas_loss_pct
total_twh_lost <- oil_twh_lost + gas_twh_lost
pct_world_energy_lost <- total_twh_lost / total_twh * 100

# --- Apply elasticity ---
gwp_impact_pct <- elasticity * pct_world_energy_lost

cat(sprintf("Elasticity used (from Step 1): %.3f\n", elasticity))
cat(sprintf("Total oil loss: %.1f mb/d (%.1f%% of world oil)\n",
            total_oil_loss_mbd, oil_loss_pct * 100))
cat(sprintf("Gas/LNG loss: %.1f%% of world gas\n", gas_loss_pct * 100))
cat(sprintf("Combined: %.0f TWh = %.1f%% of world primary energy\n",
            total_twh_lost, pct_world_energy_lost))
cat(sprintf("Implied GWP impact: %.1f%%\n", gwp_impact_pct))

# --- Save results table ---
results <- tibble(
  metric = c("oil_loss_mbd", "oil_loss_pct_of_world_oil", "gas_loss_pct_of_world_gas",
             "total_energy_lost_twh", "pct_of_world_primary_energy",
             "elasticity", "implied_gwp_impact_pct"),
  value = c(total_oil_loss_mbd, oil_loss_pct * 100, gas_loss_pct * 100,
            total_twh_lost, pct_world_energy_lost, elasticity, gwp_impact_pct)
)
write_csv(results, here("output/tables/disruption_impact_results.csv"))


# =============================================================
# CHART 3: Comparison against institutional forecasts
# =============================================================
comparison <- tibble(
  label = c("IMF / Oxford Economics\n(moderate scenario)",
            "Oxford Economics\n(severe / prolonged scenario)",
            "Energy-based estimate\n(this analysis)"),
  value = c(0.6, 1.2, round(gwp_impact_pct, 1)),
  fill_color = c("#8a8a8a", "#b0855a", "#c0392b")
) |>
  mutate(label = fct_inorder(label))

ggplot(comparison, aes(x = value, y = fct_rev(label), fill = fill_color)) +
  geom_col(width = 0.55, show.legend = FALSE) +
  geom_text(aes(label = sprintf("%.1f%%", value)), hjust = -0.15,
            fontface = "bold", size = 4.2) +
  scale_fill_identity() +
  scale_x_continuous(limits = c(0, max(comparison$value) + 1)) +
  labs(
    title = "Two Frameworks Imply Very Different 2026 Impacts\nfrom the Same Measured Energy Disruption",
    x = "Estimated 2026 global GDP (GWP) impact (%)", y = NULL
  ) +
  theme_minimal() +
  theme(panel.grid.major.y = element_blank())

ggsave(here("output/figures/03_gwp_impact_comparison.png"), width = 8.5, height = 5.8, dpi = 300)

cat("\nChart saved to output/figures/03_gwp_impact_comparison.png\n")
cat("Results table saved to output/tables/disruption_impact_results.csv\n")
