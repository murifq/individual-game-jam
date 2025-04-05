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
	var income = capacity * income_per_passenger / 10
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
	print("%s has been repaired!" % name)
