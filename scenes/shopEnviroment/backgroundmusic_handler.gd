extends Node

@onready var soundtrack: AudioStreamPlayer = $ShopSoundtrack
@onready var shop_ambience: AudioStreamPlayer = $ShopAmbience


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	soundtrack.play()
	shop_ambience.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
