extends Node2D

@onready var angkot_sprite = $Angkot
@onready var animation_player = $AnimationPlayer

func _ready():
	# Start the animation when the scene is ready
	animation_player.play("AngkotEnter")

func play_angkot_enter():
	# Play the animation for the Angkot entering the terminal
	animation_player.play("AngkotEnter")

func play_angkot_exit():
	# Play the animation for the Angkot exiting the terminal
	animation_player.play("AngkotExit")
