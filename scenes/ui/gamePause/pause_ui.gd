extends Control

@onready var back_to_game: AnimatedButton = $VBoxContainer/backToGame
@onready var options: AnimatedButton = $VBoxContainer/options
@onready var exit: AnimatedButton = $VBoxContainer/exit


func _ready() -> void:
	exit.pressed.connect(_on_exit_pressed)
	


func _on_exit_pressed() -> void:
	Global.exitGame.emit()
	
