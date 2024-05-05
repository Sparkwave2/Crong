extends Node

var control_mode = 0
var fullscreen = 0
var vsync = 2
var aberration = 1
var bloom = 1
var difficulty = 1
var first_start = true

var crt_material = preload("res://crt.tres")


# Called when the node enters the scene tree for the first time.
func _ready():
	if ProjectSettings.get_setting("rendering/renderer/rendering_method") == "gl_compatibility":
		crt_material.set_shader_parameter("web_compat", true)
	else:
		crt_material.set_shader_parameter("web_compat", false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
