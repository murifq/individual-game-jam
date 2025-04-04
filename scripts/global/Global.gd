extends Node

var money: int = 0
var angkots: Array[Angkot] = []

# Time variables
var game_minutes: int = 0
var game_hours: int = 8  # Start at 8 AM
var game_days: int = 1
var is_paused: bool = false
var selected_angkot: Angkot = null 

func reset_game():
	money = 25000
	angkots.clear()
	
	# Reset time
	game_minutes = 0
	game_hours = 8
	game_days = 1

	var a1 = Angkot.new()
	a1.name = "Angkot Kuning"
	a1.speed = 40
	a1.capacity = 6
	a1.income_per_passenger = 1000
	a1.image_path = "res://assets/AngkotKuning.png"

	var a2 = Angkot.new()
	a2.name = "Angkot Hijau super imbagelo keren bgt abiez"
	a2.speed = 40
	a2.capacity = 6
	a2.income_per_passenger = 1000
	a2.image_path = "res://assets/AngkotHijau.png"

	angkots.append(a1)
	angkots.append(a2)
	

	

# Format time as HH:MM
func get_time_string() -> String:
	var am_pm = "AM" if game_hours < 12 else "PM"
	var hour_12 = game_hours
	if hour_12 > 12:
		hour_12 -= 12
	if hour_12 == 0:
		hour_12 = 12
	
	return "%02d:%02d %s" % [hour_12, game_minutes, am_pm]

# Get day as string
func get_day_string() -> String:
	return "Day %d" % game_days
