extends HBoxContainer

@export var control_button: Button
@export var fullscreen_button: Button
@export var vsync_button: Button
@export var aberration_button: Button
@export var bloom_button: Button

@export var filter: ColorRect

@export var world_environment: WorldEnvironment

@export var select_sound: AudioStreamPlayer
@export var exit_sound: AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	if ProjectSettings.get_setting("rendering/renderer/rendering_method") == "gl_compatibility":
		bloom_button.queue_free()
	if OS.get_name() == "Web":
		vsync_button.queue_free()
	select_sound.play()
	update_text()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func update_text():
	match Autoload.control_mode:
		0:
			control_button.text = "Keyboard Only"
		1:
			if DisplayServer.is_touchscreen_available():
				control_button.text = "Mouse/Touch~"
			else:
				control_button.text = "Rat"
		2:
			control_button.text = "Controller"
			
	if OS.get_name() == "Web":
		fullscreen_button.text = "Fully screen"
	else:
		match Autoload.fullscreen:
			0:
				fullscreen_button.text = "Boxed"
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
			1:
				fullscreen_button.text = "Less borders"
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			2:
				fullscreen_button.text = "Fully screen"
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
			
			
		match Autoload.vsync:
			0:
				vsync_button.text = "VSync Off"
				DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
			1:
				vsync_button.text = "VSync Adaptive"
				DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ADAPTIVE)
			2:
				vsync_button.text = "VSync On"
				DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
			
	match Autoload.aberration:
		0:
			aberration_button.text = "No Aberrrrrrrrrrr."
			Autoload.crt_material.set_shader_parameter("aberration", 0)
		1:
			aberration_button.text = "Normal Aberr."
			Autoload.crt_material.set_shader_parameter("aberration", 1)
		2:
			aberration_button.text = "POWERFUL Aberr."
			Autoload.crt_material.set_shader_parameter("aberration", 2)
	
	if ProjectSettings.get_setting("rendering/renderer/rendering_method") == "gl_compatibility":
		return
		
	match Autoload.bloom:
		0:
			bloom_button.text = "Bloom Off"
			world_environment.environment.glow_enabled = false
		1:
			bloom_button.text = "Bloom On"
			world_environment.environment.glow_enabled = true


func _on_back_pressed():
	get_tree().change_scene_to_file("res://menu.tscn")


func _on_control_mode_pressed():
	select_sound.play()
	Autoload.control_mode += 1
	if Autoload.control_mode > 2:
		Autoload.control_mode = 0
	update_text()


func _on_fullscreen_pressed():
	select_sound.play()
	if OS.get_name() == "Web":
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		Autoload.fullscreen += 1
		if Autoload.fullscreen > 2:
			Autoload.fullscreen = 0
	update_text()


func _on_v_sync_pressed():
	select_sound.play()
	Autoload.vsync += 1
	if Autoload.vsync > 2:
		Autoload.vsync = 0
	update_text()


func _on_aberration_pressed():
	select_sound.play()
	Autoload.aberration += 1
	if Autoload.aberration > 2:
		Autoload.aberration = 0
	update_text()


func _on_bloom_pressed():
	select_sound.play()
	Autoload.bloom += 1
	if Autoload.bloom > 1:
		Autoload.bloom = 0
	update_text()
