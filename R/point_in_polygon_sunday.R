library(sp)

# Function to determine if a point is inside a polygon using Sunday's Winding Number Algorithm
point_in_polygon_sunday <- function(point, polygon) {
  x <- point[1]
  y <- point[2]
  n <- nrow(polygon)
  winding_number <- 0  # Initialize the winding number
  
  for (i in 1:n) {
    xi <- polygon[i, 1]
    yi <- polygon[i, 2]
    xj <- polygon[(i %% n) + 1, 1]  # Next vertex (wrap around)
    yj <- polygon[(i %% n) + 1, 2]
    
    # Check if the point is between the y-coordinates of the edge
    if ((yi <= y & y < yj) || (yj <= y & y < yi)) {
      # Calculate the x-coordinate of the intersection of the edge with the horizontal ray
      x_intersect <- xi + (y - yi) * (xj - xi) / (yj - yi + 1e-10)
      
      # If the ray crosses the edge and is to the right of the point
      if (x < x_intersect) {
        if (yj > yi) {
          winding_number <- winding_number + 1  # Upward crossing
        } else {
          winding_number <- winding_number - 1  # Downward crossing
        }
      }
    }
  }
  
  # The point is inside if the winding number is not zero
  return(winding_number != 0)
}

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
