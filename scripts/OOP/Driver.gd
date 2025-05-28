extends Resource
class_name Driver

var name: String
var fee: int  # Fee per operation (in thousands of rupiah)
var skill: float  # Skill level (affects income positively, range: 0.8 to 1.2)
var maintenance_effect: float  # Maintenance effect (affects condition negatively, range: 0.8 to 1.2)
var is_assigned: bool = false  # Tracks if the driver is assigned to an Angkot
var angkot: Angkot = null

# List of possible driver names
const INDONESIAN_NAMES = [
	"Budi", "Joko", "Agus", "Rudi", "Andi", "Sugi", "Dedi", "Slamet", "Eko", "Teguh",
	"Adi", "Yudi", "Fajar", "Ilham", "Rian", "Bayu", "Rizky", "Dian", "Arif", "Wahyu",
	"Hendra", "Imam", "Rizal", "Yusuf", "Febri", "Bagus", "Reza", "Iqbal", "Taufik", "Putra",
	"Dimas", "Alif", "Gilang", "Adit", "Farhan", "Robby", "Fikri", "Nur", "Nanda", "Yoga",
	"Vino", "Kevin", "Dhani", "Rama", "Zaki", "Galih", "Raka", "Rian", "Fauzi", "Rahmat",
	"Satria", "Andre", "Wawan", "Irfan", "Oka", "Bima", "Johan", "Farel", "Ivan", "Tomy",
	"Ridho", "Ari", "Rino", "Hasan", "Gerry", "Robby", "Syahrul", "Ikhsan", "Niko", "Asep",
	"Lutfi", "Rayhan", "Jamal", "Rio", "Donny", "Harun", "Reihan", "Zul", "Haris", "Rendy",
	"Amir", "Salman", "Toni", "Hadi", "Maulana", "Bambang", "Dany", "Fadhil", "Rifan", "Fikri",
	"Siska", "Dewi", "Sari", "Ayu", "Rina", "Intan", "Putri", "Wulan", "Rani", "Citra",
	"Lia", "Desi", "Nina", "Melati", "Indah", "Anisa", "Dina", "Fitri", "Nia", "Yuni",
	"Tika", "Maya", "Dwi", "Rosa", "Lina", "Mega", "Tiara", "Vina", "Aulia", "Fani",
	"Aisyah", "Sekar", "Rahma", "Nadya", "Hana", "Nurul", "Dela", "Nadia", "Astri", "Ika",
	"Ainun", "Fitria", "Kartika", "Dina", "Mira", "Vivi", "Dea", "Elisa", "Anggi", "Laras",
	"Sinta", "Erni", "Yeni", "Suci", "Silvi", "Lesti", "Rika", "Yuliana", "Murni", "Sania",
	"Gita", "Vera", "Bella", "Monica", "Almira", "Cindy", "Feby", "Kirana", "Shinta", "Tasya",
	"Meisya", "Zahra", "Farah", "Syifa", "Nabila", "Sheila", "Andien", "Alika", "Carissa", "Tasya",
	"Amel", "Aveline", "Gracia", "Marsha", "Felicia", "Nayla", "Clarissa", "Hilda", "Inez", "Raisa",
	"Velia", "Dania", "Jasmine", "Nasywa", "Kayla", "Maura", "Nadira", "Tania", "Adinda", "Yasmin",
	"Elvina", "Ziva", "Nurin", "Tasya", "Putra", "Putri", "Indra", "Lukman", "Setiawan", "Prasetyo",
	"Saputra", "Santoso", "Susanto", "Suryadi", "Gunawan", "Wijaya", "Kusuma", "Nuraini", "Utami", "Yuliani"
]

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

# Function to generate a driver with randomized fields
static func generate_random_driver() -> Driver:
	var new_driver = Driver.new()
	new_driver.name = INDONESIAN_NAMES[randi() % INDONESIAN_NAMES.size()]  # Random name from the list
	new_driver.fee = randi_range(3, 10)  # Random fee between 3000 and 10000 rupiah
	new_driver.skill = randf_range(0.8, 1.2)  # Random skill between 0.8 and 1.2
	new_driver.maintenance_effect = randf_range(0.8, 1.2)  # Random maintenance effect between 0.8 and 1.2
	new_driver.is_assigned = false
	return new_driver
