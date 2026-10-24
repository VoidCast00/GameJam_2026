extends Node2D

var playerInside: = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("action"):
		Global.loadWaterEnviroment.emit()


func _on_enter_area_body_entered(body: Node2D) -> void:
	playerInside = true

func _on_enter_area_body_exited(body: Node2D) -> void:
	playerInside = false
