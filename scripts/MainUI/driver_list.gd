extends ColorRect

@onready var driver_list_container = $MarginContainer/ScrollContainer/DriverListContainer
@onready var driver_item_template = $MarginContainer/ScrollContainer/DriverListContainer/DriverItem

@onready var back_button = $VBoxContainer/HBoxContainer2/BackButton
@onready var add_drivers_button = $VBoxContainer/HBoxContainer3/AddDrivers
@onready var label_number_drivers = $VBoxContainer/HBoxContainer2/LabelNumberDrivers  # Label to display the number of drivers

func _ready():
	# Hide the template node
	driver_item_template.visible = false
	
	# Populate the driver list
	populate_driver_list()
	
	# Connect buttons
	back_button.pressed.connect(self._on_back_button_pressed)
	add_drivers_button.pressed.connect(self._on_add_drivers_button_pressed)

func populate_driver_list():
	# Clear existing items except the template
	for child in driver_list_container.get_children():
		if child != driver_item_template:
			child.queue_free()
	driver_item_template.visible = false
	
	# Update the label to show the total number of drivers
	label_number_drivers.text = "Jumlah supir: %d" % Global.drivers.size()

	# Add each driver to the list
	for driver in Global.drivers:
		var driver_item = driver_item_template.duplicate()
		driver_item.visible = true
		
		var DriverName = driver_item.get_node("DriverName")
		var DriverStats = driver_item.get_node("DriverStats")
		var AssignButton = driver_item.get_node("AssignButton")
		var FireButton = driver_item.get_node("FireButton")
		
		# Set driver details
		DriverName.text = driver.name
		DriverStats.text = "Skill: %.1f | Maintenance: %.1f | Fee: Rp %dK" % [
			driver.skill,
			driver.maintenance_effect,
			driver.fee
		]
		
		# Set AssignButton text and behavior
		if driver.is_assigned and driver == Global.selected_angkot.driver:
			AssignButton.text = "Lepaskan"
			AssignButton.connect("pressed", self._on_detach_driver_pressed.bind(driver))
		elif driver.is_assigned == false:
			AssignButton.text = "Tetapkan"
			AssignButton.connect("pressed", self._on_assign_button_pressed.bind(driver))
		else:
			continue
		
		# Connect the Fire button
		FireButton.connect("pressed", self._on_fire_button_pressed.bind(driver))
		
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
		driver.angkot = Global.selected_angkot
		driver.is_assigned = true
		print("Assigned %s to %s" % [driver.name, Global.selected_angkot.name])
		
		# Return to the MainUI scene
		get_tree().change_scene_to_file("res://scenes/MainUI/MainUI.tscn")
	else:
		print("No Angkot selected!")

func _on_detach_driver_pressed(driver: Driver):
	# Detach the driver from the currently selected Angkot
	for angkot in Global.angkots:
		if angkot.driver == driver:
			angkot.driver = null
			driver.is_assigned = false
			driver.angkot = null
			print("Driver %s has been detached from Angkot %s" % [driver.name, angkot.name])
			break
	
	# Update the driver list UI
	populate_driver_list()

func _on_fire_button_pressed(driver: Driver):
	# Check if the driver is assigned to an Angkot
	for angkot in Global.angkots:
		if angkot.driver == driver:
			# Detach the driver from the Angkot
			angkot.driver = null
			driver.angkot = null
			print("Driver %s has been detached from Angkot %s" % [driver.name, angkot.name])
			break

	# Remove the driver from Global.drivers
	if driver in Global.drivers:
		Global.drivers.erase(driver)
	print("Driver %s has been fired!" % driver.name)

	# Update the driver list UI
	populate_driver_list()

func _on_add_drivers_button_pressed():
	# Generate a new random driver
	var new_driver = Driver.generate_random_driver()
	Global.drivers.append(new_driver)  # Add the new driver to the global drivers list
	print("New driver added: %s" % new_driver.name)
	
	# Update the driver list UI
	populate_driver_list()

func _on_back_button_pressed():
	# Change back to the MainUI scene
	get_tree().change_scene_to_file("res://scenes/MainUI/MainUI.tscn")
