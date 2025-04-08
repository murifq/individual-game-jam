extends Node

# Global variables
var money: int = 25000
var angkots: Array[Angkot] = []
var drivers: Array[Driver] = []
var regions: Dictionary = {}  # Dictionary to store all regions
var terminals: Dictionary = {}  # Dictionary to store all terminals
var selected_angkot: Angkot = null

# Time variables
var game_minutes: int = 0
var game_hours: int = 8  # Start at 8 AM
var game_days: int = 1
var is_paused: bool = false

# Signal for region selection
signal selected_region_changed(new_region: String)

# Selected region property
var _selected_region: String = ""
var selected_region: String:
	get:
		return _selected_region
	set(value):
		_selected_region = value
		emit_signal("selected_region_changed", value)

# Initialization flag
var is_initialized: bool = false

func reset_game():
	money = 25000
	angkots.clear()
	drivers.clear()
	regions.clear()
	terminals.clear()

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

	drivers.append(driver1)
	drivers.append(driver2)
	drivers.append(driver3)

	# Create angkots
	var a1 = Angkot.new()
	a1.name = "Angkot"
	a1.speed = 40
	a1.capacity = 6
	a1.income_per_passenger = 5  # 5000 rupiah per passenger
	a1.image_path = "res://assets/Angkot.png"
	a1.driver = driver1

	var a2 = Angkot.new()
	a2.name = "Angkot"
	a2.speed = 40
	a2.capacity = 6
	a2.income_per_passenger = 5  # 5000 rupiah per passenger
	a2.image_path = "res://assets/Angkot.png"
	a2.driver = driver2

	driver1.is_assigned = true
	driver2.is_assigned = true
	angkots.append(a1)
	angkots.append(a2)

	# Create regions
	var jakbar = Region.new()
	jakbar.name = "Jakarta Barat"
	jakbar.short_name = "jakbar"
	jakbar.population_density = 1.2
	jakbar.traffic_level = 1.5
	jakbar.economic_activity = 1.1
	jakbar.is_locked = false
	jakbar.price = 0

	var jakpus = Region.new()
	jakpus.name = "Jakarta Pusat"
	jakpus.short_name = "jakpus"
	jakpus.population_density = 1.5
	jakpus.traffic_level = 1.2
	jakpus.economic_activity = 1.3
	jakpus.is_locked = true
	jakpus.price = 20000

	var jakut = Region.new()
	jakut.name = "Jakarta Utara"
	jakut.short_name = "jakut"
	jakut.population_density = 1.1
	jakut.traffic_level = 1.3
	jakut.economic_activity = 1.0
	jakut.is_locked = true
	jakut.price = 15000

	var jaksel = Region.new()
	jaksel.name = "Jakarta Selatan"
	jaksel.short_name = "jaksel"
	jaksel.population_density = 1.3
	jaksel.traffic_level = 1.4
	jaksel.economic_activity = 1.2
	jaksel.is_locked = true
	jaksel.price = 18000

	var jaktim = Region.new()
	jaktim.name = "Jakarta Timur"
	jaktim.short_name = "jaktim"
	jaktim.population_density = 1.4
	jaktim.traffic_level = 1.6
	jaktim.economic_activity = 1.1
	jaktim.is_locked = false
	jaktim.price = 18000

	regions = {
		"jakbar": jakbar,
		"jakpus": jakpus,
		"jakut": jakut,
		"jaksel": jaksel,
		"jaktim": jaktim
	}

	# Assign angkots to Jakarta Barat
	a1.current_region = regions["jakbar"]
	a2.current_region = regions["jakbar"]
	a1.is_operating = true
	a2.is_operating = true

	# Create terminals
	var terminal_jakbar = Terminal.new()
	terminal_jakbar.name = "Terminal Jakarta Barat"
	terminal_jakbar.region = regions["jakbar"]

	terminals = {
		"jakbar": terminal_jakbar
	}

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
