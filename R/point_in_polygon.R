#' Point-in-Polygon Test Using Ray Casting
#'
#' Determines whether a given point lies inside a polygon using
#' the Ray Casting (even–odd rule) algorithm.
#'
#' @param point A numeric vector of length 2 representing the point
#'   coordinates \code{c(x, y)}.
#' @param polygon A numeric matrix or data frame with two columns
#'   representing polygon vertex coordinates. Each row corresponds
#'   to a vertex, ordered sequentially around the polygon.
#'
#' @details
#' The function implements the classic Ray Casting algorithm.
#' A horizontal ray is extended to the right of the test point,
#' and the number of intersections with polygon edges is counted.
#' If the number of intersections is odd, the point is inside;
#' if even, the point is outside.
#'
#' A small epsilon (\code{1e-10}) is added to the denominator to
#' avoid division-by-zero issues for horizontal edges.
#'
#' @return Logical value: \code{TRUE} if the point is inside the polygon,
#'   \code{FALSE} otherwise.
#'
#' @examples
#' polygon <- matrix(c(
#'   0, 0,
#'   4, 0,
#'   4, 4,
#'   0, 4
#' ), ncol = 2, byrow = TRUE)
#'
#' point_in_polygon(c(2, 2), polygon)  # TRUE
#' point_in_polygon(c(5, 5), polygon)  # FALSE
#'
#' @export
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
