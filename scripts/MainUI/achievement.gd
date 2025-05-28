extends ColorRect

@onready var achievement_list_container = $MarginContainer/ScrollContainer/VBoxContainer
@onready var achievement_item_template = $MarginContainer/ScrollContainer/VBoxContainer/AchievementItem
@onready var back_button: Button = $VBoxContainer/HBoxContainer2/BackButton
@onready var label_total_achievements: Label = $VBoxContainer/HBoxContainer2/LabelTotalAchievements

func _ready():
	# Hide the template node
	achievement_item_template.visible = false
	
	# Populate the achievement list
	populate_achievement_list()
	
	# Connect the back button
	back_button.pressed.connect(self._on_back_button_pressed)

func populate_achievement_list():
	# Clear existing items except the template
	for child in achievement_list_container.get_children():
		if child != achievement_item_template:
			child.queue_free()
	achievement_item_template.visible = false

	# Count achieved achievements
	var achieved_count = 0
	for achievement in Global.achievements:
		if achievement.is_achieved:
			achieved_count += 1
	
	# Update the total achievements label
	label_total_achievements.text = "Total pencapaian: %d/%d" % [achieved_count, Global.achievements.size()]

	# Add each achievement to the list
	for achievement in Global.achievements:
		var achievement_item = achievement_item_template.duplicate()
		achievement_item.visible = true
		
		var label_name = achievement_item.get_node("LabelContainer/LabelName")
		var check_box = achievement_item.get_node("CheckBoxContainer/CheckBox")
		
		# Set achievement details
		label_name.text = achievement.name
		check_box.button_pressed = achievement.is_achieved
		check_box.disabled = true  # Disable the checkbox to make it read-only
		
		# Add the achievement item to the list
		achievement_list_container.add_child(achievement_item)

func _on_back_button_pressed():
	# Change back to the MainUI scene
	get_tree().change_scene_to_file("res://scenes/MainUI/SelectMap.tscn")
