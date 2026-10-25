extends Node

signal bought(id: String)

# +60% each upgrade leve
const COST_GROWTH := 1.6

#all upgrades
const ALL := {
	"oxygen_tank": {
		"name": "oxygen tank",
		"desc": "+15s of air",
		"cost": 50,
		"max_level": 5,
		"default": 60.0,
		"per_upgrade": 15.0,
 },
	"0": {
		"name": "0",
		"desc": "+15% faster mining speed",
		"cost": 50,
		"max_level": 5,
		"default": 1.0,
		"per_upgrade": 0.25,
},
	"1": {
		"name": "1",
		"desc": "+10% faster speed",
		"cost": 0,
		"max_level": 0,
		"default": 1.0,
		"per_upgrade": 0,
}, "2": {
		"name": "2",
		"desc": "+10% oxygen capacity",
		"cost": 0,
		"max_level": 0,
		"default": 1.0,
		"per_upgrade": 0
}, "3": {
		"name": "3",
		"desc": "+3 material slots",
		"cost": 0,
		"max_level": 0,
		"default": 1.0,
		"per_upgrade": 0
}, "4": {
		"name": "4",
		"desc": "10% chance for +1 drop",
		"cost": 0,
		"max_level": 0,
		"default": 1.0,
		"per_upgrade": 0
}, "5": {
		"name": "5",
		"desc": "When bought, the current deadline will extend by 1 day. This item will never appear afterwards.",
		"cost": 0,
		"max_level": 0,
		"default": 1.0,
		"per_upgrade": 0
}, "6": {
		"name": "6",
		"desc": "for each amethyst +0.5 seconds of oxygen",
		"cost": 0,
		"max_level": 0,
		"default": 1.0,
		"per_upgrade": 0
} , "7": {
		"name": "7",
		"desc": "for each amethyst mined +0.2 mining speed",
		"cost": 0,
		"max_level": 0,
		"default": 1.0,
		"per_upgrade": 0
}, "8": {
		"name": "8",
		"desc": "for each amethyst mined +0.2 movement speed",
		"cost": 0,
		"max_level": 0,
		"default": 1.0,
		"per_upgrade": 0
}, "9": {
		"name": "9",
		"desc": "12.5% chance for +1 drop",
		"cost": 0,
		"max_level": 0,
		"default": 1.0,
		"per_upgrade": 0}
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
