extends Control

@onready var back_to_game: AnimatedButton = $VBoxContainer/backToGame
@onready var options: AnimatedButton = $VBoxContainer/options
@onready var exit: AnimatedButton = $VBoxContainer/goMainMenu


func _ready() -> void:
	exit.pressed.connect(_on_exit_pressed)
	


func _on_exit_pressed() -> void:
	#todo: main menu load
	Global.exitGame.emit()
	
