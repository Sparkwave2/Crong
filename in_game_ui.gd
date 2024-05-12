extends Node2D
class_name InGameUI

@export var hold_to_exit_text: Label

var exit_progress = 0

@export var trails: Array[GPUParticles2D]
@export var particles: Array[GPUParticles2D]
@export var colorable_sprites: Array[Sprite2D]

@export var pause_screen: PauseScreen
@export var pause_sound: AudioStreamPlayer
@export var mobile_pause_button: Button

@export var player_powerup_text: Label
@export var enemy_powerup_text: Label

@export var player_obstacle: StaticBody2D
@export var enemy_obstacle: StaticBody2D

var pause_timer = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	if Autoload.trails == 0:
		for trail in trails:
			trail.modulate = Color.TRANSPARENT
	else:
		trails[0].modulate = Autoload.player_color
		trails[1].modulate = Autoload.ball_color
		trails[2].modulate = Autoload.enemy_color
	if Autoload.particles == 0:
		for particle in particles:
			particle.modulate = Color.TRANSPARENT
	else:
		particles[2].modulate = Autoload.ball_color
		particles[3].modulate = Autoload.ball_color
		particles[4].modulate = Autoload.ball_color
		particles[5].modulate = Autoload.ball_color
	if Autoload.mobile_layout:
		get_tree().set_auto_accept_quit(false)
	else:
		mobile_pause_button.queue_free()
	
	colorable_sprites[0].modulate = Autoload.player_color
	colorable_sprites[1].modulate = Autoload.ball_color
	colorable_sprites[2].modulate = Autoload.enemy_color
	


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
	
	match Autoload.player_powerup:
		0:
			player_powerup_text.modulate = Color.TRANSPARENT
			player_obstacle.get_node("CollisionShape2D").disabled = true
			player_obstacle.hide()
		1:
			player_powerup_text.modulate = Color.ORANGE
			player_powerup_text.text = "Tall Paddle " + str(Autoload.player_powerup_timer/60)
			player_obstacle.get_node("CollisionShape2D").disabled = true
			player_obstacle.hide()
		2:
			player_powerup_text.modulate = Color.CYAN
			player_powerup_text.text = "Speed Boost " + str(Autoload.player_powerup_timer/60)
			player_obstacle.get_node("CollisionShape2D").disabled = true
			player_obstacle.hide()
		3:
			player_powerup_text.modulate = Color.GREEN
			player_powerup_text.text = "Obstacle " + str(Autoload.player_powerup_timer/60)
			player_obstacle.get_node("CollisionShape2D").disabled = false
			player_obstacle.get_node("Sprite2D").modulate = Autoload.player_color
			player_obstacle.show()
	match Autoload.enemy_powerup:
		0:
			enemy_powerup_text.modulate = Color.TRANSPARENT
			enemy_obstacle.get_node("CollisionShape2D").disabled = true
			enemy_obstacle.hide()
		1:
			enemy_powerup_text.modulate = Color.ORANGE
			enemy_powerup_text.text = str(Autoload.enemy_powerup_timer/60) + " Tall Paddle"
			enemy_obstacle.get_node("CollisionShape2D").disabled = true
			enemy_obstacle.hide()
		2:
			enemy_powerup_text.modulate = Color.CYAN
			enemy_powerup_text.text = str(Autoload.enemy_powerup_timer/60) + " Speed Boost"
			enemy_obstacle.get_node("CollisionShape2D").disabled = true
			enemy_obstacle.hide()
		3:
			enemy_powerup_text.modulate = Color.GREEN
			enemy_powerup_text.text = str(Autoload.enemy_powerup_timer/60) + " Obstacle"
			enemy_obstacle.get_node("CollisionShape2D").disabled = false
			enemy_obstacle.get_node("Sprite2D").modulate = Autoload.enemy_color
			enemy_obstacle.show()
		
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
