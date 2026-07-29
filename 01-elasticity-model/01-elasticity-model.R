# =============================================================
# Oil Supply Disruption and World GDP Impact
# Step 1: Derive the energy-to-GDP conversion factor
#
# This step establishes how strongly world GDP has historically
# moved together with world energy supply, using the long-run
# relationship between the two as the basis for a conversion
# factor: how much world GDP moves for a given change in world
# energy supply. That factor is applied in Step 2 to the current
# oil supply disruption to estimate its impact on world GDP.
#
# DATA SOURCES:
#   GWP    -- World Bank, GDP (constant 2015 US$), indicator
#             NY.GDP.MKTP.KD. Official wide-format download,
#             parsed directly below.
#   Energy -- OECD/DP_LIVE, WLD.PRYENRGSUPPLY.TOT.MLN_TOE.A
#             ("World, Primary energy supply, Total, Million toe,
#             Annual").
#
#
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

# --- Energy-to-GDP conversion factor: regress %change in GWP on %change in energy ---
fit <- lm(gwp_growth ~ energy_growth, data = g)
slope     <- unname(coef(fit)["energy_growth"])
intercept <- unname(coef(fit)["(Intercept)"])
r2        <- summary(fit)$r.squared

cat(sprintf("Years: %d-%d (n=%d)\n", min(m$Year), max(m$Year), nrow(m)))
cat(sprintf("Levels correlation:      r = %.4f\n", levels_corr))
cat(sprintf("Growth-rate correlation: r = %.4f\n", growth_corr))
cat(sprintf("Energy-to-GDP conversion factor: %.3f  (R2 = %.3f, intercept = %.2f)\n",
            slope, r2, intercept))

# --- Save the conversion factor for Step 2 to use ---
write_lines(as.character(round(slope, 3)), here("data/processed/gdp_energy_factor.txt"))
write_csv(g, here("data/processed/growth_rates.csv"))
write_csv(m, here("data/processed/gwp_energy_combined.csv"))


# =============================================================
# CHART 1: GWP and world energy supply, year-over-year % change
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

ggsave(here("output/figures/01_gwp_vs_energy_growth_over_time.png"),
       width = 9.5, height = 5.5, dpi = 300, bg = "white")


# =============================================================
# CHART 2: Growth-rate scatter with fitted conversion-factor line
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
cat(sprintf("Conversion factor (%.3f) saved to data/processed/gdp_energy_factor.txt for step 2.\n", slope))
