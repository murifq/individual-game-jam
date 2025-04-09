extends Resource
class_name Angkot

# Properties
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
var is_operating: bool = false  # Whether the angkot is currently operating
var fuel_cost_per_operation: int = 15  # Operational cost (e.g., fuel cost)
var base_price = 20100

# Upgrade pricing and income increase for each level
const UPGRADE_DATA = [
	{ "price": 1000, "income_increase": 2 },  # Level 1 -> 2
	{ "price": 10000, "income_increase": 3 },  # Level 2 -> 3
	{ "price": 25000, "income_increase": 4 },  # Level 3 -> 4
	{ "price": 40000, "income_increase": 5 },  # Level 4 -> 5
	{ "price": 80000, "income_increase": 6 },  # Level 5 -> 6
]

# Simulate operation and calculate income
func operate(current_hour: int):
	if driver == null:
		print("%s cannot operate without a driver!" % name)
		return
	if current_region == null:
		print("%s cannot operate without a region!" % name)
		return
	if not is_operating:
		print("%s is not operating!" % name)
		return

	# Determine if it's a busy hour (morning or evening rush hours)
	var is_busy_hour = (current_hour >= 6 and current_hour <= 9) or (current_hour >= 16 and current_hour <= 19)

	# Simulate passenger occupancy (e.g., 50% to 100% of capacity)
	var occupancy_rate = randf() * 0.5 + 0.5  # Random value between 0.5 and 1.0
	var actual_passengers = int(capacity * occupancy_rate * current_region.population_density)

	# Calculate base income and adjust it based on the region's economic activity
	var base_income = actual_passengers * income_per_passenger
	var adjusted_income = base_income * current_region.economic_activity

	# Apply income adjustment based on busy or non-busy hours
	if is_busy_hour:
		adjusted_income *= 1.5  # 50% more income during busy hours
	else:
		adjusted_income *= randf()  # Random value between 0 and 1 during non-busy hours

	# Deduct operational costs (e.g., fuel cost)
	var operational_cost = fuel_cost_per_operation
	Global.money += adjusted_income - operational_cost

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

# Upgrade the angkot to the next level
func upgrade() -> String:
	if upgrade_level >= UPGRADE_DATA.size():
		return ("%s is already at the maximum level!" % name)
		#return false

	var next_upgrade = UPGRADE_DATA[upgrade_level - 1]  # Get the data for the next level
	if Global.money >= next_upgrade["price"]:
		Global.money -= next_upgrade["price"]  # Deduct the upgrade price
		upgrade_level += 1
		income_per_passenger += next_upgrade["income_increase"]  # Increase income per passenger
		return ("%s upgraded to level %d! New income per passenger: %d" % [name, upgrade_level, income_per_passenger])
		#return true
	else:
		return ("Not enough money to upgrade %s!" % name)
		#return false

# Get upgrade information without applying the upgrade
func upgrade_info() -> Angkot:
	if upgrade_level >= UPGRADE_DATA.size():
		print("%s is already at the maximum level!" % name)
		return null

	var next_upgrade = UPGRADE_DATA[upgrade_level - 1]  # Get the data for the next level
	var upgraded_angkot = Angkot.new()
	upgraded_angkot.name = name
	upgraded_angkot.speed = speed
	upgraded_angkot.capacity = capacity
	upgraded_angkot.income_per_passenger = income_per_passenger + next_upgrade["income_increase"]
	upgraded_angkot.upgrade_level = upgrade_level + 1
	upgraded_angkot.image_path = image_path
	upgraded_angkot.operation_time = operation_time
	upgraded_angkot.condition = condition
	upgraded_angkot.driver = driver
	upgraded_angkot.current_region = current_region
	upgraded_angkot.is_operating = is_operating
	upgraded_angkot.fuel_cost_per_operation = fuel_cost_per_operation
	upgraded_angkot.base_price = base_price
	return upgraded_angkot

# Start the angkot operation
func start_operate() -> void:
	if is_operating:
		print("%s is already operating!" % name)
		return
	is_operating = true
	print("%s has started operating." % name)

# Stop the angkot from operating
func stop_operate() -> void:
	if not is_operating:
		print("%s is already stopped!" % name)
		return
	is_operating = false
	print("%s has stopped operating." % name)

# Repair the angkot
func repair():
	# Repair the angkot and restore its condition
	condition = 100.0
	print("%s has been repaired!" % name)

# Calculate the sell price of the angkot
func calculate_sell_price() -> int:
	# Base price is determined by capacity and income per passenger
	# Reduce price based on operation time (e.g., 1% per 10 operation time)
	var depreciation = operation_time / 10 * 0.0001
	if int(base_price * (1 - depreciation)) < 20000:
		return 20000
	return int(base_price * (1 - depreciation))
