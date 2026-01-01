library(sp)

# Define the polygon and point using sp
polygon_coords <- cbind(c(1, 5, 4, 2, 1), c(1, 1, 4, 5, 1))  # Polygon coordinates
polygon <- Polygon(polygon_coords)  # Create the Polygon object
p <- SpatialPolygons(list(Polygons(list(polygon), "poly1")))  # Create the SpatialPolygons object

# Define the point to test
point <- SpatialPoints(cbind(3, 3))  # Test point inside the polygon

# Use Sunday's Algorithm to check if the point is inside the polygon
inside_sunday <- point_in_polygon_sunday(c(3, 3), polygon_coords)

# Print the result
print(inside_sunday)  # TRUE if inside, FALSE if outside

# Test with another point outside the polygon
outside_sunday <- point_in_polygon_sunday(c(6, 3), polygon_coords)

# Print the result
print(outside_sunday)  # Should print FALSE
