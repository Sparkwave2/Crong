extends WorldEnvironment


# Called when the node enters the scene tree for the first time.
func _ready():
	match Autoload.bloom:
		0:
			environment.glow_enabled = false
		1:
			environment.glow_enabled = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
