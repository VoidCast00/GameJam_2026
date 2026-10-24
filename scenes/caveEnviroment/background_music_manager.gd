extends Node

@onready var soundtrack: AudioStreamPlayer = $Soundtrack


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	soundtrack.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
