extends ColorRect

@onready var region_label = $HBoxContainer/ColorRect/CenterContainer/VBoxContainer/RegionLabel
@onready var stats_label = $HBoxContainer/ColorRect/CenterContainer/VBoxContainer/StatsLabel
@onready var button = $HBoxContainer/ColorRect/CenterContainer/VBoxContainer/Button
@onready var region_map = $HBoxContainer/VBoxContainer/CanvasLayer/AngkotMap
@onready var achievement_button: Button = $VBoxContainer/HBoxContainer2/AchievementButton

# Track the currently hovered and clicked regions
var hovered_region: String = ""
var clicked_region: String = ""

func _ready() -> void:
	# Initialize the label with the current selected region
	if not Global.is_initialized:
		Global.reset_game()
	_update_region_info(Global.selected_region)

	# Connect to the signal from Global
	Global.selected_region_changed.connect(self._on_selected_region_changed)

	# Connect the button
	button.pressed.connect(self._on_button_pressed)
	
	 # Connect the AchievementButton
	achievement_button.pressed.connect(self._on_achievement_button_pressed)

	# Connect signals for each region in the map
	for region_node in region_map.get_children():
		for area2d in region_node.get_children():
			if area2d.has_method("connect"):
				area2d.region_hovered.connect(self._on_region_hovered)
				area2d.region_unhovered.connect(self._on_region_unhovered)
				area2d.region_clicked.connect(self._on_region_clicked)

# Update the region info when the signal is emitted
func _on_selected_region_changed(new_region: String) -> void:
	_update_region_info(new_region)

# Update the region info (name, stats, and button functionality)
func _update_region_info(region_name: String) -> void:
	var region = Global.regions.get(region_name)
	if region:
		region_label.text = "Wilayah: " + region.short_name
		stats_label.text = "Kepadatan penduduk: %.2f\nAktivitas ekonomi: %.2f\nBiaya: %d" % [
			region.population_density,
			region.economic_activity,
			region.price
		]
		if region.is_locked:
			button.text = "Beli Wilayah"
		else:
			button.text = "Atur Wilayah"
		button.visible = true
	else:
		region_label.text = "Kamu belum memilih wilayah!"
		stats_label.text = ""
		button.visible = false

# Handle the button press
func _on_button_pressed() -> void:
	if clicked_region == "":
		return  # No region is selected

	var region = Global.regions.get(clicked_region)
	if region:
		if region.is_locked:
			# Handle buying the region
			if Global.money >= region.price:
				Global.money -= region.price
				region.is_locked = false
				_update_region_info(clicked_region)
				print("%s has been unlocked!" % region.short_name)
			else:
				print("Not enough money to unlock %s!" % region.short_name)
		else:
			# Handle managing the region
			Global.selected_region = clicked_region
			get_tree().change_scene_to_file("res://scenes/MainUI/MainUI.tscn")

# Handle mouse entered event for a region
func _on_region_hovered(region_name: String) -> void:
	# Only update if no region is clicked
	if clicked_region == "":
		hovered_region = region_name
		_update_region_info(region_name)

# Handle mouse exited event for a region
func _on_region_unhovered(region_name: String) -> void:
	# Only reset if the exited region is the currently hovered region and no region is clicked
	if hovered_region == region_name and clicked_region == "":
		hovered_region = ""
		_update_region_info(Global.selected_region)

# Handle mouse click event for a region
func _on_region_clicked(region_name: String) -> void:
	clicked_region = region_name  # Freeze the stats display to the clicked region
	_update_region_info(region_name)

# Handle the AchievementButton press
func _on_achievement_button_pressed() -> void:
	# Navigate to the Achievement scene
	get_tree().change_scene_to_file("res://scenes/MainUI/Achievement.tscn")
