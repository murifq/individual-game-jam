extends Area2D

# Reference to the Polygon2D node
@onready var polygon = $Polygon2D

# Region name (passed as an extra call argument)

# Original color of the polygon
var original_color = Color(0.533037, 0.533037, 0.533037, 1)


# Change color to more white when mouse enters
func _on_mouse_entered(region_name: String) -> void:
	print(region_name)
	polygon.color = Color(0.8, 0.8, 0.8, 1) # Lighter color

# Change color back to original when mouse exits
func _on_mouse_exited(region_name: String) -> void:
	polygon.color = original_color
