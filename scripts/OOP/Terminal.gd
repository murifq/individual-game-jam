extends Resource
class_name Terminal

# Properties
var name: String
var region: Region  # The region this terminal belongs to
var level: int = 1  # Current level of the terminal
var capacity: int = 5  # Number of angkots the terminal can hold
var upgrade_price: int = 100_000  # Price to upgrade to the next level
var image_path: String = "res://assets/terminal/TerminalLevel1.png"  # Image path for the terminal

# Upgrade pricing and capacity for each level
const LEVEL_DATA = [
	{ "capacity": 5, "price": 250000 },   # Level 1
	{ "capacity": 10, "price": 500000 },  # Level 2
	{ "capacity": 15, "price": 1000000 },  # Level 3
	{ "capacity": 20, "price": 2000000 }, # Level 4
	{ "capacity": 30, "price": 5000000 }, # Level 5
	{ "capacity": 50, "price": 5000000 }  # Level 6
]

# Upgrade the terminal to the next level
func upgrade() -> bool:
	if level >= LEVEL_DATA.size():
		print("Terminal is already at the maximum level!")
		return false

	var next_level_data = LEVEL_DATA[level]  # Get the data for the next level
	if Global.money >= next_level_data["price"]:
		Global.money -= next_level_data["price"]  # Deduct the upgrade price
		level += 1
		capacity = next_level_data["capacity"]  # Update the capacity
		upgrade_price = LEVEL_DATA[level]["price"] if level < LEVEL_DATA.size() else 0  # Update the next upgrade price
		_update_image_path()  # Update the image path based on the new level
		print("Terminal upgraded to level %d! New capacity: %d" % [level, capacity])
		return true
	else:
		print("Not enough money to upgrade the terminal!")
		return false

# Get the current upgrade price
func get_upgrade_price() -> int:
	return upgrade_price

# Get the current capacity
func get_capacity() -> int:
	return capacity

# Update the image path based on the terminal's level
func _update_image_path():
	image_path = "res://assets/terminal/TerminalLevel%d.png" % level

# Get upgrade information without applying the upgrade
func upgrade_info() -> Terminal:
	if level >= LEVEL_DATA.size():
		print("Terminal is already at the maximum level!")
		return null

	var next_level_data = LEVEL_DATA[level]  # Get the data for the next level
	var upgraded_terminal = Terminal.new()
	upgraded_terminal.name = name
	upgraded_terminal.region = region
	upgraded_terminal.level = level + 1
	upgraded_terminal.capacity = next_level_data["capacity"]
	upgraded_terminal.upgrade_price = LEVEL_DATA[level + 1]["price"] if level + 1 < LEVEL_DATA.size() else 0
	upgraded_terminal.image_path = "res://assets/terminal/TerminalLevel%d.png" % (level + 1)
	return upgraded_terminal
