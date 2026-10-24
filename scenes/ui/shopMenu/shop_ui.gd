extends Control

@export var itemScene:PackedScene
@onready var buy: PanelContainer = $Pages/Buy
@onready var sell: PanelContainer = $Pages/Sell
@export var item_list: VBoxContainer
@export var sell_value: Label 
@export var Sell_All: AnimatedButton 

const SELL_AMOUNT := {
	"rock": 1,
	"gold": 10,
	"ruby": 16,
	"amethyst": 6,
}

func _ready() -> void:
	Sell_All.pressed.connect(sellAll)

func _on_buy_pressed() -> void:
	sell.hide()
	buy.show()


func _on_sell_pressed() -> void:
	sell.show()
	buy.hide()
	
	for item in Inventory.items:
		var itemObj:ItemObjUI= itemScene.instantiate()
		itemObj.itemCount = Inventory.items[item]
		itemObj.itemName = str(item)
		itemObj.sellAmount = SELL_AMOUNT[item]
		item_list.add_child(itemObj)
		
func sellAll() -> void:
	var sellValue:int
	for item in Inventory.items:
		sellValue += SELL_AMOUNT[item] * Inventory.items[item]
	Global.cash += sellValue
		
