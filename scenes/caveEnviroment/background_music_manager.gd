extends Node

@onready var soundtrack: AudioStreamPlayer = $Soundtrack
@onready var ambience: AudioStreamPlayer = $Ambience


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	soundtrack.play()
	ambience.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
