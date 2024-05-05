extends HBoxContainer

@export var difficulty_button: Button
@export var exit_button: Button

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
		0:
			difficulty_button.text = "Easy"
		1:
			difficulty_button.text = "Medium"
		2:
			difficulty_button.text = "Hard"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_settings_pressed():
	get_tree().change_scene_to_file("res://settings.tscn")


func _on_difficulty_pressed():
	select_sound.play()
	Autoload.difficulty += 1
	if Autoload.difficulty > 2:
		Autoload.difficulty = 0
		
	match Autoload.difficulty:
		0:
			difficulty_button.text = "Easy"
		1:
			difficulty_button.text = "Medium"
		2:
			difficulty_button.text = "Hard"


func _on_exit_pressed():
	get_tree().quit()


func _on_play_pressed():
	get_tree().change_scene_to_file("res://main.tscn")
