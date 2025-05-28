extends Resource
class_name Achievement

# Properties
var name: String  # Name of the achievement
var is_achieved: bool = false  # Whether the achievement has been achieved

# Constructor
func _init(name: String):
	self.name = name
	self.is_achieved = false

# Mark the achievement as achieved
func achieve():
	if not is_achieved:
		is_achieved = true
		print("Achievement unlocked: %s" % name)
