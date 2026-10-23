extends Node

@export var caveNoise: NoiseTexture2D
@export var caveTilemap: TileMapLayer
const MAP_SIZE =  700

func _ready() -> void:
	for x in range(-(MAP_SIZE/2),(MAP_SIZE/2), 1):
		for y in range(-(MAP_SIZE/2),(MAP_SIZE/2), 1):
			if caveNoise.noise.get_noise_2d(x,y) > 0:
				caveTilemap.set_cell(Vector2(x,y),0, Vector2i(1,1)) 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
