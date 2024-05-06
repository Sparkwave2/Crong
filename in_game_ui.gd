extends Node2D
class_name InGameUI

@export var hold_to_exit_text: Label

var exit_progress = 0

@export var trails: Array[GPUParticles2D]

@export var pause_screen: PauseScreen
@export var pause_sound: AudioStreamPlayer
@export var mobile_pause_button: Button

var pause_timer = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	if Autoload.trails == 0:
		for trail in trails:
			trail.queue_free()
	if Autoload.mobile_layout:
		get_tree().set_auto_accept_quit(false)
	else:
		mobile_pause_button.queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if Input.is_key_pressed(KEY_Q):
	#	exit_progress += delta * 100
	#elif exit_progress > 0:
	#	exit_progress -= delta * 100
		
	#if exit_progress > 100:
	#	get_tree().change_scene_to_file("res://menu.tscn")
		
	if Input.is_action_just_pressed("pause"):
		pause_timer = 10
		pause_sound.play()
		pause_screen.show()
		get_tree().paused = true
		
	#hold_to_exit_text.modulate = Color(255, 255, 255, exit_progress * 2.55)
	
func _physics_process(delta):
	pause_timer -= 1
	
	var screen_size = get_viewport().get_visible_rect().size
	var rng = RandomNumberGenerator.new()
	var rnd_x = rng.randi_range(20, screen_size.x-20)
	var rnd_y = rng.randi_range(20, screen_size.y-20)
	var randompos = Vector2(rnd_x, rnd_y)
	
	
	
func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST and Autoload.mobile_layout:
		pause_sound.play()
		pause_screen.show()
		get_tree().paused = true


func _on_pause_button_pressed():
	pause_sound.play()
	pause_screen.show()
	get_tree().paused = true
