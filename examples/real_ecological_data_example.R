# Example workflow: combining point data from GBIF with polygon data
# from Protected Planet / WDPA

library(sf)
library(dplyr)
library(rgbif)
library(insideR)

# 1. Download species occurrence points from GBIF
# Example species: Quercus robur
gbif_data <- occ_search(
  scientificName = "Quercus robur",
  hasCoordinate = TRUE,
  limit = 500
)

points_df <- gbif_data$data %>%
  filter(!is.na(decimalLongitude), !is.na(decimalLatitude)) %>%
  select(species, decimalLongitude, decimalLatitude)

# Convert GBIF points to sf object
points_sf <- st_as_sf(
  points_df,
  coords = c("decimalLongitude", "decimalLatitude"),
  crs = 4326
)

# 2. Load protected-area polygons downloaded from Protected Planet / WDPA
# The user should first download a WDPA shapefile or GeoPackage manually
# from: https://www.protectedplanet.net/
wdpa <- st_read("WDPA_polygons.shp")

# Ensure both datasets use the same coordinate reference system
wdpa <- st_transform(wdpa, st_crs(points_sf))

# 3. Select one polygon as an example
polygon_sf <- wdpa[1, ]

# Extract polygon coordinates as a matrix for insideR
polygon_matrix <- st_coordinates(polygon_sf)[, c("X", "Y")]

# Extract point coordinates as a matrix
point_matrix <- st_coordinates(points_sf)

# 4. Apply insideR point-in-polygon test
points_df$inside_protected_area <- apply(
  point_matrix,
  1,
  function(p) point_in_polygon(point = p, polygon = polygon_matrix)
)

# 5. Summarize results
table(points_df$inside_protected_area)

# 6. Optional visualization
plot(st_geometry(wdpa[1, ]), col = "lightgreen", border = "darkgreen")
plot(st_geometry(points_sf), add = TRUE, pch = 16, cex = 0.6)
