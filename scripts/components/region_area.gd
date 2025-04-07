extends Area2D

var region_name = ""
var is_locked = true
var real_color = Color(0.5, 0.5, 0.5, 1) # Default semi-transparent color


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_child_entered_tree(node):
	if node.is_class("Polygon2D"):
		if is_locked:
			node.color = Color(0.5, 0.5, 0.5, 1)
		else:
			node.color = real_color


func _on_mouse_entered():
	print(region_name)
	for node in get_children():
		if node.is_class("Polygon2D"):
			if is_locked:
				node.color = Color(1,1,1,1 )
			else:
				node.color = Color(1,1,1,1 )


func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		print(str(region_name) + " Clicked")


func _on_mouse_exited():
	for node in get_children():
		if node.is_class("Polygon2D"):
			if is_locked:
				node.color = Color(0.5, 0.5, 0.5, 1)
			else:
				node.color = real_color

# Sets the real color of the region
func set_real_color(color: Color):
	real_color = color
	update_color()

func update_color():
	for node in get_children():
		if node.is_class("Polygon2D"):
			node.color = Color(1, 1, 1, 0.5) if is_locked else real_color
