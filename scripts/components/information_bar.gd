extends HBoxContainer
@onready var label_timer = $VBoxContainer/HBoxContainer/LabelTimer


func update_time_display():
	label_timer.text = "%s | %s" % [Global.get_day_string(), Global.get_time_string()]
