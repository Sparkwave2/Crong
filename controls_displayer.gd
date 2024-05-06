extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	var buffer = "Controls:\n"
	match Autoload.control_mode:
		0:
			buffer += "Up/Down - Move Paddle\n"
			buffer += "Esc/Q - Pause\n"
		1:
			buffer += "Mouse - Move Paddle\n"
			buffer += "Esc/Q - Pause\n"
		2:
			buffer += "Left Stick - Move Paddle\n"
			buffer += "Start - Pause\n"
		3:
			buffer += "Touch - Move Paddle\n"
		4:
			buffer += "Tilt Phone - Move Paddle\n"
	text = buffer


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	modulate.a -= 0.5 * delta
	pass
