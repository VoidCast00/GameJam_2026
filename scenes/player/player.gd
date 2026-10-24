extends CharacterBody2D

#movement==================================================
@export var speed: float = 2000
@export var friction: float = 0.4
@export var acceleration: float = 0.1
@export var rotation_speed: float = 4

#mining============================================
@export var cave_tilemap: TileMapLayer
const LASER_LENGTH := 200.0
const CELL_HIT_RANGE := 30.0
var mining_pos:Vector2
var mining_pos_last_frame:Vector2
var mining_state:bool = false
var mining_state_last_frame:bool = false
#nodes================================================
@onready var shooting_point: Marker2D = $ShootingPoint
@onready var laser: Line2D = $Laser
@onready var ray_cast: RayCast2D = $RayCast2D
@export var world_generator: Node 
@onready var LaserSound: AudioStreamPlayer = $LaserSound


func _physics_process(delta: float) -> void:
	move(delta)


func _process(delta: float) -> void:
	mine(delta)


#input===================================================================
func get_movement_input() -> Vector2:
	return Input.get_vector("left", "right", "up", "down")


func is_clicking() -> bool:
	return Input.is_action_pressed("mouseClickLeft")


#move=======================================================================
func move(delta: float) -> void:
	var direction := get_movement_input()

	if direction != Vector2.ZERO:
		velocity = velocity.lerp(direction * speed, acceleration)
		rotation = lerp_angle(rotation, direction.angle() + PI / 2, rotation_speed * delta)
	else:
		velocity = velocity.lerp(Vector2.ZERO, friction)

	move_and_slide()


#mine=======================================================================
func mine(delta) -> void:
	#print("player: " ,mining_state)
	if not cave_tilemap or not can_mine():
		laser.hide()
		LaserSound.stop()
		
		if mining_state:
			mining_state = false
			world_generator.stopMining()
			
		return

	var mouse_pos := get_global_mouse_position()
	show_laser(mouse_pos)
	
	
	mining_state = true
	mining_pos = get_cell_center(mouse_pos)
	
	
	if (mining_state != mining_state_last_frame):
		world_generator.startMining(mining_pos)
		mining_pos_last_frame = mining_pos
		LaserSound.play()
		
	if (mining_pos != mining_pos_last_frame):
		mining_state = false
		world_generator.stopMining()
		
	
	mining_pos_last_frame = mining_pos
	mining_state_last_frame = mining_state


func can_mine() -> bool:
	var mouse_pos := get_global_mouse_position()

	#click and range
	if not is_clicking():
		return false
	if global_position.distance_to(mouse_pos) > LASER_LENGTH:
		return false

	#raycast
	ray_cast.global_position = shooting_point.global_position
	ray_cast.target_position = ray_cast.to_local(mouse_pos)
	ray_cast.force_raycast_update()
	if not ray_cast.is_colliding():
		return false

	#hit near the clicked cell
	var hit_pos := ray_cast.get_collision_point()
	return hit_pos.distance_to(get_cell_center(mouse_pos)) < CELL_HIT_RANGE


func get_cell_center(global_pos: Vector2) -> Vector2:
	var cell := cave_tilemap.local_to_map(cave_tilemap.to_local(global_pos))
	return cave_tilemap.to_global(cave_tilemap.map_to_local(cell))


#laser
func show_laser(target: Vector2) -> void:
	laser.show()
	laser.points = PackedVector2Array([
		laser.to_local(shooting_point.global_position),
		laser.to_local(target)
	])
