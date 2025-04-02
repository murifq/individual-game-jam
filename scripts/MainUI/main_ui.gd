extends Control

@onready var label_money = $VBoxContainer/HBoxContainer/LabelMoney
@onready var label_timer = $VBoxContainer/HBoxContainer/LabelTimer
@onready var angkot_list = $MarginContainer/ScrollContainer/AngkotList
@onready var angkot_item_template = $MarginContainer/ScrollContainer/AngkotList/AngkotItem

func _ready():
	Global.reset_game()
	update_ui()
	update_time_display()

func update_ui():
	label_money.text = "Duit: Rp " + str(Global.money)
	
	 #Clear existing items except templates
	for child in angkot_list.get_children():
		if child != angkot_item_template:
			child.queue_free()
	
	# Hide the template button
	#angkot_item_template.visible = false
	
	# Create a button for each angkot
	for angkot in Global.angkots:
		# Duplicate the AngkotButton template
		var angkot_item = angkot_item_template.duplicate()
		#button.visible = true
		
		# Update the content inside the button
		var AngkotImage = angkot_item.get_node("AngkotImage")
		#var color_rect = angkot_item.get_node("AngkotItemColored")
		var AngkotLabel = angkot_item.get_node("AngkotLabel")
		
		# Set the label text
		AngkotLabel.text = "%s\nLv.%d | Speed: %d | Cap: %d | Income: Rp %d" % [
			angkot.name,
			angkot.upgrade_level,
			angkot.speed,
			angkot.capacity,
			angkot.income_per_passenger
		]
		
		# Add texture (optional if you want to add an image)
		var texture_rect = angkot_item.get_node("AngkotImage")
		texture_rect.set_texture_normal(load(angkot.image_path))
		print(texture_rect.get_texture_normal())
		#print(texture_rect.set_texture_normal())
		#texture_rect.texture = load(angkot.image_path)
		
		# Connect the button's pressed signal to navigate to AngkotDetail
		#button.pressed.connect(self._on_angkot_button_pressed)
		#print(angkot is Angkot)
		# Add the button to the AngkotList
		angkot_list.add_child(angkot_item)

func update_time_display():
	label_timer.text = "%s | %s" % [Global.get_day_string(), Global.get_time_string()]

# Handle button press
func _on_angkot_button_pressed():
	# Store the selected angkot in Global
	#Global.selected_angkot = angkot
	print("Hello")
	
	# Change to the AngkotDetail scene
	#get_tree().change_scene("res://scenes/AngkotDetail/AngkotDetail.tscn")
