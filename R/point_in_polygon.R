library(ggplot2)

# Function to determine if a point is inside a polygon using Ray Casting
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

