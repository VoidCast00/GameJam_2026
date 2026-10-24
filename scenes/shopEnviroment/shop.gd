extends Node2D

var playerInside:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("action"):
		print("enter shop")


func _on_enter_box_body_entered(body: Player) -> void:
	playerInside = true

func _on_enter_box_body_exited(body: Player) -> void:
	playerInside = false
