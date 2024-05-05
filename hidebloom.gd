extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	if ProjectSettings.get_setting("rendering/renderer/rendering_method") == "gl_compatibility":
		self.queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
