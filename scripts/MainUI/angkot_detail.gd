extends ColorRect

@onready var angkot_image = $AngkotImage  # Reference to the TextureRect node

func _ready():
	# Get the selected Angkot from Global
	var angkot = Global.selected_angkot
	if angkot:
		# Load the Angkot image and set it to the TextureRect
		angkot_image.set_texture(load(angkot.image_path))
	else:
		print("No Angkot selected!")
