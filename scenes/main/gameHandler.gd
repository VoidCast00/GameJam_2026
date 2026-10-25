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
	var daysLeft = (Global.deadline - Global.day) 
	var text :String = ""
	if daysLeft == 1:
		text = "1. day remeaning"
	else:
		text = str(daysLeft) + ". days remaning"
	Global.loading_text.get_children()[1].text = text
	Global.loading_text.show()
	menu.hide()
	await get_tree().create_timer(2.0).timeout
	load_env(ShopEnviroment)
	Global.day += 1


func exitGame():
	get_tree().quit()
	



func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_pressed("esc"):
		return

	if menu.visible:
		return
	pause.visible = not pause.visible
	get_tree().paused = pause.visible


func load_env(scene: PackedScene) -> void:
	if not scene:
		push_error("no environment scene")
		return
	if is_loading:
		return
	is_loading = true

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


	Global.loading_text.hide()
	is_loading = false
		
		
		
