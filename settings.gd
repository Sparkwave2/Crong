extends VBoxContainer

@export var list_of_buttons: Array[Button]

@export var control_button: Button
@export var fullscreen_button: Button
@export var vsync_button: Button
@export var aberration_button: Button
@export var bloom_button: Button
@export var trails_button: Button

@export var volume_slider: Slider
@export var volume_label: Label
var temp_volume: int

@export var filter: ColorRect

@export var world_environment: WorldEnvironment

@export var select_sound: AudioStreamPlayer
@export var exit_sound: AudioStreamPlayer
@export var sound_preview: AudioStreamPlayer




# Called when the node enters the scene tree for the first time.
func _ready():
	if ProjectSettings.get_setting("rendering/renderer/rendering_method") == "gl_compatibility":
		bloom_button.queue_free() # Bloom doesn't work in OpenGL mode
	if OS.get_name() == "Web":
		vsync_button.queue_free() # VSync doesn't do anything in web version
		if Autoload.mobile_layout:
			control_button.disabled = true # Gyroscope doesn't work on web mobile
	if Autoload.mobile_layout:
		vsync_button.queue_free()
		fullscreen_button.queue_free() # VSync and fullscreen don't do anything on mobile
		get_tree().set_auto_accept_quit(false) # Attempt to stop the back button from exiting the app
		for button in list_of_buttons:
			button.add_theme_font_size_override("font_size", 40) # Increase button font size
		volume_label.add_theme_font_size_override("font_size", 30)
	select_sound.play()
	update_text()
	update_display_server_text()
	update_sliders()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
## Update options that aren't sliders and that don't change the display server.
func update_text():
	match Autoload.control_mode:
		0:
			control_button.text = "Keyboard Only"
		1:
			if DisplayServer.is_touchscreen_available():
				control_button.text = "Mouse/Touch" # Could be a PC with a touchscreen
			else:
				control_button.text = "Mouse"
		2:
			control_button.text = "Controller"
		3:
			control_button.text = "Touch"
		4:
			control_button.text = "Accelerometer"
			
	if OS.get_name() == "Web":
		fullscreen_button.text = "Go Fullscreen" # On web, fullscreen is one-way
	elif Autoload.mobile_layout:
		pass
			
	match Autoload.aberration:
		0:
			aberration_button.text = "No Aberration"
			Autoload.crt_material.set_shader_parameter("aberration", 0)
		1:
			aberration_button.text = "Weak Aberration"
			Autoload.crt_material.set_shader_parameter("aberration", 1)
		2:
			aberration_button.text = "Strong Aberration"
			Autoload.crt_material.set_shader_parameter("aberration", 2)
			
	match Autoload.trails:
		0:
			trails_button.text = "Trails Off"
		1:
			trails_button.text = "Trails On"
	
	if ProjectSettings.get_setting("rendering/renderer/rendering_method") == "gl_compatibility":
		return
		
	match Autoload.bloom:
		0:
			bloom_button.text = "Bloom Off"
			world_environment.environment.glow_enabled = false
		1:
			bloom_button.text = "Bloom On"
			world_environment.environment.glow_enabled = true

## Update options that are based on sliders.
func update_sliders():
	volume_slider.value = Autoload.audio_volume_displayed
	volume_label.text = "Volume: " + str(volume_slider.value) + "%"
	
## Update options that require modifying the display server. This is in a separate function because those options cause lag when changed.
func update_display_server():
	if OS.get_name() != "Web":
		match Autoload.fullscreen:
			0:
				fullscreen_button.text = "Windowed"
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
			1:
				fullscreen_button.text = "Borderless"
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			2:
				fullscreen_button.text = "Fullscreen"
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
				
## Update just the text of the display server options, to not cause lag
func update_display_server_text():
	if OS.get_name() != "Web":
		match Autoload.fullscreen:
			0:
				fullscreen_button.text = "Windowed"
			1:
				fullscreen_button.text = "Borderless"
			2:
				fullscreen_button.text = "Fullscreen"
			
			
		match Autoload.vsync:
			0:
				vsync_button.text = "VSync Off"
			1:
				vsync_button.text = "VSync Adaptive"
			2:
				vsync_button.text = "VSync On"


func _on_back_pressed():
	get_tree().change_scene_to_file("res://menu.tscn")
	
func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST and Autoload.mobile_layout:
		get_tree().change_scene_to_file("res://menu.tscn")


func _on_control_mode_pressed():
	select_sound.play()
	if Autoload.mobile_layout:
		Autoload.control_mode += 1
		if Autoload.control_mode > 4:
			Autoload.control_mode = 3
	else:
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
	update_display_server()


func _on_v_sync_pressed():
	select_sound.play()
	Autoload.vsync += 1
	if Autoload.vsync > 2:
		Autoload.vsync = 0
	update_display_server()


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
	
func _on_trails_pressed():
	select_sound.play()
	Autoload.trails += 1
	if Autoload.trails > 1:
		Autoload.trails = 0
	update_text()



func _on_volume_slider_value_changed(value):
	sound_preview.play()
	var int_to_db = (20 * log(value)) - 92.10340371976184
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), int_to_db)
	# print(str(value) + ", " + str(int_to_db))
	volume_label.text = "Volume: " + str(value) + "%"
	temp_volume = value
	
func _on_volume_slider_drag_ended(value_changed):
	Autoload.audio_volume_displayed = temp_volume
