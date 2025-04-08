extends ColorRect

@onready var driver_list_container = $MarginContainer/ScrollContainer/DriverListContainer
@onready var driver_item_template = $MarginContainer/ScrollContainer/DriverListContainer/DriverItem

func _ready():
	# Hide the template node
	driver_item_template.visible = false
	
	# Populate the driver list
	populate_driver_list()

func populate_driver_list():
	# Clear existing items except the template
	for child in driver_list_container.get_children():
		if child != driver_item_template:
			child.queue_free()
	
	# Add a "Detach Driver" option if the selected Angkot has a driver
	if Global.selected_angkot and Global.selected_angkot.driver:
		var detach_item = driver_item_template.duplicate()
		detach_item.visible = true
		
		var DriverName = detach_item.get_node("DriverName")
		var DriverStats = detach_item.get_node("DriverStats")
		var AssignButton = detach_item.get_node("AssignButton")
		
		DriverName.text = "Detach Driver"
		DriverStats.text = "Remove the current driver from this Angkot."
		AssignButton.text = "Detach"
		AssignButton.connect("pressed", self._on_detach_driver_pressed)
		
		driver_list_container.add_child(detach_item)
	
	# Add each available driver to the list
	for driver in get_all_available_drivers():
		var driver_item = driver_item_template.duplicate()
		driver_item.visible = true
		
		var DriverName = driver_item.get_node("DriverName")
		var DriverStats = driver_item.get_node("DriverStats")
		var AssignButton = driver_item.get_node("AssignButton")
		
		# Set driver details
		DriverName.text = driver.name
		DriverStats.text = "Skill: %.1f | Maintenance: %.1f | Fee: Rp %dK" % [
			driver.skill,
			driver.maintenance_effect,
			driver.fee
		]
		
		# Connect the Assign button
		AssignButton.connect("pressed", self._on_assign_button_pressed.bind(driver))
		
		# Add the driver item to the list
		driver_list_container.add_child(driver_item)

func get_all_available_drivers() -> Array:
	# Return a list of drivers that are not assigned to any Angkot
	var available_drivers = []
	for driver in Global.drivers:
		if not driver.is_assigned:
			available_drivers.append(driver)
	return available_drivers

func _on_assign_button_pressed(driver: Driver):
	# Assign the selected driver to the currently selected Angkot
	if Global.selected_angkot:
		# Assign the driver to the Angkot
		if Global.selected_angkot.driver:
			Global.selected_angkot.driver.is_assigned = false
		Global.selected_angkot.driver = driver
		driver.is_assigned = true
		print("Assigned %s to %s" % [driver.name, Global.selected_angkot.name])
		
		# Return to the MainUI scene
		get_tree().change_scene_to_file("res://scenes/MainUI/MainUI.tscn")
	else:
		print("No Angkot selected!")

func _on_detach_driver_pressed():
	# Detach the driver from the currently selected Angkot
	if Global.selected_angkot and Global.selected_angkot.driver:
		Global.selected_angkot.driver.is_assigned = false
		Global.selected_angkot.driver = null
		print("Driver detached from %s" % Global.selected_angkot.name)
		
		# Return to the MainUI scene
		get_tree().change_scene_to_file("res://scenes/MainUI/MainUI.tscn")
