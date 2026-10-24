extends Camera2D

var actualCamPos:Vector2

@export var player:Player
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	actualCamPos = actualCamPos.lerp(player.global_position, delta * 5)
	
	var camSubPixelOffset = actualCamPos.round() - actualCamPos
	
	self.get_parent().get_parent().get_parent().get_parent().material.set_shader_parameter("cam_offset", camSubPixelOffset)
	
	global_position = actualCamPos.round()
