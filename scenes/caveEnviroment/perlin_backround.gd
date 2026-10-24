extends ColorRect

@onready var camera: Camera2D = get_parent()


func _ready() -> void:
	top_level = true


func _process(_delta: float) -> void:
	#cover the screen
	var screen := get_viewport_rect().size / camera.zoom
	size = screen
	global_position = camera.get_screen_center_position() - screen / 2

	#parallax
	material.set_shader_parameter("camera_pos", camera.get_screen_center_position())
