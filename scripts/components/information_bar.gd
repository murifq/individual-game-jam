extends HBoxContainer
@onready var label_timer = $LabelTimer
@onready var label_money = $LabelMoney

func _ready():
	update_ui()

func update_ui():
	label_money.text = "Duit: Rp " + str(Global.money)
	update_time_display()
	
func update_time_display():
	label_timer.text = "%s | %s" % [Global.get_day_string(), Global.get_time_string()]
