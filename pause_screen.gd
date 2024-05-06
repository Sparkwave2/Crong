extends ColorRect
class_name PauseScreen

@export var pause_sound: AudioStreamPlayer

@export var in_game_ui: InGameUI

@export var list_of_buttons: Array[Button]


# Called when the node enters the scene tree for the first time.
func _ready():
	if Autoload.mobile_layout:
		for button in list_of_buttons:
			button.add_theme_font_size_override("font_size", 60)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("pause") and in_game_ui.pause_timer < 0:
		pause_sound.play()
		in_game_ui.pause_timer = 10
		hide()
		get_tree().paused = false
		
func _physics_process(delta):
	in_game_ui.pause_timer -= 1


func _on_continue_pressed():
	pause_sound.play()
	hide()
	get_tree().paused = false
	
func _on_quit_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://menu.tscn")
	
func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST and Autoload.mobile_layout:
		pause_sound.play()
		hide()
		get_tree().paused = false
