extends Node2D

#wave
@export var bob_height: float = 6.0     #pixels up and down
@export var bob_speed: float = 1.2      #how fast
@export var tilt_angle: float = 3.0     #degrees left and right
@export var tilt_speed: float = 0.8

var playerInside := false
var time := 0.0
var start_pos: Vector2

@onready var loading_text: Control = Global.loading_text
@onready var ship: Sprite2D = $Ship


func _ready() -> void:
	start_pos = ship.position

func _process(delta: float) -> void:
	_wave(delta)

	#enter
	if Input.is_action_just_pressed("action") and playerInside:
		loading_text.show()
		loading_text.get_children()[1].text = "Loading..."
		await get_tree().process_frame
		Global.loadWaterEnviroment.emit()
		$"../BackgroundmusicHandler/ShopSoundtrack".stop()
		$"../BackgroundmusicHandler/ShopAmbience".volume_db = - 10


#ocean bob
func _wave(delta: float) -> void:
	time += delta
	ship.position.y = start_pos.y + sin(time * bob_speed) * bob_height
	ship.rotation = deg_to_rad(sin(time * tilt_speed + 1.0) * tilt_angle)


func _on_enter_area_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		playerInside = true


func _on_enter_area_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		playerInside = false
