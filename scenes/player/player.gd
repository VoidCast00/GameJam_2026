extends CharacterBody2D

@export var speed = 200
@export var friction = 0.4
@export var acceleration = 0.1
@export var rotation_speed = 4

@onready var shooting_point: Marker2D = $ShootingPoint
@onready var laser: Line2D = $Laser

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
	var is_clicked = get_click()
	if(is_clicked):
		laser.show()
		var mouse_position = get_local_mouse_position()
		laser.points = PackedVector2Array([Vector2(shooting_point.position.x, shooting_point.position.y), Vector2(mouse_position.x, mouse_position.y)])
	else:
		laser.hide()
	
		
