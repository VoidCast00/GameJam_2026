extends Control

@export var itemScene:PackedScene
@onready var buy: PanelContainer = $Pages/Buy
@onready var sell: PanelContainer = $Pages/Sell
@export var item_list: VBoxContainer
@export var sell_value: Label 
@export var Sell_All: AnimatedButton 
@export var MoneyParticle:RigidBody2D
const basePosMoneyParticlePos:Vector2 = Vector2(920, 510)
@onready var cashParticleText: Label = $MoneyParticle/Cash
@export var timer: Timer
var money_tween: Tween
@export var buttons: HBoxContainer
@export var back0: AnimatedButton
@export var back1: AnimatedButton
@export var UPGRADE_OBJECT:PackedScene
@export var upgradesList: VBoxContainer

const SELL_AMOUNT := {
	"rock": 1,
	"gold": 10,
	"ruby": 16,
	"amethyst": 6,
}



func _ready() -> void:
	Sell_All.pressed.connect(sellAll)
	back0.pressed.connect(go_back)
	back1.pressed.connect(go_back)
	for id in Upgrades.ALL:
		var upgradeItem:UpgradeObjUI= UPGRADE_OBJECT.instantiate()
		upgradeItem.id = id
		upgradesList.add_child(upgradeItem)
	
func _on_buy_pressed() -> void:
	sell.hide()
	buy.show()
	buttons.hide()




func _on_sell_pressed() -> void:
	sell.show()
	buy.hide()
	buttons.hide()
	for item in Inventory.items:
		var itemObj:ItemObjUI= itemScene.instantiate()
		itemObj.itemCount = Inventory.items[item]
		itemObj.itemName = str(item)
		itemObj.sellAmount = SELL_AMOUNT[item]
		item_list.add_child(itemObj)

func go_back() -> void:
	sell.hide()
	buy.hide()
	buttons.show()
	


func sellAll() -> void:
	buttons.hide()
	var sell_value := 0
	for item in Inventory.items:
		sell_value += SELL_AMOUNT.get(item, 0) * Inventory.items[item]

	#nothing to sell
	if sell_value <= 0:
		return

	Inventory.cash += sell_value
	Inventory.items.clear()

	$Buttons.hide()
	$Pages.hide()
	spawnMoneyParticle(sell_value)


func spawnMoneyParticle(sell_value: int) -> void:
	#reset
	if money_tween:
		money_tween.kill()
	MoneyParticle.show()
	MoneyParticle.position = basePosMoneyParticlePos
	MoneyParticle.scale = Vector2.ZERO
	MoneyParticle.rotation = deg_to_rad(randf_range(-10, 10))
	MoneyParticle.modulate.a = 1.0

	money_tween = create_tween()

	#pop in with overshoot
	money_tween.tween_property(MoneyParticle, "scale", Vector2.ONE, 0.35) \
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	#count up the number
	money_tween.parallel().tween_method(_set_cash_text, 0.0, float(sell_value), 0.7) \
		.set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)

	#float up fast then slow
	money_tween.parallel().tween_property(MoneyParticle, "position:y", basePosMoneyParticlePos.y - 120, 1.2) \
		.set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)

	#wobble back straight
	money_tween.parallel().tween_property(MoneyParticle, "rotation", 0.0, 0.9) \
		.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)

	#fade out and shrink
	money_tween.tween_property(MoneyParticle, "modulate:a", 0.0, 0.4).set_delay(0.3)
	money_tween.parallel().tween_property(MoneyParticle, "scale", Vector2(0.8, 0.8), 0.4)

	#done
	money_tween.tween_callback(MoneyParticle.hide)


func _set_cash_text(value: float) -> void:
	cashParticleText.text = str(value) + "$"
