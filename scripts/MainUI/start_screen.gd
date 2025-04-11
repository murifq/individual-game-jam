extends ColorRect
@onready var play_button = $HBoxContainer/PlayButton
@onready var tutor_button = $HBoxContainer/TutorButton
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play_button.pressed.connect(self._on_play_button_pressed)
	tutor_button.pressed.connect(self._on_tutor_button_pressed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_play_button_pressed():
	# Change back to the SelectMap scene
	get_tree().change_scene_to_file("res://scenes/MainUI/SelectMap.tscn")

func _on_tutor_button_pressed():
	# Change back to the SelectMap scene
	get_tree().change_scene_to_file("res://scenes/tutorial/1.SelectMapTutor.tscn")
