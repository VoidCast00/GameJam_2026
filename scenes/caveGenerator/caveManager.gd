extends Node

#map
const HALF_SIZE := 100  #map is 200x200

#tiles
const NONE := Vector2i(-1, -1)
const FULL_ROCK := Vector2i(1, 1)
const GOLD_OFFSET := Vector2i(0, 6)
const CRYSTAL_TYPE := "amethyst"

#seconds to mine each material
const MINING_TIMES := {
	"rock": 0.3,
	"gold": 1.5,
	"ruby": 1.8,
	"amethyst": 1.0,
}

#rock tiles crystals cant grow on
const CRYSTAL_BLOCKED := [
	Vector2i(0, 4), Vector2i(1, 4), Vector2i(1, 1),
	Vector2i(0, 5), Vector2i(1, 5),
]

#crystal tile by wall direction
const CRYSTAL_TILES := {
	Vector2i(0, -1): Vector2i(1, 12),
	Vector2i(0, 1): Vector2i(0, 13),
	Vector2i(-1, 0): Vector2i(0, 12),
	Vector2i(1, 0): Vector2i(1, 13),
}

@export var caveNoise: NoiseTexture2D
@export var crystalNoise: NoiseTexture2D
@export var goldNoise: NoiseTexture2D
@export var caveTilemap: TileMapLayer
@export var oreTilemap: TileMapLayer
@export var transport: StaticBody2D

@onready var block_break: AudioStreamPlayer = $"../Cave/BlockBreak"
@onready var ore_break: AudioStreamPlayer = $"../Cave/OreBreak"

#ores: cell : gold / amethyst
var ores := {}

#mining
var is_mining := false
var mining_cell := Vector2i.ZERO
var mining_type := ""
var mining_timer := 0.0


func _ready() -> void:
	generateCaveSystem()


func _process(delta: float) -> void:
	if not is_mining:
		return

	mining_timer += delta
	if mining_timer >= MINING_TIMES.get(mining_type, 1.0):
		Global.mined.emit(mining_type)
		match mining_type:
			"rock":
				block_break.play()
			"gold":
				ore_break.play()
			"amethyst":
				ore_break.play()
			"ruby":
				ore_break.play()

		_remove_cells([mining_cell])
		stopMining()


#mining (global position)
func startMining(global_pos: Vector2) -> void:
	var cell := caveTilemap.local_to_map(caveTilemap.to_local(global_pos))

	#already mining this cell
	if is_mining and cell == mining_cell:
		return

	#nothing there
	if caveTilemap.get_cell_source_id(cell) == -1:
		stopMining()
		return

	mining_cell = cell
	mining_type = ores.get(cell, "rock")
	mining_timer = 0.0
	is_mining = true


func stopMining() -> void:
	is_mining = false
	mining_cell = Vector2i.ZERO
	mining_type = ""
	mining_timer = 0.0


#generate
func generateCaveSystem() -> void:
	#rock
	var rock: Array[Vector2i] = []
	for x in range(-HALF_SIZE, HALF_SIZE):
		for y in range(-HALF_SIZE, HALF_SIZE):
			if caveNoise.noise.get_noise_2d(x, y) > 0:
				rock.append(Vector2i(x, y))
	caveTilemap.set_cells_terrain_connect(rock, 0, 0)

	#crater first so ores match the final shape
	explode(transport.global_position, 10)

	#pick ores
	for cell in rock:
		if caveTilemap.get_cell_source_id(cell) == -1:
			continue
		if crystalNoise.noise.get_noise_2d(cell.x, cell.y) > 0.8 and _crystal_tile(cell) != NONE and oreTilemap.get_cell_source_id(cell) == -1:
			ores[cell] = CRYSTAL_TYPE
		elif goldNoise.noise.get_noise_2d(cell.x, cell.y) > 0.4 and caveNoise.noise.get_noise_2d(cell.x, cell.y) > 0.1:
			ores[cell] = "gold"

	#draw ores
	for cell in ores.keys():
		_update_ore(cell)


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

	_remove_cells(cells)


#remove rock and fix ores around it
func _remove_cells(cells: Array[Vector2i]) -> void:
	if cells.is_empty():
		return

	caveTilemap.set_cells_terrain_connect(cells, 0, -1, false)

	#find ores near changed tiles
	var nearby := {}
	for cell in cells:
		for x in range(-2, 3):
			for y in range(-2, 3):
				var c := cell + Vector2i(x, y)
				if ores.has(c):
					nearby[c] = true

	for c in nearby:
		_update_ore(c)


#redraw one ore to match the rock under it
func _update_ore(cell: Vector2i) -> void:
	var rock_tile := caveTilemap.get_cell_atlas_coords(cell)
	var ore_tile := NONE

	if rock_tile != NONE:
		if ores[cell] == "gold":
			ore_tile = rock_tile + GOLD_OFFSET
		else:
			ore_tile = _crystal_tile(cell)

	#remove or draw
	if ore_tile == NONE:
		ores.erase(cell)
		oreTilemap.erase_cell(cell)
	else:
		oreTilemap.set_cell(cell, 0, ore_tile)


#crystal tile facing the wall, or NONE
func _crystal_tile(cell: Vector2i) -> Vector2i:
	if caveTilemap.get_cell_atlas_coords(cell) in CRYSTAL_BLOCKED:
		return NONE

	for neighbour in caveTilemap.get_surrounding_cells(cell):
		if caveTilemap.get_cell_atlas_coords(neighbour) == FULL_ROCK:
			var dir := cell - neighbour
			if CRYSTAL_TILES.has(dir):
				return CRYSTAL_TILES[dir]

	return NONE
