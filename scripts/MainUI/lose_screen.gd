extends ColorRect

@onready var play_again_button = $CenterContainer/VBoxContainer/PlayAgainButton

func _ready():
	# Connect the PlayAgain button
	play_again_button.pressed.connect(self._on_play_again_button_pressed)

func _on_play_again_button_pressed():
	# Reset the game state
	Global.is_initialized = false  # Set to false to reset the game
	Global.reset_game()  # Call the reset_game function in Global.gd

	# Return to the StartScreen
	get_tree().change_scene_to_file("res://scenes/MainUI/StartScreen.tscn")
