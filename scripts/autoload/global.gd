extends Node

signal loadWaterEnviroment;
signal loadShopEnviroment;
signal exitGame;

signal mined(type:String)

var oxygenTankSize: float = 300
var oxygen: float = oxygenTankSize:  #in seconds
	set(new_val):
		var was_empty := oxygen <= 0.0
		oxygen = clampf(new_val, 0.0, oxygenTankSize)
		#only once
		if oxygen <= 0.0 and not was_empty:
			Global.oxygenDepleted.emit()
