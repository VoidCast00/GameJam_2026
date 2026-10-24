extends Node

@onready var soundtrack: AudioStreamPlayer = $ShopSoundtrack


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	soundtrack.play() # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
