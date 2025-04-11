extends Container

@onready var next_button = $TextureRect/ColorRect/VBoxContainer/Button

func _ready() -> void:
	# Connect the button to navigate to the main game
	next_button.pressed.connect(self._on_next_button_pressed)

func _on_next_button_pressed():
	# Change to the main game scene
	get_tree().change_scene_to_file("res://scenes/MainUI/StartScreen.tscn")
