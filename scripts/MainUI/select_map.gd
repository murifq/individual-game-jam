extends ColorRect

@onready var region_label = $HBoxContainer/ColorRect/VBoxContainer/RegionLabel
@onready var stats_label = $HBoxContainer/ColorRect/VBoxContainer/StatsLabel
@onready var buy_button = $HBoxContainer/ColorRect/VBoxContainer/BuyButton

func _ready() -> void:
	# Initialize the label with the current selected region
	Global.reset_game()
	_update_region_info(Global.selected_region)

	# Connect to the signal from Global
	Global.selected_region_changed.connect(self._on_selected_region_changed)

	# Connect the buy button
	buy_button.pressed.connect(self._on_buy_button_pressed)

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
	var region = Global.regions.get(Global.selected_region)
	if region and region.is_locked:
		if Global.money >= region.price:
			Global.money -= region.price
			region.is_locked = false
			_update_region_info(Global.selected_region)
			print("%s has been unlocked!" % region.name)
		else:
			print("Not enough money to unlock %s!" % region.name)
