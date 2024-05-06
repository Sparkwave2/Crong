extends Node

var control_mode = 0
# 0 - Keyboard Only
# 1 - Mouse/Touch (for desktop devices with touchscreens)
# 2 - Gamepad
# 3 - Touch + Gamepad (for phones)
# 4 - Accelerometer
var fullscreen = 0
# 0 - Windowed
# 1 - Borderless Windowed
# 2 - Fullscreen
var vsync = 2
# 0 - Off
# 1 - Adaptive
# 2 - On
var aberration = 1
# 0 - No Aberration
# 1 - Weak Aberration
# 2 - Strong Aberration
var bloom = 1
# 0 - Bloom Off
# 1 - Bloom On
var trails = 1
# 0 - Trails Off
# 1 - Trails On
var difficulty = 1
# 0 - Easy
# 1 - Medium
# 2 - Hard
var audio_volume_displayed = 100
var first_start = true

var crt_material = preload("res://crt.tres")

var version = "Alpha 0.0.2"
var builddate = "06.05.2024"

var mobile_layout = false


# Called when the node enters the scene tree for the first time.
func _ready():
	if ProjectSettings.get_setting("rendering/renderer/rendering_method") == "gl_compatibility":
		crt_material.set_shader_parameter("web_compat", true)
	else:
		crt_material.set_shader_parameter("web_compat", false)
		
	if OS.get_name() == "Android" or OS.get_name() == "iOS" or OS.has_feature("web_android") or OS.has_feature("web_ios"):
		control_mode = 3 # Automatically enable touch+gamepad control since that's more available on touchscreen devices
		bloom = 0 # Disable bloom on mobile because it looks like shit there
		mobile_layout = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
