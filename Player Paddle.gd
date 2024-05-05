extends CharacterBody2D

var current_movement: float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var target_movement
	match Autoload.control_mode:
		0, 2: # Keyboard
			if Input.is_key_pressed(KEY_UP) and Input.is_key_pressed(KEY_DOWN):
				target_movement = 0
			elif Input.is_key_pressed(KEY_UP):
				target_movement = -5
			elif Input.is_key_pressed(KEY_DOWN):
				target_movement = 5
			else:
				target_movement = 0
		1: # Mouse
			if get_viewport().get_mouse_position().y > transform.origin.y:
				target_movement = 5
			elif get_viewport().get_mouse_position().y < transform.origin.y:
				target_movement = -5
			else:
				target_movement = 0
	
	if Autoload.control_mode == 2:
		target_movement = Input.get_joy_axis(0, JOY_AXIS_LEFT_Y) * 5
		
	current_movement = lerpf(target_movement, current_movement, 1 - delta*10)
	
		
	move_and_collide(Vector2(0, current_movement * delta * 60))
