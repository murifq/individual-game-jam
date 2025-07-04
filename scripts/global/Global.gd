extends Node

# Global variables
var money: int = 80000
var angkots: Array[Angkot] = []
var drivers: Array[Driver] = []
var regions: Dictionary = {}  # Dictionary to store all regions
var terminals: Dictionary = {}  # Dictionary to store all terminals
var selected_angkot: Angkot = null
var achievements: Array[Achievement] = []

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

# Function to create a new Angkot with default values
func create_new_angkot(name: String = "Angkot", speed: int = 40, capacity: int = 6, income_per_passenger: int = 5, image_path: String = "res://assets/Angkot.png", driver: Driver = null) -> Angkot:
	var new_angkot = Angkot.new()
	Global.money = Global.money - 80000
	new_angkot.name = name
	new_angkot.speed = speed
	new_angkot.capacity = capacity
	new_angkot.income_per_passenger = income_per_passenger
	new_angkot.image_path = image_path
	new_angkot.driver = driver
	if driver:
		driver.is_assigned = true
	return new_angkot

# Function to create a new Terminal with default values
func create_new_terminal(region: Region) -> Terminal:
	var new_terminal = Terminal.new()
	new_terminal.name = "Terminal " + region.name
	new_terminal.region = region
	return new_terminal

func reset_game():
	money = 80000
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
	driver1.name = "Budi"
	driver1.fee = 5  # 5000 rupiah per operation
	driver1.skill = 1.0  # Neutral skill
	driver1.maintenance_effect = 1.0  # Neutral maintenance effect
	driver1.is_assigned = true

	var driver2 = Driver.new()
	driver2.name = "Joko"
	driver2.fee = 3  # 3000 rupiah per operation
	driver2.skill = 0.9  # Slightly lower skill
	driver2.maintenance_effect = 1.2  # Higher maintenance effect (worse for condition)
	driver2.is_assigned = true
	
	var driver3 = Driver.new()
	driver3.name = "Pak Agus"
	driver3.fee = 4  # 4000 rupiah per operation
	driver3.skill = 1.1  # Slightly higher skill
	driver3.maintenance_effect = 0.8  # Lower maintenance effect (better for condition)

	drivers.append(driver1)
	drivers.append(driver2)
	drivers.append(driver3)

	# Create regions
	var jakbar = Region.new()
	jakbar.name = "Jakarta Barat"
	jakbar.short_name = "jakbar"
	jakbar.population_density = 1.2
	jakbar.economic_activity = 1.1
	jakbar.is_locked = false
	jakbar.price = 180000

	var jakpus = Region.new()
	jakpus.name = "Jakarta Pusat"
	jakpus.short_name = "jakpus"
	jakpus.population_density = 1.5
	jakpus.economic_activity = 1.3
	jakpus.is_locked = true
	jakpus.price = 250000

	var jakut = Region.new()
	jakut.name = "Jakarta Utara"
	jakut.short_name = "jakut"
	jakut.population_density = 1.1
	jakut.economic_activity = 1.0
	jakut.is_locked = true
	jakut.price = 150000

	var jaksel = Region.new()
	jaksel.name = "Jakarta Selatan"
	jaksel.short_name = "jaksel"
	jaksel.population_density = 1.3
	jaksel.economic_activity = 1.2
	jaksel.is_locked = true
	jaksel.price = 180000

	var jaktim = Region.new()
	jaktim.name = "Jakarta Timur"
	jaktim.short_name = "jaktim"
	jaktim.population_density = 1.4
	jaktim.economic_activity = 1.1
	jaktim.is_locked = true
	jaktim.price = 180000

	regions = {
		"jakbar": jakbar,
		"jakpus": jakpus,
		"jakut": jakut,
		"jaksel": jaksel,
		"jaktim": jaktim
	}

	# Create angkots using the new function
	var a1 = create_new_angkot()
	a1.driver = driver1
	driver1.angkot = a1
	driver1.is_assigned = true
	var a2 = create_new_angkot()
	a2.driver = driver2
	driver2.angkot = a2
	driver2.is_assigned = true
	
	Global.money = 80000	
	
	angkots.append(a1)
	angkots.append(a2)

	# Assign angkots to Jakarta Barat
	a1.current_region = regions["jakbar"]
	a2.current_region = regions["jakbar"]
	a1.is_operating = true
	a2.is_operating = true

	# Create terminals using the new function
	var terminal_jakbar = create_new_terminal(regions["jakbar"])
	var terminal_jakpus = create_new_terminal(regions["jakpus"])
	var terminal_jakut = create_new_terminal(regions["jakut"])
	var terminal_jaksel = create_new_terminal(regions["jaksel"])
	var terminal_jaktim = create_new_terminal(regions["jaktim"])

	terminals = {
		"jakbar": terminal_jakbar,
		"jakpus": terminal_jakpus,
		"jakut": terminal_jakut,
		"jaksel": terminal_jaksel,
		"jaktim": terminal_jaktim
	}

	is_initialized = true
	
	initialize_achievements()

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


# Function to initialize achievements
# Function to initialize achievements
func initialize_achievements():
	achievements.clear()
	achievements.append(Achievement.new("Mempunyai duit Rp 100,000"))  # Achievement 0
	achievements.append(Achievement.new("Upgrade Terminal menjadi Level 2"))  # Achievement 1
	achievements.append(Achievement.new("Memiliki 3 Angkot"))  # Achievement 2
	achievements.append(Achievement.new("Memiliki 3 Supir"))  # Achievement 3
	achievements.append(Achievement.new("Mengelola Jakarta Pusat"))  # Achievement 4
	achievements.append(Achievement.new("Mempunyai duit Rp 200,000"))  # Achievement 5
	achievements.append(Achievement.new("Upgrade 2 Terminal ke Level 3"))  # Achievement 6

# Function to check and unlock achievements
func check_achievements():
	# Check if the player has earned Rp 80,300
	if money >= 100000 and not achievements[0].is_achieved:
		achievements[0].achieve()

	# Check if a terminal is upgraded to level 2
	for terminal in terminals.values():
		if terminal.level >= 2 and not achievements[1].is_achieved:
			achievements[1].achieve()

	# Check if the player owns 5 angkots
	if angkots.size() >= 3 and not achievements[2].is_achieved:
		achievements[2].achieve()

	# Check if the player has hired 5 drivers
	if drivers.size() >= 3 and not achievements[3].is_achieved:
		achievements[3].achieve()

	# Check if Jakarta Pusat is unlocked
	if "jakpus" in regions and not regions["jakpus"].is_locked and not achievements[4].is_achieved:
		achievements[4].achieve()

	# Check if the player has earned Rp 200,000
	if money >= 200000 and not achievements[5].is_achieved:
		achievements[5].achieve()

	# Check if 2 terminals are upgraded to level 3
	var level_3_terminals = 0
	for terminal in terminals.values():
		if terminal.level >= 3:
			level_3_terminals += 1
	if level_3_terminals >= 2 and not achievements[6].is_achieved:
		achievements[6].achieve()
