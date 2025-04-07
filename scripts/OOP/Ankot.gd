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
var driver: Driver = null  # Driver assigned to this angkot
var current_region: Region = null  # Region where the Angkot is operating

func operate():
	if driver == null:
		print("%s cannot operate without a driver!" % name)
		return
	if current_region == null:
		print("%s cannot operate without a region!" % name)
		return

	# Simulate passenger occupancy (e.g., 50% to 100% of capacity)
	var occupancy_rate = randf() * 0.5 + 0.5  # Random value between 0.5 and 1.0
	var actual_passengers = int(capacity * occupancy_rate * current_region.population_density)

	# Calculate base income and adjust it based on the region's economic activity
	var base_income = actual_passengers * income_per_passenger
	var adjusted_income = base_income * current_region.calculate_income_modifier()
	Global.money += adjusted_income

	# Deduct the driver's fee
	Global.money -= driver.fee

	# Increase operation time and decrease condition
	operation_time += 1
	var base_condition_loss = 0.5  # Base condition loss per operation
	var adjusted_condition_loss = driver.calculate_effect_on_condition(base_condition_loss)
	condition -= adjusted_condition_loss

	# Check if the angkot needs repair
	if condition <= 0:
		condition = 0
		print("%s needs repair!" % name)

func repair():
	# Repair the angkot and restore its condition
	condition = 100.0
	print("%s has been repaired!" % name)

func calculate_sell_price() -> int:
	# Base price is determined by capacity and income per passenger
	var base_price = 80000  # Base price in thousands (80 million rupiah)
	# Reduce price based on operation time (e.g., 1% per 10 operation time)
	var depreciation = operation_time / 10 * 0.01
	return int(base_price * (1 - depreciation))
