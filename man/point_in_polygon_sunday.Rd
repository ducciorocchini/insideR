#' Point-in-Polygon Test Using Sunday's Winding Number Algorithm
#'
#' Determines whether a given point lies inside a polygon using
#' Sunday's implementation of the Winding Number algorithm.
#'
#' @param point A numeric vector of length 2 representing the point
#'   coordinates \code{c(x, y)}.
#' @param polygon A numeric matrix or data frame with two columns
#'   representing polygon vertex coordinates. Each row corresponds
#'   to a vertex, ordered sequentially around the polygon.
#'
#' @details
#' This function implements the Winding Number algorithm as described
#' by Dan Sunday. The winding number counts how many times the polygon
#' winds around the test point. Upward edge crossings increment the
#' winding number, while downward crossings decrement it.
#'
#' If the final winding number is non-zero, the point lies inside the
#' polygon; otherwise, it lies outside.
#'
#' A small epsilon (\code{1e-10}) is added to the denominator to avoid
#' division-by-zero issues for horizontal edges.
#'
#' Compared to the Ray Casting (even–odd rule) method, the winding
#' number approach is more robust for complex or self-intersecting
#' polygons.
#'
#' @return Logical value: \code{TRUE} if the point is inside the polygon,
#'   \code{FALSE} otherwise.
#'
#' @references
#' Sunday, D. (2001). Winding Number Algorithm.
#' \url{http://geomalgorithms.com/a03-_inclusion.html}
#'
#' @examples
#' polygon <- matrix(c(
#'   0, 0,
#'   4, 0,
#'   4, 4,
#'   0, 4
#' ), ncol = 2, byrow = TRUE)
#'
#' point_in_polygon_sunday(c(2, 2), polygon)  # TRUE
#' point_in_polygon_sunday(c(5, 5), polygon)  # FALSE
#'
#' @export
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
