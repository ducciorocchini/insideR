# Example polygon and point
polygon <- matrix ( c (1 ,1 , 5 ,1 , 4 ,4 , 2 ,5) , ncol =2 , byrow =
TRUE )
point <- c (3 , 3)
# Check if point is inside polygon
inside <- point _
in
_ polygon ( point , polygon )
# Output
print ( inside ) # Returns TRUE if inside , NA if not
