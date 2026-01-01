# Simulated Ecological Example: Species Sightings and Protected Areas

Spatial analysis plays a fundamental role in ecology and conservation science. A common task is determining whether field observations—such as animal sightings or ecological samples—fall within designated conservation units. To illustrate this process in a reproducible and accessible way, I simulated spatial data and performed a point-in-polygon analysis using R.

### Simulation

The process begins by simulating a set of protected areas and species sightings. As an example, a tree species in a mixed forest is considered. Two simple square polygons represent protected areas, and 100 species sightings are randomly distributed across a 10 × 10 geographic grid. This controlled setup provides a sandbox for testing and teaching spatial workflows.

```r
# Load required libraries
library(sf)
library(dplyr)
library(ggplot2)

# Set seed for reproducibility
set.seed(1234)

# Simulate protected area polygons
protected_areas <- st_sf(
  reserve_name = c("Reserve A", "Reserve B"),
  geometry = st_sfc(
    st_polygon(list(rbind(c(2,2), c(5,2), c(5,5), c(2,5), c(2,2)))),  # Reserve A
    st_polygon(list(rbind(c(6,6), c(9,6), c(9,9), c(6,9), c(6,6))))   # Reserve B
  ),
  crs = 4326
)

# Simulate random species sightings
num_points <- 100
sightings_points <- data.frame(
  id = 1:num_points,
  lon = runif(num_points, 0, 10),
  lat = runif(num_points, 0, 10)
)

# Convert to sf point object
sightings <- st_as_sf(
  sightings_points,
  coords = c("lon", "lat"),
  crs = 4326
)
```

### Method: Point-in-Polygon Analysis

A spatial join is used to determine whether each point falls inside a protected area. The `st_join()` function from the **sf** package automatically associates each sighting with a polygon, when applicable.

```r
# Spatial join: assign reserve to each sighting
sightings_in_reserves <- st_join(sightings, protected_areas)

# Label each point as inside or outside
sightings_in_reserves <- sightings_in_reserves %>%
  mutate(inside_protected_area = !is.na(reserve_name))
```

This step mirrors real-world workflows used in ecological studies to overlay biodiversity observations with conservation boundaries and quantify coverage.

### Visualization of Results

The spatial distribution of species sightings relative to protected areas is visualized using **ggplot2**. Protected areas are shown as semi-transparent polygons, while species sightings are colored according to whether they fall inside or outside a protected area.

```r
# Create the plot
ggplot() +
  geom_sf(
    data = protected_areas,
    fill = "lightgreen",
    color = "darkgreen",
    alpha = 0.4
  ) +
  geom_sf(
    data = sightings_in_reserves,
    aes(color = inside_protected_area),
    size = 1.5
  ) +
  scale_color_manual(
    values = c("FALSE" = "red", "TRUE" = "blue")
  ) +
  theme_minimal() +
  labs(
    title = "Simulated Species Sightings in Protected Areas",
    subtitle = "Blue = Inside Protected Area, Red = Outside",
    color = "Inside Protected Area"
  )
```

The resulting figure can be saved to disk for use in reports, manuscripts, or teaching materials.

```r
# Save the plot as a PNG
ggsave(
  "species_sightings_protected_areas.png",
  width = 8,
  height = 6,
  dpi = 300
)
```

* aggiungere una **sessionInfo()**
* convertirlo direttamente in **R Markdown / vignette CRAN-style**
