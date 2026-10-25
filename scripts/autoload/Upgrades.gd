extends Node

signal bought(id: String)

# +60% each upgrade level
const COST_GROWTH := 1.6

#gold needed for MineGold_InventoryCap to give slots
const GOLD_PER_SLOT := 50

#all upgrades
#id = Trigger_Effect   (None = always on)
#value = default + per_upgrade * level
#not bought (level 0) -> value is "default", so the upgrade does nothing
#once = hide from the shop after buying
const ALL := {
	#--- always on ---
	"None_Mining": {
		"name": "Sharper Drill",
		"desc": "+15% mining speed per level.",
		"cost": 40,
		"max_level": 5,
		"default": 1.0,  #multiplier
		"per_upgrade": 0.15,
	},
	"None_Speed": {
		"name": "Stronger Engine",
		"desc": "+10% movement speed per level.",
		"cost": 40,
		"max_level": 5,
		"default": 1.0,  #multiplier
		"per_upgrade": 0.1,
	},
	"None_Oxygen": {
		"name": "Bigger Tank",
		"desc": "+10% oxygen capacity per level.",
		"cost": 50,
		"max_level": 5,
		"default": 1.0,  #multiplier
		"per_upgrade": 0.1,
	},
	"None_InventoryCap": {
		"name": "Cargo Bay",
		"desc": "+3 material slots per level.",
		"cost": 60,
		"max_level": 5,
		"default": 0.0,  #extra slots
		"per_upgrade": 3.0,
	},
	"None_Fortune": {
		"name": "Lucky Laser",
		"desc": "Every time you mine, +10% chance per level for +1 drop.",
		"cost": 75,
		"max_level": 3,
		"default": 0.0,  #chance
		"per_upgrade": 0.1,
	},
	"None_DeadLine": {
		"name": "Extension",
		"desc": "When bought, the current deadline will extend by 1 day. This item will never appear afterwards.",
		"cost": 150,
		"max_level": 1,
		"default": 0.0,  #days
		"per_upgrade": 1.0,
		"once": true,
	},

	#--- mine amethyst ---
	"MineAmethyst_Oxygen": {
		"name": "Amethyst Breather",
		"desc": "Every time you mine an Amethyst, +0.5 seconds of oxygen per level.",
		"cost": 60,
		"max_level": 3,
		"default": 0.0,  #seconds
		"per_upgrade": 0.5,
	},
	"MineAmethyst_Mining": {
		"name": "Amethyst Focus",
		"desc": "For each Amethyst mined during the current dive, +0.2 mining speed per level.",
		"cost": 80,
		"max_level": 3,
		"default": 0.0,  #per amethyst
		"per_upgrade": 0.2,
	},
	"MineAmethyst_Speed": {
		"name": "Amethyst Rush",
		"desc": "For each Amethyst mined during the current dive, +0.2 movement speed per level.",
		"cost": 80,
		"max_level": 3,
		"default": 0.0,  #per amethyst
		"per_upgrade": 0.2,
	},
	"MineAmethyst_Fortune": {
		"name": "Amethyst Luck",
		"desc": "Every time you mine an Amethyst, +12.5% chance per level for +1 drop.",
		"cost": 70,
		"max_level": 3,
		"default": 0.0,  #chance
		"per_upgrade": 0.125,
	},
	"MineAmethyst_Money": {
		"name": "Amethyst Tax",
		"desc": "Every time you mine an Amethyst, +2 money per level.",
		"cost": 70,
		"max_level": 3,
		"default": 0.0,  #money
		"per_upgrade": 2.0,
	},

	#--- mine gold ---
	"MineGold_Mining": {
		"name": "Gold Focus",
		"desc": "For each Gold mined during the current dive, +0.35 mining speed per level.",
		"cost": 120,
		"max_level": 3,
		"default": 0.0,  #per gold
		"per_upgrade": 0.35,
	},
	"MineGold_Speed": {
		"name": "Gold Rush",
		"desc": "For each Gold mined during the current dive, +0.35 movement speed per level.",
		"cost": 120,
		"max_level": 3,
		"default": 0.0,  #per gold
		"per_upgrade": 0.35,
	},
	"MineGold_Oxygen": {
		"name": "Gold Breather",
		"desc": "Every time you mine a Gold ore, +2 seconds of oxygen per level.",
		"cost": 100,
		"max_level": 3,
		"default": 0.0,  #seconds
		"per_upgrade": 2.0,
	},
	"MineGold_InventoryCap": {
		"name": "Gold Hoarder",
		"desc": "Every 50 Gold ores mined, +1 permanent Inventory Space per level.",
		"cost": 100,
		"max_level": 3,
		"default": 0.0,  #slots per 50 gold
		"per_upgrade": 1.0,
	},
	"MineGold_Fortune": {
		"name": "Gold Luck",
		"desc": "Every time you mine a Gold Ore, +7.5% chance per level for +2 drop.",
		"cost": 130,
		"max_level": 3,
		"default": 0.0,  #chance
		"per_upgrade": 0.075,
	},
}


#id -> level
var upgradeItems := {}

#material -> amount mined this dive (reset every dive)
var dive_mined := {}

#MineGold_InventoryCap progress
var gold_for_slots := 0
var bonus_slots := 0


func _ready() -> void:
	Global.mined.connect(_on_mined)
	Global.loadWaterEnviroment.connect(_on_dive_start)


#current value of an upgrade
func value(id: String) -> float:
	var data: Dictionary = ALL[id]
	return data["default"] + data["per_upgrade"] * get_level(id)


func get_level(id: String) -> int:
	return upgradeItems.get(id, 0)


func get_cost(id: String) -> int:
	return int(ALL[id]["cost"] * pow(COST_GROWTH, get_level(id)))


func is_maxed(id: String) -> bool:
	return get_level(id) >= ALL[id]["max_level"]


func can_buy(id: String) -> bool:
	return not is_maxed(id) and Inventory.cash >= get_cost(id)


func buy(id: String) -> bool:
	if not can_buy(id):
		return false

	Inventory.cash -= get_cost(id)
	upgradeItems[id] = get_level(id) + 1

	#instant effects
	match id:
		"None_DeadLine":
			Global.deadline += 1

	bought.emit(id)
	return true


#stats (everything that changes a stat is added up here)
func mining_speed() -> float:
	return value("None_Mining") \
		+ dive_mined.get("amethyst", 0) * value("MineAmethyst_Mining") \
		+ dive_mined.get("gold", 0) * value("MineGold_Mining")


func move_speed() -> float:
	return value("None_Speed") \
		+ dive_mined.get("amethyst", 0) * value("MineAmethyst_Speed") \
		+ dive_mined.get("gold", 0) * value("MineGold_Speed")


func oxygen_multiplier() -> float:
	return value("None_Oxygen")


func extra_slots() -> int:
	return int(value("None_InventoryCap")) + bonus_slots


#triggers
func _on_dive_start() -> void:
	dive_mined.clear()


func _on_mined(type: String) -> void:
	dive_mined[type] = dive_mined.get(type, 0) + 1

	_roll_drop(type, "None_Fortune", 1)

	match type:
		"amethyst":
			Inventory.oxygen += value("MineAmethyst_Oxygen")
			Inventory.cash += int(value("MineAmethyst_Money"))
			_roll_drop(type, "MineAmethyst_Fortune", 1)
		"gold":
			Inventory.oxygen += value("MineGold_Oxygen")
			_roll_drop(type, "MineGold_Fortune", 2)
			_count_gold_for_slots()


#chance for extra drops
func _roll_drop(type: String, id: String, amount: int) -> void:
	if randf() < value(id):
		#add directly, emitting Global.mined again would trigger all upgrades again
		Inventory.add(type, amount)


func _count_gold_for_slots() -> void:
	if get_level("MineGold_InventoryCap") == 0:
		return
	gold_for_slots += 1
	if gold_for_slots >= GOLD_PER_SLOT:
		gold_for_slots = 0
		bonus_slots += int(value("MineGold_InventoryCap"))
