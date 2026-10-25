extends  Node

signal changed(item: String, amount: int)


var cash:int = 0:
	set(new_val):
		cash = clamp(new_val, 0, INT64_MAX)
		
var oxygenTankSize: float = 300
var oxygen: float = oxygenTankSize:  #in seconds
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
#add
func add(item: String, amount: int = 1) -> void:
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
