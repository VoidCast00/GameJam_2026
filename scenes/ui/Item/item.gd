class_name ItemObjUI
extends PanelContainer

var itemName:String;
var itemCount:int
var sellAmount:float;
var parent:Control
@onready var sellButton: AnimatedButton = $HBox/Sell

func _ready() -> void:
	sellButton.pressed.connect(sell)
	$HBox/ItemName.text = str(itemName)
	$HBox/Count.text = str(itemCount)

func sell() -> void:
	Inventory.cash += itemCount * sellAmount;
	Inventory.remove(itemName,itemCount)
	self.parent.spawnMoneyParticle(itemCount * sellAmount)

	self.queue_free()
	return
