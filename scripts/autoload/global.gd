extends Node

signal loadWaterEnviroment;
signal loadShopEnviroment;
signal exitGame;

signal mined(type:String)


var quota:int = 0;
var day:int =  1;

@onready var oxygen_gauge: Control 
@onready var shop_ui: Control 
@onready var loading_text: Control 
