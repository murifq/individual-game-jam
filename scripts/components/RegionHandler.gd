extends Area2D

# Reference to the Polygon2D node
@onready var polygon = $Polygon2D
# Signal to notify when the mouse enters or exits a region
signal region_hovered(region_name: String)
signal region_unhovered(region_name: String)
signal region_clicked(region_name: String)

# Change color to the region's color when mouse enters
func _on_mouse_entered(region_name: String) -> void:
	#var region: Region = Global.regions.get(region_name)  # Explicitly type as Region
	#print("Line 10 ", region.is_locked)
	var region = Global.regions[region_name]
	emit_signal("region_hovered", region_name)
	if region:
		if region.is_locked:
			# Highlight locked region with a red tint
			polygon.color = Color(1, 0.5, 0.5, 1)  # Red tint for locked regions
			print("locked: ", region_name)
		else:
			# Highlight unlocked region with its real color
			polygon.color = Color(0, 1, 0, 1)
			print("unlocked: ", region_name)

# Change color back to the region's default color when mouse exits
func _on_mouse_exited(region_name: String) -> void:
	var region = Global.regions[region_name]
	emit_signal("region_unhovered", region_name)
	if region:
		polygon.color = region.get_color()


func _on_ready(region_name: String) -> void:
	if not Global.is_initialized:
		Global.reset_game()
	print("Line 32")
	print("region_name: ", region_name)
	var region = Global.regions[region_name]
	if region:
		polygon.color = region.get_color()
		print(region.get_color())

func _on_input_event(viewport, event, shape_idx, region_name:String):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		print(str(region_name) + " Clicked")
		emit_signal("region_clicked", region_name)
