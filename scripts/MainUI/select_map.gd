extends ColorRect

@onready var region_label = $HBoxContainer/ColorRect/VBoxContainer/RegionLabel
@onready var stats_label = $HBoxContainer/ColorRect/VBoxContainer/StatsLabel
@onready var buy_button = $HBoxContainer/ColorRect/VBoxContainer/BuyButton
@onready var region_map = $HBoxContainer/VBoxContainer/CanvasLayer/AngkotMap

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

	# Connect the buy button
	buy_button.pressed.connect(self._on_buy_button_pressed)

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

# Update the region info (name, stats, and button visibility)
func _update_region_info(region_name: String) -> void:
	var region = Global.regions.get(region_name)
	if region:
		region_label.text = "Region: " + region.name
		stats_label.text = "Population Density: %.2f\nTraffic Level: %.2f\nEconomic Activity: %.2f\nPrice: %d" % [
			region.population_density,
			region.traffic_level,
			region.economic_activity,
			region.price
		]
		buy_button.visible = region.is_locked
	else:
		region_label.text = "Region: None"
		stats_label.text = ""
		buy_button.visible = false

# Handle the buy button press
func _on_buy_button_pressed() -> void:
	var region = Global.regions[clicked_region]
	if region and region.is_locked:
		if Global.money >= region.price:
			Global.money -= region.price
			region.is_locked = false
			_update_region_info(Global.selected_region)
			print("%s has been unlocked!" % region.name)
		else:
			print("Not enough money to unlock %s!" % region.name)

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
