extends Control

@onready var label_money = $VBoxContainer/HBoxContainer/LabelMoney
@onready var label_timer = $VBoxContainer/HBoxContainer/LabelTimer
@onready var angkot_list = $MarginContainer/ScrollContainer/AngkotList
@onready var angkot_item_template = $MarginContainer/ScrollContainer/AngkotList/AngkotItem
@onready var terminal_animation = $VBoxContainer/HBoxContainer3/TerminalAnimation  # Reference to the TerminalAnimation scene

func _ready():
	if not Global.is_initialized:
		Global.reset_game()

	# Keep a reference to the template and make it invisible
	angkot_item_template.visible = false
	randomize()
	update_ui()

func update_ui():
	label_money.text = "Duit: Rp " + str(Global.money)

	# Clear existing items EXCEPT the template
	for child in angkot_list.get_children():
		if child != angkot_item_template:  # Skip the template
			child.queue_free()

	# Create buttons for each angkot
	for angkot in Global.angkots:
		var angkot_item = angkot_item_template.duplicate()
		angkot_item.visible = true

		var AngkotImage = angkot_item.get_node("AngkotImage")
		var AngkotLabel = angkot_item.get_node("AngkotLabel")
		var RepairButton = angkot_item.get_node("RepairButton")
		var SellButton = angkot_item.get_node("SellButton")
		var AssignDriverButton = angkot_item.get_node("AssignDriverButton")


		# Set the label text
		if angkot.driver:
			AngkotLabel.text = "%s\nLv.%d | Speed: %d | Cap: %d | Income: Rp %d | Condition: %.1f%%\nDriver: %s (Fee: Rp %dK)" % [
			angkot.name,
			angkot.upgrade_level,
			angkot.speed,
			angkot.capacity,
			angkot.income_per_passenger,
			angkot.condition,
			angkot.driver.name,
			angkot.driver.fee
			]
		else:
			AngkotLabel.text = "%s\nLv.%d | Speed: %d | Cap: %d | Income: Rp %d | Condition: %.1f%%\nDriver: Tidak ada supir" % [
			angkot.name,
			angkot.upgrade_level,
			angkot.speed,
			angkot.capacity,
			angkot.income_per_passenger,
			angkot.condition
			]

		# Add texture
		AngkotImage.set_texture_normal(load(angkot.image_path))

		# Connect buttons
		AngkotLabel.pressed.connect(self._on_angkot_button_pressed.bind(angkot))
		AngkotImage.pressed.connect(self._on_angkot_button_pressed.bind(angkot))
		RepairButton.text = "Repair (Rp 500)"
		RepairButton.connect("pressed", self._on_repair_button_pressed.bind(angkot))
		SellButton.text = "Sell (Rp %d)" % angkot.calculate_sell_price()
		SellButton.connect("pressed", self._on_sell_button_pressed.bind(angkot))
		AssignDriverButton.connect("pressed", self._on_assign_driver_button_pressed.bind(angkot))

		angkot_list.add_child(angkot_item)

func _on_angkot_button_pressed(angkot: Angkot):
	# Store the selected Angkot in Global
	Global.selected_angkot = angkot
	print("Angkot selected:", angkot.name)
	
	# Change to the AngkotDetail scene
	get_tree().change_scene_to_file("res://scenes/MainUI/AngkotDetail.tscn")

func _on_repair_button_pressed(angkot: Angkot):
	# Repair the angkot if the player has enough money
	var repair_cost = 500
	if Global.money >= repair_cost:
		Global.money -= repair_cost
		angkot.repair()
		print("%s has been repaired!" % angkot.name)
		terminal_animation.play_angkot_enter()
		update_ui()
	else:
		print("Not enough money to repair %s!" % angkot.name)

func _on_sell_button_pressed(angkot: Angkot):
	# Sell the angkot and update the player's money
	var sell_price = angkot.calculate_sell_price()
	Global.money += sell_price
	Global.angkots.erase(angkot)  # Remove the angkot from the list
	print("%s sold for Rp %d!" % [angkot.name, sell_price])
	update_ui()

func _on_assign_driver_button_pressed(angkot: Angkot):
	# Store the selected Angkot in Global
	Global.selected_angkot = angkot
	print("Assigning driver to:", angkot.name)

	# Change to the DriverList scene
	get_tree().change_scene_to_file("res://scenes/MainUI/DriverList.tscn")


func _on_timer_timeout():
	_ready()
	
	
