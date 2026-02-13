library(sp)

# Define the polygon and point using sp
polygon_coords <- cbind(c(2, 3, 6, 6, 5), c(2, 2, 1, 6, 6))  # Polygon coordinates
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

# Prepare data for ggplot
polygon_df <- as.data.frame(polygon_coords)
colnames(polygon_df) <- c("x", "y")
polygon_df <- rbind(polygon_df, polygon_df[1, ])  # Close the polygon

point_df <- data.frame(x = 3, y = 3, 
                       label = ifelse(inside_sunday, "Inside", "Outside"))

# Plot using ggplot2
ggplot() +
  geom_polygon(data = polygon_df, aes(x = x, y = y), 
               fill = "lightblue", color = "black", alpha = 0.5) +
  geom_point(data = point_df, aes(x = x, y = y, color = label), size = 4) +
  scale_color_manual(values = c("Inside" = "green", "Outside" = "red")) +
  labs(title = "Point in Polygon Test",
       subtitle = paste("Point is", ifelse(inside_sunday, "INSIDE", "OUTSIDE"), "the polygon"),
       x = "X", y = "Y") +
  theme_minimal()
