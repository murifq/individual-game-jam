extends Resource
class_name Region

# Region properties
var name: String
var short_name : String
var population_density: float = 1.0  # Multiplier for passenger count
var traffic_level: float = 1.0       # Multiplier for travel time
var economic_activity: float = 1.0   # Multiplier for income per passenger
var is_locked: bool = true           # Whether the region is locked
var price: int = 10000               # Price to unlock the region
var locked_color: Color = Color(0.5, 0.5, 0.5, 1)  # Default color for locked regions
var unlocked_color: Color = Color(0.8, 0.8, 0.8, 1)  # Default color for unlocked regions

# Get the current color based on the lock status
func get_color() -> Color:
	return locked_color if is_locked else unlocked_color

# Calculate the income modifier based on region stats
func calculate_income_modifier() -> float:
	return population_density * economic_activity

# Calculate the time modifier based on traffic level
func calculate_time_modifier() -> float:
	return traffic_level
