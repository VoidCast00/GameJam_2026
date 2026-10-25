
extends CharacterBody2D
@onready var camera_2d: Camera2D = $Camera2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D



const SPEED = 800.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	
		var direction := Input.get_axis("left", "right")
		if not is_on_floor():
			velocity += get_gravity() * delta

	# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			
		if direction > 0:
				animated_sprite.flip_h = false
		elif direction < 0:
				animated_sprite.flip_h = true
		
	
		if is_on_floor():
				if direction == 0:
					animated_sprite.play("idle")
				else:
					animated_sprite.play("walking")
		
		else:
				animated_sprite.play("jump")	

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
		
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		move_and_slide()
