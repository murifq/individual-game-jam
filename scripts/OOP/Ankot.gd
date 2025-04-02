# scripts/Angkot.gd
extends Resource
class_name Angkot

var name: String
var speed: float
var capacity: int
var income_per_passenger: int
var upgrade_level: int = 1
var image_path: String

func upgrade():
	upgrade_level += 1
	if(speed < 60):
		speed += 5
	capacity += 1
	income_per_passenger += 500
