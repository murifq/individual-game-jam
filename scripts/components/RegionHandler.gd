extends Area2D

# Reference to the Polygon2D node
@onready var polygon = $Polygon2D

# Change color to the region's color when mouse enters
func _on_mouse_entered(region_name: String) -> void:
	#var region: Region = Global.regions.get(region_name)  # Explicitly type as Region
	#print("Line 10 ", region.is_locked)
	var region = Global.regions[region_name]
	print(region)
	print(region_name)
	if region:
		if region.is_locked:
			# Highlight locked region with a red tint
			polygon.color = Color(1, 0.5, 0.5, 1)  # Red tint for locked regions
			print("locked: ", region_name)
		else:
			# Highlight unlocked region with its real color
			polygon.color = region.unlocked_color
			print("unlocked: ", region_name)

# Change color back to the region's default color when mouse exits
func _on_mouse_exited(region_name: String) -> void:
	var region: Region = Global.regions.get(region_name)  # Explicitly type as Region
	if region:
		polygon.color = region.get_color()
