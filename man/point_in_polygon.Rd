\name{point_in_polygon}
\alias{point_in_polygon}
\title{Point-in-Polygon Test Using Ray Casting}
\description{
Determines whether a given point lies inside a polygon using the Ray
Casting (even–odd rule) algorithm.
}
\usage{
point_in_polygon(point, polygon)
}
\arguments{
  \item{point}{A numeric vector of length 2 representing the point
    coordinates \code{c(x, y)}.}
  \item{polygon}{A numeric matrix or data frame with two columns
    representing polygon vertex coordinates. Each row corresponds to a
    vertex, ordered sequentially around the polygon.}
}
\details{
The function implements the classic Ray Casting algorithm. A
horizontal ray is extended to the right of the test point, and the
number of intersections with polygon edges is counted. If the number of
intersections is odd, the point is inside; if even, the point is
outside.

A small epsilon (\code{1e-10}) is added to the denominator to avoid
division-by-zero issues for horizontal edges.
}
\value{
A logical value: \code{TRUE} if the point is inside the polygon,
\code{FALSE} otherwise.
}
\examples{
polygon <- matrix(c(
  0, 0,
  4, 0,
  4, 4,
  0, 4
), ncol = 2, byrow = TRUE)

point_in_polygon(c(2, 2), polygon)  # TRUE
point_in_polygon(c(5, 5), polygon)  # FALSE
}
\keyword{utilities}
\keyword{spatial}
