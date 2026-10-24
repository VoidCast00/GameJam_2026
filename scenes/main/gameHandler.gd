extends Node

@onready var game: Node2D = $".."
@export var WaterEnviroment: PackedScene
@export var ShopEnviroment: PackedScene
@export var menu:CanvasLayer
#current environment
var current_env: Node = null


func _ready() -> void:
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
	

#switch environment
func load_env(scene: PackedScene) -> void:
	if not scene:
		push_error("no environment scene")
		return

	#remove old
	if current_env:
		current_env.queue_free()

	#add new
	print("loading")
	current_env = scene.instantiate()
	game.add_child.call_deferred(current_env)
