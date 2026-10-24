extends Control

@export var itemScene:PackedScene
@onready var buy: PanelContainer = $Pages/Buy
@onready var sell: PanelContainer = $Pages/Sell


#Sell==============================


func _on_buy_pressed() -> void:
	sell.hide()
	buy.show()


func _on_sell_pressed() -> void:
	sell.show()
	buy.hide()
	
	for item in Inventory.items:
		var itemObj:= itemScene.instantiate()
