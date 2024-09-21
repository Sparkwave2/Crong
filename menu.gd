extends VBoxContainer

@export var list_of_buttons: Array[Button]

@export var difficulty_button: Button
@export var exit_button: Button
@export var multiplayer_button: Button

@export var select_sound: AudioStreamPlayer
@export var exit_sound: AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	if OS.get_name() == "Web":
		exit_button.queue_free()
		
	if Autoload.first_start == true:
		Autoload.first_start = false
	else:
		exit_sound.play()
	match Autoload.difficulty:
		-1:
			difficulty_button.text = "Baby"
		0:
			difficulty_button.text = "Easy"
		1:
			difficulty_button.text = "Medium"
		2:
			difficulty_button.text = "Hard"
			
	if Autoload.mobile_layout:
		for button in list_of_buttons:
			button.add_theme_font_size_override("font_size", 60)
		multiplayer_button.queue_free()
			
	get_tree().set_auto_accept_quit(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var node = get_parent().get_node("")
	pass


func _on_settings_pressed():
	get_tree().change_scene_to_file("res://settings.tscn")
	
func _on_pedia_pressed():
	get_tree().change_scene_to_file("res://pedia.tscn")


func _on_difficulty_pressed():
	select_sound.play()
	Autoload.difficulty += 1
	if Autoload.difficulty > 2:
		Autoload.difficulty = -1
		
	match Autoload.difficulty:
		-1:
			difficulty_button.text = "Baby"
		0:
			difficulty_button.text = "Easy"
		1:
			difficulty_button.text = "Medium"
		2:
			difficulty_button.text = "Hard"


func _on_exit_pressed():
	get_tree().quit()


func _on_play_pressed():
	Autoload.playercount = 1
	get_tree().change_scene_to_file("res://main.tscn")
	
func _on_multiplayer_pressed():
	Autoload.playercount = 2
	get_tree().change_scene_to_file("res://main.tscn")
