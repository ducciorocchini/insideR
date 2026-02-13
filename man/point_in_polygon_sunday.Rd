\name{point_in_polygon_sunday}
\alias{point_in_polygon_sunday}
\title{Point-in-Polygon Test Using Sunday's Winding Number Algorithm}
\description{
Determines whether a given point lies inside a polygon using Sunday's
implementation of the Winding Number algorithm.
}
\usage{
point_in_polygon_sunday(point, polygon)
}
\arguments{
  \item{point}{A numeric vector of length 2 representing the point
    coordinates \code{c(x, y)}.}
  \item{polygon}{A numeric matrix or data frame with two columns
    representing polygon vertex coordinates. Each row corresponds to a
    vertex, ordered sequentially around the polygon.}
}
\details{
This function implements the Winding Number algorithm as described by
Dan Sunday. The winding number counts how many times the polygon winds
around the test point. Upward edge crossings increment the winding
number, while downward crossings decrement it.

If the final winding number is non-zero, the point lies inside the
polygon; otherwise, it lies outside.

A small epsilon (\code{1e-10}) is added to the denominator to avoid
division-by-zero issues for horizontal edges.

Compared to the Ray Casting (even--odd rule) method, the winding number
approach is more robust for complex or self-intersecting polygons.
}
\value{
A logical value: \code{TRUE} if the point is inside the polygon,
\code{FALSE} otherwise.
}
\references{
Sunday, D. (2001). Winding Number Algorithm.
\url{http://geomalgorithms.com/a03-_inclusion.html}
}
\examples{
polygon <- matrix(c(
  0, 0,
  4, 0,
  4, 4,
  0, 4
), ncol = 2, byrow = TRUE)

point_in_polygon_sunday(c(2, 2), polygon)  # TRUE
point_in_polygon_sunday(c(5, 5), polygon)  # FALSE
}
\keyword{utilities}
\keyword{spatial}
