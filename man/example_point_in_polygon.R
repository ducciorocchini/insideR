# Example polygon and point
polygon <- matrix(c(1,1, 5,1, 4,4, 2,5), ncol=2, byrow=TRUE)
point <- c(3, 3)

# Check if point is inside polygon
inside <- point_in_polygon(point, polygon)

# Prepare data for ggplot
polygon_df <- as.data.frame(polygon)
colnames(polygon_df) <- c("x", "y")
polygon_df <- rbind(polygon_df, polygon_df[1, ])  # Close the polygon

point_df <- data.frame(x = point[1], y = point[2], 
                       label = ifelse(inside, "Inside", "Outside"))

# Plot
ggplot() +
  geom_polygon(data = polygon_df, aes(x = x, y = y), 
               fill = "lightblue", color = "black", alpha = 0.5) +
  geom_point(data = point_df, aes(x = x, y = y, color = label), size = 4) +
  scale_color_manual(values = c("Inside" = "green", "Outside" = "red")) +
  labs(title = "Point in Polygon Test",
       subtitle = paste("Point is", ifelse(inside, "INSIDE", "OUTSIDE"), "the polygon"),
       x = "X", y = "Y") +
  theme_minimal()
