extends Control

@onready var angkot_list = $MarginContainer/ScrollContainer/AngkotList
@onready var angkot_item_template = $MarginContainer/ScrollContainer/AngkotList/AngkotItem
@onready var label_page = $VBoxContainer/HBoxContainer2/LabelPage
@onready var back_button = $VBoxContainer/HBoxContainer2/BackButton
@onready var label_capacity = $VBoxContainer/HBoxContainer2/LabelCapacity

@onready var label_info = $ConfirmationBox/VBoxContainer/CenterContainer/InfoLabel
@onready var confirm_button = $ConfirmationBox/VBoxContainer/CenterContainer2/HBoxContainer/ConfirmButton
@onready var cancel_button = $ConfirmationBox/VBoxContainer/CenterContainer2/HBoxContainer/CancelButton
@onready var confirmation_box = $ConfirmationBox

func _ready():
	if not Global.is_initialized:
		Global.reset_game()

	# Set up the label for the selected region
	label_page.text = "Armada kamu di wilayah " + Global.selected_region
	label_capacity.text = "Kapasitas angkot: " + str(Global.terminals[Global.selected_region].capacity)
	angkot_item_template.visible = false

	# Connect the BackButton
	back_button.pressed.connect(self._on_back_button_pressed)

	# Connect the CancelButton
	cancel_button.pressed.connect(self._on_cancel_upgrade_button_pressed)

	# Connect the ConfirmButton
	confirm_button.pressed.connect(self._on_confirm_upgrade_button_pressed)

	randomize()
	update_ui()

func update_ui():
	# Clear existing items EXCEPT the template
	for child in angkot_list.get_children():
		if child != angkot_item_template:  # Skip the template
			child.queue_free()

	# Create buttons for each angkot
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
		RepairButton.text = "Repair (Rp 500)"
		RepairButton.connect("pressed", self._on_repair_button_pressed.bind(angkot))
		SellButton.text = "Sell (Rp %d)" % angkot.calculate_sell_price()
		SellButton.connect("pressed", self._on_sell_button_pressed.bind(angkot))
		OperateButton.connect("pressed", self._on_operate_button_pressed.bind(angkot))
		AssignDriverButton.connect("pressed", self._on_assign_driver_button_pressed.bind(angkot))
		UpgradeButton.connect("pressed", self._on_upgrade_button_pressed.bind(angkot))  # Connect UpgradeButton

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

func _on_upgrade_button_pressed(angkot: Angkot):
	# Get the upgraded angkot stats using upgrade_info
	confirmation_box.visible = true
	Global.selected_angkot = angkot
	var upgraded_angkot = angkot.upgrade_info()
	var upgrade_price = 0
	if upgraded_angkot.upgrade_level - 1 < upgraded_angkot.UPGRADE_DATA.size():
		upgrade_price = upgraded_angkot.UPGRADE_DATA[upgraded_angkot.upgrade_level - 1]["price"]
	label_info.text = "Upgrade Info:\nLv.%d | Speed: %d | Cap: %d | Income: Rp %d\nUpgrade Price: Rp %d" % [
		upgraded_angkot.upgrade_level,
		upgraded_angkot.speed,
		upgraded_angkot.capacity,
		upgraded_angkot.income_per_passenger,
		upgrade_price
	]
	print("Upgrade Info: ", label_info.text)

func _on_confirm_upgrade_button_pressed():
	# Perform the real upgrade on the selected angkot
	if Global.selected_angkot:
		var upgrade_result = Global.selected_angkot.upgrade()
		print(upgrade_result)
		print(Global.money)
		print("Berhasil terupgrade")
	confirmation_box.visible = false
	update_ui()  # Refresh the UI to reflect the upgraded stats

func _on_cancel_upgrade_button_pressed():
	# Hide the confirmation box
	confirmation_box.visible = false

func _on_back_button_pressed():
	# Change back to the SelectMap scene
	get_tree().change_scene_to_file("res://scenes/MainUI/SelectMap.tscn")

func _on_timer_timeout():
	_ready()
