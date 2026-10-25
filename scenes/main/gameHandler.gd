extends Node


@export var sub_viewport: SubViewport
@export var WaterEnviroment: PackedScene
@export var ShopEnviroment: PackedScene
@export var menu:Control
@export var pause:Control
@export var oxygen_gauge: Control 






#current environment
var current_env: Node = null
var is_loading := false

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
	if event.is_action_pressed("esc") and menu.visible:
		pass
	else:
		if event.is_action_pressed("esc"):
			pause.visible = not pause.visible



func load_env(scene: PackedScene) -> void:
	if not scene:
		push_error("no environment scene")
		return
	if is_loading:
		return
	is_loading = true

	#show loading and let it draw
	Global.loading_text.show()
	await get_tree().process_frame

	#remove old
	if current_env:
		current_env.queue_free()

	#add new
	current_env = scene.instantiate()
	sub_viewport.add_child.call_deferred(current_env)

	#wait until loaded
	await current_env.ready
	await get_tree().process_frame

	#done
	Global.loading_text.hide()
	is_loading = false
		
		
		
