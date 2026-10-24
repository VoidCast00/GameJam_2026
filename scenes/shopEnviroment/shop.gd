extends Node2D

var playerInside:bool = false
@onready var shop_ui: Control = Global.shop_ui

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if shop_ui.visible == true  and Input.is_action_just_pressed("action"):
		shop_ui.visible = false
	if Input.is_action_just_pressed("action") and playerInside:
		shop_ui.visible = true
	
	




func _on_enter_box_body_entered(body: CharacterBody2D) -> void:
	playerInside = true

func _on_enter_box_body_exited(body: CharacterBody2D) -> void:
	playerInside = false
