extends CharacterBody2D

var current_movement: float = 0

var current_touch: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	current_touch = transform.origin


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var target_movement
	match Autoload.control_mode:
		0, 2, 3: # Keyboard
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
		4: # Accelerometer
			var raw_movement = -Input.get_accelerometer().y
			target_movement = clampf(raw_movement, -5, 5)
	
	if Autoload.control_mode == 2 or Autoload.control_mode == 3:
		target_movement = Input.get_joy_axis(0, JOY_AXIS_LEFT_Y) * 5
	
	if Autoload.control_mode == 3:
		if current_touch.y > transform.origin.y:
			target_movement = 5
		elif current_touch.y < transform.origin.y:
			target_movement = -5
		else:
			target_movement = 0
		
	current_movement = lerpf(target_movement, current_movement, 1 - delta*10)
	
		
	move_and_collide(Vector2(0, current_movement * delta * 60))
	
func _input(event):
	if event is InputEventScreenDrag or event is InputEventScreenTouch:
		current_touch = event.position
