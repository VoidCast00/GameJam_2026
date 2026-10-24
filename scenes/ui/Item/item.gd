class_name ItemObjUI
extends PanelContainer

var itemName:String;
var itemCount:int
var sellAmount:float;
@onready var sellButton: AnimatedButton = $HBox/Sell

func _ready() -> void:
	sellButton.pressed.connect(sell)
	$HBox/ItemName.text = str(itemName)
	$HBox/Count.text = str(itemCount)

func sell() -> void:
	Global.cash += itemCount * sellAmount;
	Inventory.remove(itemName,itemCount)
	self.queue_free()
	return
