extends CharacterBody2D

@export var speed = 2000
@export var friction = 0.4
@export var acceleration = 0.1
@export var rotation_speed = 4
@onready var shooting_point: Marker2D = $ShootingPoint
@onready var laser: Line2D = $Laser
@export var caveTilemap:TileMapLayer
@onready var world_generator: Node = $"../../Static/WorldGenerator"

var LASER_LENGHT := 200

func get_movement_input():
	var vertical = Input.get_axis("up", "down")
	var horizontal = Input.get_axis("left", "right")
	return Vector2(horizontal, vertical)
	
func get_click():
	var leftClick = Input.is_action_pressed("mouseClickLeft")
	return leftClick

func _physics_process(delta):
	
	var direction = get_movement_input()
	if direction.length() > 0:
		velocity = velocity.lerp(direction.normalized() * speed, acceleration)
		rotation = lerp_angle(rotation, get_movement_input().angle() + deg_to_rad(90) , rotation_speed * delta) 
	else:
		velocity = velocity.lerp(Vector2.ZERO, friction)
	move_and_slide()

func _process(delta: float) -> void:
	mine()



func mine():
	if (!caveTilemap):
		return
		
	var mouse_position = get_global_mouse_position()
	if(get_click() and global_position.distance_to(mouse_position) < LASER_LENGHT):
		
		#show laser
		laser.show()
		laser.points = PackedVector2Array([
			laser.to_local(shooting_point.global_position),
			laser.to_local(get_global_mouse_position())
		])
		#mine
		world_generator.mine(mouse_position)
		
	else:
		laser.hide()
