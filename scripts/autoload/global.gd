extends Node

signal loadWaterEnviroment;
signal loadShopEnviroment;
signal exitGame;

signal mined(type:String)


var quota:int = 190;
var day:int =  0; #for the start to start counting
var deadline:int = 3;  

var tutorialDone := false

@onready var oxygen_gauge: Control 
@onready var shop_ui: Control 
@onready var loading_text: Control 
