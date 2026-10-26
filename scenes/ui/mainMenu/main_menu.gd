extends Control
@export var main_menu_soundtrack: AudioStreamPlayer
@export var start: AnimatedButton
@export var options: AnimatedButton
@export var exit: AnimatedButton

@export var tutorial: Control
var waitingForTutorial := false

func _ready() -> void:
	main_menu_soundtrack.play()
	exit.pressed.connect(_on_exit_pressed)
	start.pressed.connect(_on_start_pressed)


func _on_start_pressed() -> void:
	if Global.tutorialDone:
		start_game()
		return

	tutorial.show()
	start.disabled = true  # stops double clicks
	await get_tree().create_timer(2.0).timeout
	waitingForTutorial = true  # now any key or click closes it


func _input(event: InputEvent) -> void:
	if not waitingForTutorial:
		return
	if event.is_pressed() and not event.is_echo():
		waitingForTutorial = false
		Global.tutorialDone = true
		tutorial.hide()
		get_viewport().set_input_as_handled()
		start_game()


func start_game() -> void:
	main_menu_soundtrack.stop()
	Global.loadShopEnviroment.emit()


func _on_exit_pressed() -> void:
	Global.exitGame.emit()
	main_menu_soundtrack.stop()
