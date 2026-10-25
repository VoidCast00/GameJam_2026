extends Node

signal bought(id: String)

# +60% each upgrade leve
const COST_GROWTH := 1.6

#all upgrades
const ALL := {
	"oxygen_tank": {
		"name": "xygen tank",
		"desc": "+15s of air",
		"cost": 50,
		"max_level": 5,
		"default": 60.0,
		"per_upgrade": 15.0,
 },
	"mining_speed": {
		"name": "laser",
		"desc": "+25% faster minors",
		"cost": 50,
		"max_level": 5,
		"default": 1.0,
		"per_upgrade": 0.25,}
}

var upgradeItems := {}


#current value of an upgrade
func value(id: String) -> float:
	var data: Dictionary = ALL[id]
	return data["base"] + data["per_level"] * get_level(id)


func get_level(id: String) -> int:
	return upgradeItems.get(id, 0)


func get_cost(id: String) -> int:
	return int(ALL[id]["cost"] * pow(COST_GROWTH, get_level(id)))


func is_maxed(id: String) -> bool:
	return get_level(id) >= ALL[id]["max_level"]


func can_buy(id: String) -> bool:
	return not is_maxed(id) and Inventory.cash >= get_cost(id)


#
func buy(id: String) -> bool:
	if not can_buy(id):
		return false

	Global.cash -= get_cost(id)
	upgradeItems[id] = get_level(id) + 1
	bought.emit(id)
	return true
