extends Control
@export var main_menu_soundtrack: AudioStreamPlayer
@export var start: AnimatedButton
@export var options: AnimatedButton
@export var exit: AnimatedButton

func _ready() -> void:
	main_menu_soundtrack.play()
	exit.pressed.connect(_on_exit_pressed)
	start.pressed.connect(_on_start_pressed)


func _on_start_pressed() -> void:
	Global.loadShopEnviroment.emit()
	main_menu_soundtrack.stop()


func _on_exit_pressed() -> void:
	Global.exitGame.emit()
	main_menu_soundtrack.stop()
