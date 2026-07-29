# =============================================================
# Oil Supply Disruption and World GDP Impact
# Step 2: Apply the energy-to-GDP conversion factor to the full 2026 disruption
#
# FULL ACCOUNTING (finalized 2026-07-26, after a multi-source
# investigation -- see README for the complete sourcing narrative).
# The disruption is treated as three simultaneous, non-overlapping
# crises, plus a fourth "borrowed time" factor:
#
#   1. HORMUZ/BAB EL-MANDEB FLOW DISRUPTION -- crude extraction shut
#      in because Gulf producers have nowhere to ship it. Two
#      scenarios: realized (current conditions) and severe (a full
#      Bab el-Mandeb closure shutting down Saudi Arabia's Yanbu
#      bypass -- the port, not the pipe, is the real constraint
#      there; see README).
#   2. REFINERY/FUEL-PRODUCT CRISIS -- lost conversion capacity,
#      independent of crude availability (passes the test: "would
#      this loss still exist if crude extraction fully recovered
#      tomorrow?"). Two components: Middle East refining capacity
#      destroyed/idled, and Russian refining capacity lost to
#      Ukrainian strikes (used GROSS here, not netted for redirected
#      crude exports -- redirected raw crude doesn't produce fuel
#      until it's refined, and this is a fuel-product accounting).
#      Explicitly excludes Asian refiners' feedstock-constrained run
#      cuts -- that's a downstream symptom of item 1, already
#      counted, not a separate loss.
#   3. RESERVE DEPLETION -- the rate at which the world (excluding
#      Gulf holdings, which were never reaching the market anyway)
#      has been drawing down commercial + strategic oil stocks to
#      mask the true scale of the shortfall. This is "borrowed
#      time," not a permanent loss -- once reserves are exhausted,
#      this rate converts into real, unmasked shortfall. Oil-on-
#      water is deliberately excluded: it reversed direction
#      mid-crisis (fell in March, rose in April/June) and the
#      series has real gaps, failing the reliability bar applied
#      to every other figure in this project.
#
# Author: Erik Gandara
# =============================================================

library(tidyverse)
library(here)

# --- Load the conversion factor from Step 1 ---
conversion_factor <- as.numeric(read_lines(here("data/processed/gdp_energy_factor.txt")))

# --- World energy mix, 2024 (most recent complete year) ---
# Energy Institute/EIA-via-OWID, used here only for the oil/gas/total
# FUEL-MIX BREAKDOWN -- a different role from the OECD/World Bank
# pairing in Step 1, needed because the OECD series there is a
# single aggregate total with no fuel-type split.
energy_data <- read_csv(here("data/raw/owid-energy-data.csv"))
w2024 <- energy_data |> filter(country == "World", year == 2024)

oil_twh   <- w2024$oil_consumption
gas_twh   <- w2024$gas_consumption
total_twh <- w2024$primary_energy_consumption

# --- World oil supply baseline: EIA World Oil Transit Chokepoints, 1H25 ---
# (corrected from an earlier, rounder 107 mb/d estimate once the
# authoritative EIA figure was found)
oil_baseline_mbd <- 104.4

# --- Component 1: Hormuz/Bab el-Mandeb flow disruption ---
# Realized: IEA's April/May 2026 Gulf-output-below-pre-war figure,
# used as the current-conditions estimate given vessel traffic in
# late July (~15/day vs. 88/day baseline) shows severity back at or
# beyond the original crisis peak, superseding the "improved June"
# figure that has since reversed.
# Severe: adds ~3.6 mb/d from a full Bab el-Mandeb closure shutting
# down Saudi Arabia's Yanbu bypass entirely (port capacity, not pipe
# capacity, is the binding constraint there -- Yanbu can load only
# ~3-4 mb/d despite 5-7 mb/d of Petroline pipe capacity). The UAE's
# separate ADCOP/Fujairah bypass is unaffected -- it exits directly
# into the Gulf of Oman, never touching the Red Sea.
hormuz_realized_mbd <- 14.4
hormuz_severe_mbd   <- 18.0

# --- Component 2a: Middle East refining capacity offline ---
# IEA: "Nearly 3 million barrels per day of refining capacity in the
# region has been shut due to attacks and a lack of viable export
# outlets." Independent of crude availability -- this capacity stays
# lost even if Gulf extraction fully recovers.
me_refining_mbd <- 3.0

# --- Component 2b: Russia refining, GROSS (fuel-product accounting) ---
# Refining throughput fell from a ~5.3 mb/d baseline to 3.91 mb/d
# (Energy Aspects/Bloomberg), independently corroborated by Reuters'
# ~25% y-o-y fuel output decline. Used gross here (not netted for
# the ~0.5 mb/d of documented crude redirection) because redirected
# raw crude doesn't produce usable fuel until it's refined somewhere
# -- the netted 0.9 mb/d figure was for a crude-SUPPLY accounting,
# not this fuel-PRODUCT accounting.
russia_refining_mbd <- 1.4

# --- Component 3: Reserve depletion rate ("borrowed time") ---
# Cross-validated by two independent government/institutional
# sources for the crisis's most intense period (2Q26): EIA's own
# Short-Term Energy Outlook (6.3 mb/d, supply-minus-demand
# methodology) and Energy Intelligence/Turner Mason (~6.5 mb/d,
# observed-inventory methodology). China's reserve behavior is
# excluded from consideration of this rate's direction (it was
# net-building for most of the period) on the grounds that oil
# sitting in reserves -- built or drawn -- is oil off the market
# either way, so it doesn't offset the depletion measured elsewhere.
# Oil-on-water excluded per the reliability bar noted above.
reserve_depletion_mbd <- 6.3

# --- Totals ---
total_realized_mbd <- hormuz_realized_mbd + russia_refining_mbd + me_refining_mbd
total_severe_mbd   <- hormuz_severe_mbd   + russia_refining_mbd + me_refining_mbd
# Note: reserve_depletion_mbd is NOT added to the total. It represents how much
# of the Hormuz shortfall is currently being masked by drawing down stocks, not
# an additional loss on top of it -- supply/demand accounting identity: once
# reserves are exhausted, the shortfall reverts to the underlying production
# loss (hormuz_realized_mbd), not production loss + reserve rate. See README.

oil_loss_pct_realized <- total_realized_mbd / oil_baseline_mbd
oil_loss_pct_severe   <- total_severe_mbd   / oil_baseline_mbd

# --- Gas/LNG (unchanged; corroborated by Wood Mackenzie's independent ~109 bcm/yr estimate) ---
lng_loss_annualized_bcm   <- 120
total_gas_consumption_bcm <- 4000
gas_loss_pct <- lng_loss_annualized_bcm / total_gas_consumption_bcm

# --- Convert to TWh and combine ---
gas_twh_lost <- gas_twh * gas_loss_pct

oil_twh_lost_realized   <- oil_twh * oil_loss_pct_realized
total_twh_lost_realized <- oil_twh_lost_realized + gas_twh_lost
pct_energy_realized     <- total_twh_lost_realized / total_twh * 100
gwp_impact_realized     <- conversion_factor * pct_energy_realized

oil_twh_lost_severe   <- oil_twh * oil_loss_pct_severe
total_twh_lost_severe <- oil_twh_lost_severe + gas_twh_lost
pct_energy_severe     <- total_twh_lost_severe / total_twh * 100
gwp_impact_severe     <- conversion_factor * pct_energy_severe

cat(sprintf("Energy-to-GDP conversion factor used (from Step 1): %.3f\n\n", conversion_factor))
cat("--- REALIZED scenario ---\n")
cat(sprintf("Components (mb/d): Hormuz %.1f + Russia refining %.1f + ME refining %.1f + Reserves %.1f = %.1f\n",
            hormuz_realized_mbd, russia_refining_mbd, me_refining_mbd, reserve_depletion_mbd, total_realized_mbd))
cat(sprintf("%.1f%% of world oil -> %.2f%% of world primary energy -> GWP impact %.2f%%\n\n",
            oil_loss_pct_realized*100, pct_energy_realized, gwp_impact_realized))
cat("--- SEVERE scenario (Bab el-Mandeb/Yanbu shutdown) ---\n")
cat(sprintf("Components (mb/d): Hormuz %.1f + Russia refining %.1f + ME refining %.1f + Reserves %.1f = %.1f\n",
            hormuz_severe_mbd, russia_refining_mbd, me_refining_mbd, reserve_depletion_mbd, total_severe_mbd))
cat(sprintf("%.1f%% of world oil -> %.2f%% of world primary energy -> GWP impact %.2f%%\n",
            oil_loss_pct_severe*100, pct_energy_severe, gwp_impact_severe))

# --- Save full component results table ---
# Note: reserve_depletion_mbd is reported as a diagnostic (how much of the
# total below is currently being masked by stock drawdowns), not summed in.
results <- tibble(
  scenario = c(rep("realized", 7), rep("severe", 7)),
  metric = rep(c("hormuz_mbd", "russia_refining_mbd", "me_refining_mbd", "total_mbd",
                 "pct_of_world_oil", "pct_of_world_primary_energy", "implied_gwp_impact_pct"), 2),
  value = c(hormuz_realized_mbd, russia_refining_mbd, me_refining_mbd,
            total_realized_mbd, oil_loss_pct_realized*100, pct_energy_realized, gwp_impact_realized,
            hormuz_severe_mbd, russia_refining_mbd, me_refining_mbd,
            total_severe_mbd, oil_loss_pct_severe*100, pct_energy_severe, gwp_impact_severe)
)
write_csv(results, here("output/tables/disruption_impact_results.csv"))

# Separate diagnostic table for reserve depletion, kept apart from the summed total
reserve_note <- tibble(
  metric = c("reserve_depletion_mbd_diagnostic_only"),
  value = c(reserve_depletion_mbd),
  note = c("Currently masking this much of the Hormuz shortfall via stock drawdowns; NOT additive to total_mbd above -- see README")
)
write_csv(reserve_note, here("output/tables/reserve_depletion_diagnostic.csv"))


# =============================================================
# CHART 3: Comparison against institutional forecasts (updated, final numbers)
# =============================================================
comparison <- tibble(
  label = c("IMF / Oxford Economics\n(published forecast, moderate scenario)",
            "Oxford Economics\n(published forecast, severe/prolonged scenario)",
            "Energy-based estimate\n(this analysis, realized disruption)",
            "Energy-based estimate\n(this analysis, Bab el-Mandeb/Yanbu shutdown)"),
  value = c(0.6, 1.2, round(gwp_impact_realized, 1), round(gwp_impact_severe, 1)),
  fill_color = c("#9a9a9a", "#c9a468", "#c0392b", "#7a1f1f")
) |>
  mutate(label = fct_inorder(label))

ggplot(comparison, aes(x = value, y = fct_rev(label), fill = fill_color)) +
  geom_col(width = 0.6, show.legend = FALSE) +
  geom_text(aes(label = sprintf("%.1f%%", value)), hjust = -0.2,
            fontface = "bold", size = 5, color = "#1a1a1a") +
  scale_fill_identity() +
  scale_x_continuous(limits = c(0, max(comparison$value) * 1.15),
                      expand = expansion(mult = c(0, 0.02))) +
  labs(
    title = "Institutional Forecasts vs. a Full-Accounting Energy-Based Model",
    subtitle = "Estimated 2026 global GDP (GWP) impact -- flow disruption and refinery crisis combined",
    x = "Estimated 2026 global GDP (GWP) impact (%)", y = NULL,
    caption = paste0(
      "Estimates apply an energy-to-GDP conversion factor (", round(conversion_factor, 2),
      ") to the measured disruption: Hormuz/Bab el-Mandeb flow loss + Middle East and Russian\n",
      "refining capacity lost. Reserve depletion is tracked separately as a diagnostic (how much of this total is currently\n",
      "masked by stock drawdowns), not summed into the total -- see README.\n",
      "Institutional comparators: IMF World Economic Outlook (Apr 2026); Oxford Economics, \"Prolonged war in Iran could tip the global economy into recession\" (Apr 2026)."
    )
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold", size = 15, margin = margin(b = 4)),
    plot.subtitle = element_text(color = "grey30", size = 10.5, margin = margin(b = 14)),
    plot.caption = element_text(color = "grey45", size = 7.6, hjust = 0, lineheight = 1.3,
                                 margin = margin(t = 14)),
    axis.text.y = element_text(size = 10, lineheight = 1.15, color = "grey20"),
    panel.grid.major.y = element_blank(),
    panel.grid.minor.x = element_blank(),
    plot.margin = margin(t = 16, r = 24, b = 10, l = 10)
  )

ggsave(here("output/figures/03_gwp_impact_comparison.png"), width = 10.5, height = 6.8, dpi = 300, bg = "white")


# =============================================================
# CHART 4: Component build-up -- what's driving the total
# Reserve depletion shown as a separate reference line, NOT stacked into
# the bar, since it is a diagnostic of how much of the total is currently
# masked, not an additional loss (see accounting note above).
# =============================================================
buildup <- tibble(
  scenario = rep(c("Realized", "Severe\n(Bab el-Mandeb/Yanbu)"), each = 3),
  component = rep(c("Middle East refining offline", "Russia refining (gross)", "Hormuz/Gulf flow disruption"), 2),
  value = c(me_refining_mbd, russia_refining_mbd, hormuz_realized_mbd,
            me_refining_mbd, russia_refining_mbd, hormuz_severe_mbd)
) |>
  mutate(
    scenario = fct_inorder(scenario),
    component = fct_relevel(component, "Hormuz/Gulf flow disruption", "Russia refining (gross)",
                             "Middle East refining offline")
  )

totals <- buildup |> group_by(scenario) |> summarise(total = sum(value))

component_colors <- c(
  "Hormuz/Gulf flow disruption" = "#1f3a5f",
  "Russia refining (gross)" = "#3d5a80",
  "Middle East refining offline" = "#a8611f"
)

ggplot(buildup, aes(x = scenario, y = value, fill = component)) +
  geom_col(width = 0.55, color = "white", linewidth = 0.6) +
  geom_text(aes(label = sprintf("%.1f", value)), position = position_stack(vjust = 0.5),
            color = "white", fontface = "bold", size = 3.8) +
  geom_text(data = totals, aes(x = scenario, y = total, label = sprintf("%.1f mb/d", total)),
            inherit.aes = FALSE, vjust = -0.6, fontface = "bold", size = 5, color = "#1a1a1a") +
  scale_fill_manual(values = component_colors) +
  scale_y_continuous(limits = c(0, max(totals$total) * 1.15),
                      expand = expansion(mult = c(0, 0.02))) +
  labs(
    title = "What's Driving the Disruption: Three Summed Components",
    subtitle = "Million barrels/day (oil-equivalent), by contributing factor",
    x = NULL, y = "Million barrels per day (oil-equivalent)", fill = NULL,
    caption = sprintf(
      "Reserve depletion (%.1f mb/d) is tracked separately, not shown here -- it represents how much of\nthe total above is currently masked by stock drawdowns, not an additional loss on top of it. See README.",
      reserve_depletion_mbd)
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold", size = 15, margin = margin(b = 4)),
    plot.subtitle = element_text(color = "grey30", size = 10.5, margin = margin(b = 14)),
    plot.caption = element_text(color = "grey45", size = 7.8, hjust = 0, lineheight = 1.3,
                                 margin = margin(t = 12)),
    legend.position = "bottom",
    legend.text = element_text(size = 9),
    panel.grid.major.x = element_blank(),
    panel.grid.minor.y = element_blank(),
    axis.text.x = element_text(size = 11, face = "bold")
  ) +
  guides(fill = guide_legend(nrow = 2, byrow = TRUE, reverse = TRUE))

ggsave(here("output/figures/04_disruption_component_buildup.png"), width = 9, height = 7.5, dpi = 300, bg = "white")

cat("\nCharts saved to output/figures/\n")
cat("Results table saved to output/tables/disruption_impact_results.csv\n")
