class_name Player
extends CharacterBody2D

#movement==================================================
@export var speed: float = 200
@export var friction: float = 0.4
@export var acceleration: float = 0.1
@export var rotation_speed: float = 4


#mining============================================
@export var cave_tilemap: TileMapLayer
const LASER_LENGTH := 200.0
const CELL_HIT_RANGE := 60.0
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
@onready var breathing: AudioStreamPlayer = $Breathing
@onready var point_light_2d: PointLight2D = $PointLight2D
#OXYGENNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN




func _ready() -> void:
	breathing.play()

func _physics_process(delta: float) -> void:
	move(delta)


func _process(delta: float) -> void:
	Global.oxygen -= delta
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
		point_light_2d.global_rotation = 0.0
	else:
		velocity = velocity.lerp(Vector2.ZERO, friction)
	if is_clicking():
		rotation = lerp_angle(rotation, global_position.angle_to_point(get_global_mouse_position()) + PI * 0.5, (rotation_speed * delta) )
	move_and_slide()

#mine=======================================================================
var is_lasering := false


func mine(_delta: float) -> void:
	var hit = get_laser_hit()

	#not mining
	if hit == null:
		if is_lasering:
			is_lasering = false
			laser.hide()
			LaserSound.stop()
			world_generator.stopMining()
		return

	#laser
	is_lasering = true
	show_laser(hit)
	if not LaserSound.playing:
		LaserSound.play()

	#step a bit inside the wall so we get the hit cell
	var inside: Vector2 = hit - ray_cast.get_collision_normal() * 2.0
	world_generator.startMining(inside)


#returns hit point on the cave, or null
func get_laser_hit():
	if not cave_tilemap or not is_clicking():
		return null

	#aim at mouse, max laser length
	var from := shooting_point.global_position
	var dir := get_global_mouse_position() - from
	dir = dir.limit_length(LASER_LENGTH)

	#raycast
	ray_cast.global_position = from
	ray_cast.target_position = ray_cast.to_local(from + dir)
	ray_cast.force_raycast_update()

	#only the cave counts
	if not ray_cast.is_colliding() or ray_cast.get_collider() != cave_tilemap:
		return null

	return ray_cast.get_collision_point()


#laser
func show_laser(target: Vector2) -> void:
	laser.show()
	laser.points = PackedVector2Array([
		laser.to_local(shooting_point.global_position),
		laser.to_local(target)
	])
