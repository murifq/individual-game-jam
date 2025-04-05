extends Resource
class_name Angkot

var name: String
var speed: float
var capacity: int
var income_per_passenger: int
var upgrade_level: int = 1
var image_path: String
var operation_time: int = 0  # Time the angkot has been operating
var condition: float = 100.0  # Condition percentage (100% = perfect, 0% = broken)

func operate():
	# Generate money based on capacity and income per passenger
	var income = capacity * income_per_passenger
	Global.money += income
	
	# Increase operation time and decrease condition
	operation_time += 1
	condition -= 0.5  # Decrease condition over time
	
	# Check if the angkot needs repair
	if condition <= 0:
		condition = 0
		print("%s needs repair!" % name)

func repair():
	# Repair the angkot and restore its condition
	condition = 100.0
	#Global.money -= 500000
	print("%s has been repaired!" % name)

func calculate_sell_price() -> int:
	# Base price is determined by capacity and income per passenger
	var base_price = capacity * income_per_passenger * 10
	# Reduce price based on operation time (e.g., 1% per 10 operation time)
	var time_depreciation = base_price * (operation_time / 1000.0)
	# Reduce price further based on condition
	var condition_factor = condition / 100.0
	return int(base_price - time_depreciation) * condition_factor
