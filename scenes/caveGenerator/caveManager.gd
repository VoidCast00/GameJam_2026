extends Node

@export var caveNoise: NoiseTexture2D
@export var cristalNoise: NoiseTexture2D
@export var caveTilemap: TileMapLayer
@export var cristalTilemap: TileMapLayer
@export var transport:StaticBody2D

@onready var BlockBreak: AudioStreamPlayer = $"../Cave/BlockBreak"

const MAP_SIZE =  200
var terrain_cells_arr:Array[Vector2i]
var cristal_ceels_arr:Array[Vector2i]
#mining =========
var mining_timer := 0.0
var mining_state := false
var miningPos :Vector2i
const MINING_ROCK:= 0.1
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
	generateCaveSystem()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print("CaveManager: " ,mining_state)
	if (mining_state):
		mining_timer += delta
	if mining_timer > MINING_ROCK :
		BlockBreak.play()
		print("mined")
		mining_timer = 0
		_mine(miningPos)
		stopMining()
		

func startMining(pos) -> void:
	print("CaveManager: start minnig" , pos)
	miningPos = pos
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
		print("emptry: ", pos)
		return
	caveTilemap.set_cells_terrain_connect([cell], 0, -1, false)

func generateCaveSystem() -> void:
	for x in range(-(MAP_SIZE/2),(MAP_SIZE/2), 1):
		for y in range(-(MAP_SIZE/2),(MAP_SIZE/2), 1):
			if cristalNoise.noise.get_noise_2d(x,y) > 0.5:
				cristal_ceels_arr.append(Vector2i(x,y)) 
			if caveNoise.noise.get_noise_2d(x,y) > 0:
				terrain_cells_arr.append(Vector2i(x,y))
	caveTilemap.set_cells_terrain_connect(terrain_cells_arr,0,0)
	
	#generating cristals =================================
	for cristal in cristal_ceels_arr:
		if (caveTilemap.get_cell_source_id(cristal) == -1): continue
		if (caveTilemap.get_cell_atlas_coords(cristal) == Vector2i(0,4)): continue
		if (caveTilemap.get_cell_atlas_coords(cristal) == Vector2i(1,4)): continue
		if (caveTilemap.get_cell_atlas_coords(cristal) == Vector2i(1,1)): continue
		if (caveTilemap.get_cell_atlas_coords(cristal) == Vector2i(0,5)): continue
		if (caveTilemap.get_cell_atlas_coords(cristal) == Vector2i(1,5)): continue
		for neighbourCell:Vector2i in caveTilemap.get_surrounding_cells(cristal):
			if (caveTilemap.get_cell_atlas_coords(neighbourCell) == Vector2i(1,1)):
				var dir:Vector2i = cristal - neighbourCell
				match dir:
					Vector2i(0,1):
						cristalTilemap.set_cell(cristal,0,Vector2i(0,1) )
					Vector2i(0,-1):
						cristalTilemap.set_cell(cristal, 0, Vector2i(1,0))
					Vector2i(1,0):
						cristalTilemap.set_cell(cristal, 0, Vector2i(1,1))
					Vector2i(-1,0):
						cristalTilemap.set_cell(cristal, 0, Vector2i(0,0))
	
	#create an crater around the transport ======================
	explode(transport.global_position, 10)  
	
	
	


#explosion
func explode(global_pos: Vector2, radius: int) -> void:
	var center := caveTilemap.local_to_map(caveTilemap.to_local(global_pos))
	var cells: Array[Vector2i] = []

	for x in range(-radius, radius + 1):
		for y in range(-radius, radius + 1):
			var dist := x * x + y * y

			#round shape
			if dist > radius * radius:
				continue

			#outer ring 50% chance to survive
			if dist > (radius - 1) * (radius - 1) and randf() < 0.5:
				continue

			var cell := center + Vector2i(x, y)
			if caveTilemap.get_cell_source_id(cell) != -1:
				cells.append(cell)

	#erase and fix edges
	caveTilemap.set_cells_terrain_connect(cells, 0, -1, false)
