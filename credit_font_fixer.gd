extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	if OS.get_name() == "Web":
		text = "Made with <3 by Sparkwave"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
