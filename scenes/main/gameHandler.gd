extends Node


@export var sub_viewport: SubViewport
@export var WaterEnviroment: PackedScene
@export var ShopEnviroment: PackedScene
@export var menu:Control
@export var pause:Control
@export var oxygen_gauge: Control 
@export var label: Label
@export var lost_quota: Control
@export var main_menu: Control
@export var death: Control






#current environment
var current_env: Node = null
var is_loading := false

func _ready() -> void:
	Inventory.oxygenDepleted.connect(killPLayer)
	pause.resume.connect(switchPause)
	Global.shop_ui = %ShopUI
	Global.loading_text = %LoadingText
	Global.oxygen_gauge = oxygen_gauge
	Global.loadWaterEnviroment.connect(loadWaterEnviroment)
	Global.loadShopEnviroment.connect(loadShopEnviroment)
	Global.exitGame.connect(exitGame)
	

func loadWaterEnviroment() -> void:
	menu.hide()
	oxygen_gauge.show()
	
	var daysLeft = (Global.deadline - Global.day) 
	if (daysLeft == 0 and Inventory.cash - Global.quota < 0):
			lost_quota.show()
			var sound : AudioStreamPlayer = main_menu.main_menu_soundtrack
			sound.play()
			sound.pitch_scale = 0.8	
			unload()
	
	else:
		if (daysLeft == 0):
			Inventory.cash -= Global.quota
			Global.quota *= 2
			Global.deadline += 3
		else:
			Global.day += 1
		load_env(WaterEnviroment)
		

func killPLayer():
	unload()
	death.show()


func unload() -> void:
	if current_env:
		current_env.queue_free()


func loadShopEnviroment() -> void:
	var daysLeft = (Global.deadline - Global.day) 			
	var text :String = ""
	if daysLeft == 1:
		text = "1. day remeaning"
	else:
		text = str(daysLeft) + ". days remaning"
	Global.loading_text.get_children()[1].text = text
	Global.loading_text.get_children()[2].text = "Quota: " + str(Global.quota)
	Global.loading_text.show()
	menu.hide()
	oxygen_gauge.hide()
	await get_tree().create_timer(2.0).timeout
	load_env(ShopEnviroment)


func exitGame():
	get_tree().quit()
	

func switchPause() -> void:
	pause.visible = not pause.visible
	get_tree().paused = pause.visible


func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_pressed("esc"):
		return

	if menu.visible:
		return
	switchPause()


func load_env(scene: PackedScene) -> void:
	if not scene:
		push_error("no environment scene")
		return
	if is_loading:
		return
	is_loading = true

	Global.loading_text.show()

	await get_tree().process_frame

	unload()

	#add new
	current_env = scene.instantiate()
	sub_viewport.add_child.call_deferred(current_env)

	#wait until loaded
	await current_env.ready
	await get_tree().process_frame


	Global.loading_text.hide()
	is_loading = false
		
		
		
