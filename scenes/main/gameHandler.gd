extends Node


@export var sub_viewport: SubViewport
@export var WaterEnviroment: PackedScene
@export var ShopEnviroment: PackedScene
@export var menu:CanvasLayer
@export var oxygen_gauge: Control 


#current environment
var current_env: Node = null


func _ready() -> void:
	print(INT64_MAX)
	print(oxygen_gauge)
	Global.shop_ui = %ShopUI
	Global.loading_text = %LoadingText
	Global.oxygen_gauge = oxygen_gauge
	Global.loadWaterEnviroment.connect(loadWaterEnviroment)
	Global.loadShopEnviroment.connect(loadShopEnviroment)
	Global.exitGame.connect(exitGame)
	

func loadWaterEnviroment() -> void:
	menu.hide()
	load_env(WaterEnviroment)


func loadShopEnviroment() -> void:
	menu.hide()
	load_env(ShopEnviroment)

func exitGame():
	get_tree().quit()
	



func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):
		menu.visible = not menu.visible


#switch environment
func load_env(scene: PackedScene) -> void:
	if not scene:
		push_error("no environment scene")
		return

	#remove old
	if current_env:
		current_env.queue_free()

	#add new
	current_env = scene.instantiate()
	sub_viewport.add_child.call_deferred(current_env)
