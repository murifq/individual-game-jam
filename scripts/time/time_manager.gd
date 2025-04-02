extends Node

func _ready():
	# Timer is configured in the scene, no need to start it manually if autostart is enabled
	print("TimeManager is ready")

func _on_timer_timeout():
	if Global.is_paused:
		return
	
	# Update game minutes
	Global.game_minutes += 1
	
	# Handle minute rollover
	if Global.game_minutes >= 60:
		Global.game_minutes = 0
		Global.game_hours += 1
	
	# Handle hour rollover
	if Global.game_hours >= 24:
		Global.game_hours = 0
		Global.game_days += 1
	
	# Debugging output
	#print("Time updated: Day %d, %02d:%02d" % [Global.game_days, Global.game_hours, Global.game_minutes])
	
	# Update the UI timer
	get_tree().call_group("time_display", "update_time_display")
