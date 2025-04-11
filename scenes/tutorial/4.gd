extends Container

@onready var next_button = $TextureRect/ColorRect/VBoxContainer/Button

func _ready() -> void:
	# Connect the button to navigate to the next tutorial
	next_button.pressed.connect(self._on_next_button_pressed)

func _on_next_button_pressed():
	# Change to the next tutorial scene
	get_tree().change_scene_to_file("res://scenes/tutorial/5.MainUITutor.tscn")
