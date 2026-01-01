# ============================================================
# Simulated Ecological Example: Point-in-Polygon (Ray Casting)
# ============================================================

# Load required libraries
library(ggplot2)
library(dplyr)

# Set seed for reproducibility
set.seed(1234)

# ------------------------------------------------------------
# Define protected area polygons
# ------------------------------------------------------------

protected_areas <- list(
  Reserve_A = matrix(c(2,2, 5,2, 5,5, 2,5), ncol = 2, byrow = TRUE),
  Reserve_B = matrix(c(6,6, 9,6, 9,9, 6,9), ncol = 2, byrow = TRUE)
)

# ------------------------------------------------------------
# Simulate species sightings
# ------------------------------------------------------------

num_points <- 100
sightings <- data.frame(
  id = 1:num_points,
  x = runif(num_points, 0, 10),
  y = runif(num_points, 0, 10)
)

# ------------------------------------------------------------
# Point-in-polygon function (Ray Casting)
# ------------------------------------------------------------

point_in_polygon <- function(point, polygon) {
  x <- point[1]
  y <- point[2]
  n <- nrow(polygon)
  inside <- FALSE
  
  j <- n
  for (i in 1:n) {
    xi <- polygon[i, 1]
    yi <- polygon[i, 2]
    xj <- polygon[j, 1]
    yj <- polygon[j, 2]
    
    intersect <- ((yi > y) != (yj > y)) &&
      (x < (xj - xi) * (y - yi) / (yj - yi + 1e-10) + xi)
    
    if (intersect)
      inside <- !inside
    
    j <- i
  }
  return(inside)
}

# ------------------------------------------------------------
# Apply point-in-polygon test
# ------------------------------------------------------------

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

# ------------------------------------------------------------
# Prepare polygon data for plotting
# ------------------------------------------------------------

polygon_df <- bind_rows(
  lapply(names(protected_areas), function(name) {
    poly <- protected_areas[[name]]
    df <- as.data.frame(poly)
    colnames(df) <- c("x", "y")
    df$reserve <- name
    rbind(df, df[1, ])  # Close polygon
  })
)

# ------------------------------------------------------------
# Plot results
# ------------------------------------------------------------

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
  scale_color_manual(values = c("FALSE" = "red", "TRUE" = "blue")) +
  theme_minimal() +
  labs(
    title = "Simulated Species Sightings in Protected Areas",
    subtitle = "Blue = Inside Protected Area, Red = Outside",
    color = "Inside Protected Area"
  )

# ------------------------------------------------------------
# Save plot
# ------------------------------------------------------------

ggsave(
  "species_sightings_protected_areas.png",
  width = 8,
  height = 6,
  dpi = 300
)
