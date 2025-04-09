extends Control

@onready var angkot_list = $MarginContainer/ScrollContainer/AngkotList
@onready var angkot_item_template = $MarginContainer/ScrollContainer/AngkotList/AngkotItem

@onready var label_page = $VBoxContainer/HBoxContainer2/LabelPage
@onready var back_button = $VBoxContainer/HBoxContainer2/BackButton
@onready var label_capacity = $VBoxContainer/HBoxContainer2/LabelCapacity

@onready var add_angkot_button = $VBoxContainer/HBoxContainer3/AddAngkotButton
@onready var upgrade_terminal_button = $VBoxContainer/HBoxContainer3/UpgradeTerminalButton

@onready var label_info = $ConfirmationBox/VBoxContainer/CenterContainer/InfoLabel

@onready var confirm_terminal_button = $ConfirmationBox/VBoxContainer/CenterContainer2/HBoxContainer/ConfirmTerminalButton
@onready var confirm_ankot_button = $ConfirmationBox/VBoxContainer/CenterContainer2/HBoxContainer/ConfirmAngkotButton

@onready var cancel_button = $ConfirmationBox/VBoxContainer/CenterContainer2/HBoxContainer/CancelButton
@onready var confirmation_box = $ConfirmationBox

@onready var terminal_image = $VBoxContainer/HBoxContainer4/CenterContainer/TerminalImage

func _ready():
	if not Global.is_initialized:
		Global.reset_game()

	# Set up the label for the selected region
	label_page.text = "Armada kamu di wilayah " + Global.selected_region
	
	angkot_item_template.visible = false

	# Connect the BackButton
	back_button.pressed.connect(self._on_back_button_pressed)

	# Connect the CancelButton
	cancel_button.pressed.connect(self._on_cancel_upgrade_button_pressed)

	# Connect the ConfirmButton
	#confirm_button.pressed.connect(self._on_confirm_upgrade_button_pressed)
	upgrade_terminal_button.connect("pressed", self._on_upgrade_terminal_button_pressed.bind(Global.terminals[Global.selected_region]))
	# Connect the AddAngkotButton
	add_angkot_button.pressed.connect(self._on_add_angkot_button_pressed)

	randomize()
	update_ui()

func update_ui():
	# Clear existing items EXCEPT the template
	for child in angkot_list.get_children():
		if child != angkot_item_template:  # Skip the template
			child.queue_free()

	# Get the terminal for the selected region
	var terminal = Global.terminals[Global.selected_region]
	terminal_image.texture = load(terminal.image_path)

	# Count the number of angkots in the selected region
	var angkots_in_region = Global.angkots.filter(func(angkot): return angkot.current_region.short_name == Global.selected_region).size()

	# Update the label_capacity to show the number of angkots and the terminal's capacity
	label_capacity.text = "Kapasitas angkot: %d/%d" % [angkots_in_region, terminal.capacity]
	
	for angkot in Global.angkots:
		if angkot.current_region.short_name != Global.selected_region:
			continue
		var angkot_item = angkot_item_template.duplicate()
		angkot_item.visible = true

		var AngkotImage = angkot_item.get_node("AngkotImage")
		var AngkotLabel = angkot_item.get_node("AngkotLabel")
		var VContainer = angkot_item.get_node("VBoxContainer")
		var VContainer2 = angkot_item.get_node("VBoxContainer2")
		var VContainer3 = angkot_item.get_node("VBoxContainer3")
		var RepairButton = VContainer2.get_node("RepairButton")
		var SellButton = VContainer2.get_node("SellButton")
		var OperateButton = VContainer.get_node("OperateButton")
		var AssignDriverButton = VContainer.get_node("AssignDriverButton")
		var UpgradeButton = VContainer3.get_node("UpgradeButton")
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

		# Set OperateButton text based on the angkot's operating state
		OperateButton.text = "Hentikan" if angkot.is_operating else "Jalankan"

		# Connect buttons
		AngkotLabel.pressed.connect(self._on_angkot_button_pressed.bind(angkot))
		AngkotImage.pressed.connect(self._on_angkot_button_pressed.bind(angkot))
		RepairButton.text = "Perbaiki (Rp 500)"
		RepairButton.connect("pressed", self._on_repair_button_pressed.bind(angkot))
		SellButton.text = "Jual (Rp %d)" % angkot.calculate_sell_price()
		SellButton.connect("pressed", self._on_sell_button_pressed.bind(angkot))
		OperateButton.connect("pressed", self._on_operate_button_pressed.bind(angkot))
		AssignDriverButton.connect("pressed", self._on_assign_driver_button_pressed.bind(angkot))
		UpgradeButton.connect("pressed", self._on_upgrade_angkot_button_pressed.bind(angkot))  # Connect UpgradeButton

		angkot_list.add_child(angkot_item)

func _on_add_angkot_button_pressed():
	# Get the terminal for the current region
	var terminal = Global.terminals.get(Global.selected_region)
	if not terminal:
		print("No terminal found for the selected region!")
		return

	# Check if the terminal has enough capacity
	var angkots_in_region = Global.angkots.filter(func(angkot): return angkot.current_region.short_name == Global.selected_region)
	if angkots_in_region.size() >= terminal.capacity:
		print("Terminal capacity reached! Upgrade the terminal to add more angkots.")
		return

	# Create a new angkot and assign it to the current region
	var new_angkot = Global.create_new_angkot()
	new_angkot.current_region = Global.regions[Global.selected_region]
	Global.angkots.append(new_angkot)
	print("New angkot added to %s!" % Global.selected_region)

	# Update the UI
	update_ui()

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

func _on_operate_button_pressed(angkot: Angkot):
	# Toggle the operating state of the angkot
	if angkot.is_operating:
		angkot.stop_operate()
	else:
		angkot.start_operate()
	update_ui()  # Refresh the UI to update the button text

func _on_assign_driver_button_pressed(angkot: Angkot):
	# Store the selected Angkot in Global
	Global.selected_angkot = angkot
	print("Assigning driver to:", angkot.name)

	# Change to the DriverList scene
	get_tree().change_scene_to_file("res://scenes/MainUI/DriverList.tscn")

func _on_upgrade_angkot_button_pressed(angkot: Angkot):
	# Get the upgraded angkot stats using upgrade_info
	confirmation_box.visible = true
	confirm_ankot_button.visible = true
	confirm_terminal_button.visible = false
	
	confirm_ankot_button.pressed.connect(self._on_confirm_upgrade_button_pressed.bind("Angkot"))
	
	if angkot.upgrade_level == 5:
		label_info.text = "Level angkot sudah maksimal"
		return
	Global.selected_angkot = angkot
	var upgraded_angkot = angkot.upgrade_info()
	var upgrade_price = 0
	if angkot.upgrade_level < angkot.UPGRADE_DATA.size():
		upgrade_price = angkot.UPGRADE_DATA[angkot.upgrade_level]["price"]
	label_info.text = "Upgrade Info:\nLv.%d | Speed: %d | Cap: %d | Income: Rp %d\nUpgrade Price: Rp %d" % [
		upgraded_angkot.upgrade_level,
		upgraded_angkot.speed,
		upgraded_angkot.capacity,
		upgraded_angkot.income_per_passenger,
		upgrade_price
	]
	print("Upgrade Info: ", label_info.text)
	
func _on_upgrade_terminal_button_pressed(terminal: Terminal):
	# Show the confirmation box and set visibility for terminal upgrade
	confirmation_box.visible = true
	confirm_ankot_button.visible = false
	confirm_terminal_button.visible = true

	# Connect the confirm button for terminal upgrade
	confirm_terminal_button.pressed.connect(self._on_confirm_upgrade_button_pressed.bind("Terminal"))

	# Check if the terminal is already at the maximum level
	if terminal.level >= terminal.LEVEL_DATA.size():
		label_info.text = "Level terminal sudah maksimal"
		return

	# Get the upgrade info for the terminal
	var upgraded_terminal = terminal.upgrade_info()
	label_info.text = "Upgrade Info:\nLv.%d -> Lv.%d\nCapacity: %d -> %d\nUpgrade Price: Rp %d" % [
	terminal.level,
	upgraded_terminal.level,
	terminal.capacity,
	upgraded_terminal.capacity,
	upgraded_terminal.upgrade_price
	]
	print("Upgrade Info: ", label_info.text)

func _on_confirm_upgrade_button_pressed(type: String):
# Perform the real upgrade based on the type
	if type == "Angkot":
		if Global.selected_angkot:
			var upgrade_result = Global.selected_angkot.upgrade()
			print(upgrade_result)
	elif type == "Terminal":
		var terminal = Global.terminals.get(Global.selected_region)
		if terminal:
			if terminal.upgrade():
				print("Terminal upgraded successfully!")
			else:
				print("Failed to upgrade terminal!")
		# Hide the confirmation box and update the UI
	confirmation_box.visible = false
	update_ui()
	

func _on_cancel_upgrade_button_pressed():
	# Hide the confirmation box
	confirmation_box.visible = false

func _on_back_button_pressed():
	# Change back to the SelectMap scene
	get_tree().change_scene_to_file("res://scenes/MainUI/SelectMap.tscn")

func _on_timer_timeout():
	_ready()
