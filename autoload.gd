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
var particles = 1
# 0 - Particles Off
# 1 - Particles On
var vibrations = 1
# 0 - Vibrations Off
# 1 - Vibrations On
var difficulty = 1
# 0 - Easy
# 1 - Medium
# 2 - Hard
var audio_volume_displayed = 100
var audio_volume_percent = 100
var first_start = true

var crt_material = preload("res://crt.tres")

var version = "Alpha 0.0.4"
var builddate = "12.05.2024"

var mobile_layout = false

var player_color = Color.GREEN
var ball_color = Color.WHITE
var enemy_color = Color.RED

var player_powerup = 0
var enemy_powerup = 0
# 0 - None
# 1 - Tall Paddle
# 2 - Speed Boost
# 3 - Obstacle

var player_powerup_timer = 0
var enemy_powerup_timer = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	var config = ConfigFile.new()
	var err = config.load("user://settings.cfg")
	if err != OK: 
		print("Opening config file failed: " +str(err))
	else:
		control_mode = config.get_value("settings", "control_mode")
		fullscreen = config.get_value("settings", "fullscreen")
		vsync = config.get_value("settings", "vsync")
		match fullscreen:
			0:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
			1:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			2:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		match vsync:
			0:
				DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
			1:
				DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ADAPTIVE)
			2:
				DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		aberration = config.get_value("settings", "aberration")
		crt_material.set_shader_parameter("aberration", aberration)
		bloom = config.get_value("settings", "bloom")
		trails = config.get_value("settings", "trails")
		particles = config.get_value("settings", "particles")
		vibrations = config.get_value("settings", "vibrations")
		player_color = config.get_value("settings", "player_color")
		ball_color = config.get_value("settings", "ball_color")
		enemy_color = config.get_value("settings", "enemy_color")
		audio_volume_percent = config.get_value("settings", "sfx_volume")
		var int_to_db = (20 * log(audio_volume_percent)) - 92.10340371976184
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), int_to_db)
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
	
func _physics_process(delta):
	if player_powerup_timer > 0:
		player_powerup_timer -= 1
	if player_powerup_timer <= 0:
		player_powerup = 0
	if enemy_powerup_timer > 0:
		enemy_powerup_timer -= 1
	if enemy_powerup_timer <= 0:
		enemy_powerup = 0
	
