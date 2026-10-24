extends Control
@onready var utopia___main_menu_soundtrack: AudioStreamPlayer = $"Utopia - mainMenuSoundtrack"

func _ready() -> void:
	utopia___main_menu_soundtrack.play()


func _on_start_pressed() -> void:
	Global.loadShopEnviroment.emit()
	utopia___main_menu_soundtrack.stop()


func _on_exit_pressed() -> void:
	Global.exitGame.emit()
	utopia___main_menu_soundtrack.stop()
