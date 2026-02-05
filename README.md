# insideR
R package for point in polygon algorithms

<p align="center">
  <img 
    src="https://github.com/user-attachments/assets/9904ce4b-5736-45cf-85e5-527f6eb1a5c6"
    alt="cellulaR"
    width="300"
  />
</p>

**insideR** is a lightweight R package that provides two classic *point-in-polygon* (PiP) tests:

- **Ray casting / even–odd rule** (`point_in_polygon()`) — counts edge crossings of a ray. :contentReference[oaicite:0]{index=0}  
- **Winding number** (`point_in_polygon_sunday()`) — uses orientation / crossings to compute a winding number. :contentReference[oaicite:1]{index=1}

The goal is to keep the functions simple, transparent, and easy to reuse in teaching, GIS scripting, and small geometry workflows.

---

## Installation

Install the development version from GitHub:

```r
# install.packages("remotes")
remotes::install_github("ducciorocchini/insideR")
````

---

## Input format

Both functions expect:

* `point`: numeric vector of length 2: `c(x, y)`
* `polygon`: a 2-column object (`matrix` or `data.frame`) with vertices in order: `cbind(x, y)`

**Important**

* The polygon should be *closed* conceptually (first vertex does **not** need to be repeated at the end).
* Vertex order can be clockwise or counterclockwise.
* Points exactly on edges/vertices can be tricky in any PiP implementation; see **Edge cases** below.

---

## Quick example

```r
library(insideR)

# A square polygon
poly <- rbind(
  c(0, 0),
  c(1, 0),
  c(1, 1),
  c(0, 1)
)

p_in  <- c(0.2, 0.3)
p_out <- c(1.2, 0.3)

point_in_polygon(p_in,  poly)
point_in_polygon(p_out, poly)

point_in_polygon_sunday(p_in,  poly)
point_in_polygon_sunday(p_out, poly)
```

---

## Visual check (optional)

```r
library(ggplot2)
library(insideR)

poly_df <- as.data.frame(poly)
names(poly_df) <- c("x", "y")

pts <- data.frame(
  x = c(0.2, 1.2),
  y = c(0.3, 0.3)
)

pts$inside_ray   <- apply(pts, 1, \(r) point_in_polygon(c(r["x"], r["y"]), poly))
pts$inside_wind  <- apply(pts, 1, \(r) point_in_polygon_sunday(c(r["x"], r["y"]), poly))

ggplot() +
  geom_polygon(data = poly_df, aes(x, y), fill = NA) +
  geom_point(data = pts, aes(x, y, shape = inside_ray), size = 3) +
  coord_equal()
```

---

## Functions

### `point_in_polygon(point, polygon)`

Ray casting / even–odd rule: shoot a ray from the point and toggle “inside” each time an edge is crossed. ([Wikipedia][1])

### `point_in_polygon_sunday(point, polygon)`

Winding number method: accumulate crossings to compute a winding number; non-zero means inside. ([Wikipedia][1])

---

## Edge cases / numerical stability

These implementations add a tiny epsilon (`1e-10`) in denominators to reduce division-by-zero issues when an edge is horizontal.

If you need a *strict* and explicitly defined policy for:

* “point on boundary”
* self-intersecting polygons
* polygons with holes

…consider using robust geometry engines (e.g., `sf`/GEOS) for production workflows.

---

## References

* “Point in polygon” overview (ray casting & winding number). ([Wikipedia][1])
* W. R. Franklin’s PNPOLY note (classic crossing-number test). ([wrfranklin.org][2])
* Winding number discussion / literature example. ([ScienceDirect][3])

---

## License

Choose a license in `DESCRIPTION` / `LICENSE` (e.g., MIT or GPL-3) and update this section accordingly.

---

## Author

Duccio Rocchini
