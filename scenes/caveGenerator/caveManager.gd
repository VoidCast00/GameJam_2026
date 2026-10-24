extends Node

@export var caveNoise: NoiseTexture2D
@export var caveTilemap: TileMapLayer
const MAP_SIZE =  200
var terrain_cells_arr:Array[Vector2i]

#mining =========
var mining_timer := 0.0
var mining_state := false
var miningPos :Vector2i
const MINING_ROCK:= 0.5
const MINING_MINERALS:=1.5
var miningType


const DIRS = [
	TileSet.CELL_NEIGHBOR_RIGHT_SIDE,
	TileSet.CELL_NEIGHBOR_BOTTOM_RIGHT_CORNER,
	TileSet.CELL_NEIGHBOR_BOTTOM_SIDE,
	TileSet.CELL_NEIGHBOR_BOTTOM_LEFT_CORNER,
	TileSet.CELL_NEIGHBOR_LEFT_SIDE,
	TileSet.CELL_NEIGHBOR_TOP_LEFT_CORNER,
	TileSet.CELL_NEIGHBOR_TOP_SIDE,
	TileSet.CELL_NEIGHBOR_TOP_RIGHT_CORNER,
]

func _ready() -> void:
	
	for x in range(-(MAP_SIZE/2),(MAP_SIZE/2), 1):
		for y in range(-(MAP_SIZE/2),(MAP_SIZE/2), 1):
			if caveNoise.noise.get_noise_2d(x,y) > 0:
				terrain_cells_arr.append(Vector2i(x,y))
	caveTilemap.set_cells_terrain_connect(terrain_cells_arr,0,0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print("CaveManager: " ,mining_state)
	if (mining_state):
		mining_timer += delta
	if mining_timer > MINING_ROCK :
		mining_timer = 0
		stopMining()
		_mine(miningPos)
		

func startMining(pos) -> void:
	print("CaveManager: start minnig" , pos)
	miningPos = caveTilemap.local_to_map(pos)
	mining_state = true
	miningType = "idk" #later
	mining_timer = 0

func stopMining() -> void:
	print("CaveManager: stop mining ")
	miningType = ""
	mining_timer = 0
	miningPos = Vector2.ZERO
	mining_state = false

func _mine(pos: Vector2) -> void:
	var cell: Vector2i = caveTilemap.local_to_map(pos)
	if caveTilemap.get_cell_source_id(cell) == -1:
		return
	caveTilemap.set_cells_terrain_connect([cell], 0, -1, false)
