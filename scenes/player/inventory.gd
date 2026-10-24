extends Node

#tells ui when something changes
signal changed(item: String, amount: int)

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
