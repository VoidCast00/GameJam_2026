extends  Node

signal changed(item: String, amount: int)


var cash:int = 100:
	set(new_val):
		cash = clamp(new_val, 0, INT64_MAX)
		
const BASE_OXYGEN := 60.0
const BASE_CAPACITY := 20
#these dont take inventory space
const FREE_ITEMS := ["rock"]

#calculated every time you read it, so upgrades apply instantly
var oxygenTankSize: float:
	get:
		return BASE_OXYGEN * Upgrades.oxygen_multiplier()

var capacity: int:
	get:
		return BASE_CAPACITY + Upgrades.extra_slots()

var oxygen: float:  #in seconds (filled in _ready)
	set(new_val):
		var was_empty := oxygen <= 0.0
		oxygen = clampf(new_val, 0.0, oxygenTankSize)
		#only once
		if oxygen <= 0.0 and not was_empty:
			Global.oxygenDepleted.emit()


#item name -> amount
var items: Dictionary = {}

func _ready() -> void:
	Global.mined.connect(add)
	#here and not above, Upgrades doesnt exist yet when variables are created
	oxygen = oxygenTankSize

#add (only what fits)
func add(item: String, amount: int = 1) -> void:
	if item not in FREE_ITEMS:
		amount = mini(amount, space_left())
		if amount <= 0:
			return

	items[item] = get_amount(item) + amount
	changed.emit(item, items[item])


#remove (returns false if not enough)
func remove(item: String, amount: int = 1) -> bool:
	if not has(item, amount):
		return false

	items[item] -= amount
	if items[item] <= 0:
		items.erase(item)

	changed.emit(item, get_amount(item))
	return true


#check
func has(item: String, amount: int = 1) -> bool:
	return get_amount(item) >= amount


#get amount
func get_amount(item: String) -> int:
	return items.get(item, 0)


#space
func used_space() -> int:
	var used := 0
	for item in items:
		if item not in FREE_ITEMS:
			used += items[item]
	return used


func space_left() -> int:
	return capacity - used_space()
