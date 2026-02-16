# ============================================================
# Simulated Ecological Example: Point-in-Polygon (Ray Casting)
# ============================================================

# Load required packages
library(imsideR)
library(ggplot2)
library(dplyr)

### SIMULATION

# Set seed for reproducibility
set.seed(1234)

# Define protected area polygons (as matrices)
protected_areas <- list(
  Reserve_A = matrix(c(2,2, 5,2, 5,5, 2,5), ncol = 2, byrow = TRUE),
  Reserve_B = matrix(c(6,6, 9,6, 9,9, 6,9), ncol = 2, byrow = TRUE)
)

# Simulate random species sightings
num_points <- 100
sightings <- data.frame(
  id = 1:num_points,
  x = runif(num_points, 0, 10),
  y = runif(num_points, 0, 10)
)

### METHOD: POINT-IN-POLYGON ANALYSIS

# Determine whether each sighting falls inside any protected area
sightings <- sightings %>%
  rowwise() %>%
  mutate(
    inside_protected_area = any(
      sapply(protected_areas, function(poly)
        point_in_polygon(c(x, y), poly)
      )
    )
  ) %>%
  ungroup()

### VISUALIZATION


# Prepare polygon data for plotting
polygon_df <- bind_rows(
  lapply(names(protected_areas), function(name) {
    poly <- protected_areas[[name]]
    df <- as.data.frame(poly)
    colnames(df) <- c("x", "y")
    df$reserve <- name
    rbind(df, df[1, ])  # Close polygon
  })
)

# Create the plot
ggplot() +
  geom_polygon(
    data = polygon_df,
    aes(x = x, y = y, group = reserve),
    fill = "lightgreen",
    color = "darkgreen",
    alpha = 0.4
  ) +
  geom_point(
    data = sightings,
    aes(x = x, y = y, color = inside_protected_area),
    size = 1.5
  ) +
  scale_color_manual(values = c("FALSE" = "green", "TRUE" = "blue")) +
  theme_minimal() +
  labs(
    title = "Simulated Species Sightings in Protected Areas",
    subtitle = "Blue = Inside Protected Area, Green = Outside",
    color = "Inside Protected Area"
  )
  
