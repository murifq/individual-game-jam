extends Node

var money: int = 25000
var angkots: Array[Angkot] = []
var drivers: Array[Driver] = []  # Add this to store all drivers

# Time variables
var game_minutes: int = 0
var game_hours: int = 8  # Start at 8 AM
var game_days: int = 1
var is_paused: bool = false
var selected_angkot: Angkot = null

var is_initialized: bool = false

func reset_game():
	money = 25000
	angkots.clear()
	drivers.clear()  # Clear drivers list

	# Reset time
	game_minutes = 0
	game_hours = 8
	game_days = 1

	# Create drivers
	var driver1 = Driver.new()
	driver1.name = "Pak Budi"
	driver1.fee = 5  # 5000 rupiah per operation
	driver1.skill = 1.0  # Neutral skill
	driver1.maintenance_effect = 1.0  # Neutral maintenance effect

	var driver2 = Driver.new()
	driver2.name = "Pak Joko"
	driver2.fee = 3  # 3000 rupiah per operation
	driver2.skill = 0.9  # Slightly lower skill
	driver2.maintenance_effect = 1.2  # Higher maintenance effect (worse for condition)

	var driver3 = Driver.new()
	driver3.name = "Pak Agus"
	driver3.fee = 4  # 4000 rupiah per operation
	driver3.skill = 1.1  # Slightly higher skill
	driver3.maintenance_effect = 0.8  # Lower maintenance effect (better for condition)

	# Add drivers to the global list
	drivers.append(driver1)
	drivers.append(driver2)
	drivers.append(driver3)

	# Create angkots and assign drivers
	var a1 = Angkot.new()
	a1.name = "Angkot Kuning"
	a1.speed = 40
	a1.capacity = 6
	a1.income_per_passenger = 5  # 5000 rupiah per passenger
	a1.image_path = "res://assets/AngkotKuning.png"
	a1.driver = driver1

	var a2 = Angkot.new()
	a2.name = "Angkot Hijau"
	a2.speed = 40
	a2.capacity = 6
	a2.income_per_passenger = 5  # 5000 rupiah per passenger
	a2.image_path = "res://assets/AngkotHijau.png"
	a2.driver = driver2
	
	driver1.is_assigned = true
	driver2.is_assigned = true
	angkots.append(a1)
	angkots.append(a2)
	is_initialized = true

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
