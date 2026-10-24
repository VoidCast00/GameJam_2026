extends Control


func _on_start_pressed() -> void:
	Global.loadWaterEnviroment.emit()
