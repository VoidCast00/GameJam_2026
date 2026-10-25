extends Control


	


func _on_start_pressed() -> void:
	Global.loadShopEnviroment.emit()
	


func _on_exit_pressed() -> void:
	Global.exitGame.emit()
	
