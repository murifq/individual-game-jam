extends Resource
class_name Driver

var name: String
var fee: int  # Fee per operation (in thousands of rupiah)
var skill: float  # Skill level (affects income positively, range: 0.8 to 1.2)
var maintenance_effect: float  # Maintenance effect (affects condition negatively, range: 0.8 to 1.2)
var is_assigned: bool = false  # Tracks if the driver is assigned to an Angkot

func calculate_effect_on_income(base_income: int) -> int:
	# Adjust income based on driver's skill
	return int(base_income * skill)

func calculate_effect_on_condition(base_condition_loss: float) -> float:
	# Adjust condition loss based on driver's maintenance effect
	return base_condition_loss * maintenance_effect

func update(name: String, fee: int, skill: float, maintenance_effect: float) -> Driver:
	self.name = name
	self.fee = fee
	self.skill = skill
	self.maintenance_effect = maintenance_effect
	self.is_assigned = false
	return self
