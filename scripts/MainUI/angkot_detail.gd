extends ColorRect

@onready var angkot_name = $VBoxContainer/AngkotName
@onready var angkot_stats = $VBoxContainer/AngkotStats
@onready var angkot_image = $VBoxContainer/HBoxContainer/AngkotImage
@onready var back_button = $VBoxContainer/BackButton

func _ready():
	# Get the selected Angkot from Global
	var angkot = Global.selected_angkot
	if angkot:
		# Update the UI with the Angkot's details
		angkot_name.text = angkot.name
		angkot_stats.text = "Level: %d\nSpeed: %d\nCapacity: %d\nIncome: Rp %d" % [
			angkot.upgrade_level,
			angkot.speed,
			angkot.capacity,
			angkot.income_per_passenger
		]
		angkot_image.texture = load(angkot.image_path)
	else:
		print("No Angkot selected!")

	# Connect the back button to return to the previous scene
	back_button.connect("pressed", self._on_back_button_pressed)

func _on_back_button_pressed():
	# Return to the MainUI scene
	get_tree().change_scene_to_file("res://scenes/MainUI/MainUI.tscn")
