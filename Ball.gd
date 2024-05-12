extends CharacterBody2D
class_name Ball

@export var player_score: Label
@export var enemy_score: Label

@export var player_paddle: CharacterBody2D
@export var enemy_paddle: CharacterBody2D

@export var paddle_sound_player: AudioStreamPlayer
@export var wall_sound_player: AudioStreamPlayer
@export var score_sound_player: AudioStreamPlayer
@export var powerup_sound_player: AudioStreamPlayer

@export var collision_particles: Array[GPUParticles2D]
@export var victory_particles: Array[GPUParticles2D]

@export var powerup_spawner: Node2D

var which_collision_particles = 0
var which_victory_particles = 0

var player_score_val = 0
var enemy_score_val = 0

var ball_velocity = Vector2(1, 1)

var timer = 30

var lasthit = 0
# 0 - Unknown
# 1 - Player
# 2 - Enemy

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _process(delta):
	var collision = move_and_collide(ball_velocity * delta * 200)
	if collision:
		var collider = collision.get_collider()
		if collider.name in ["UpDownWall", "PlayerObstacle", "EnemyObstacle"]:
			var bounce = ball_velocity.bounce(collision.get_normal())
			ball_velocity = Vector2(bounce.x, (bounce.y))
			var mat: ParticleProcessMaterial = collision_particles[which_collision_particles].process_material
			mat.direction = Vector3(collision.get_normal().x, collision.get_normal().y, 0)
			collision_particles[which_collision_particles].emitting = true
			which_collision_particles += 1
			if which_collision_particles > 3:
				which_collision_particles = 0
			wall_sound_player.pitch_scale = randf_range(0.8, 1.2)
			wall_sound_player.play()
			Input.vibrate_handheld(50)
			Input.start_joy_vibration(0, 0, 1, 0.05)
		if collider.name == "PlayerWall":
			enemy_score_val += 1
			enemy_score.text = str(enemy_score_val)
			victory_particles[which_victory_particles].transform.origin = transform.origin
			var mat: ParticleProcessMaterial = victory_particles[which_victory_particles].process_material
			mat.direction = Vector3(collision.get_normal().x, collision.get_normal().y, 0)
			mat.color = Autoload.player_color
			victory_particles[which_victory_particles].emitting = true
			which_victory_particles += 1
			if which_victory_particles > 1:
				which_victory_particles = 0
			reset_pos()
			score_sound_player.play()
			Input.vibrate_handheld(100)
			Input.start_joy_vibration(0, 0, 1, 0.1)
			lasthit = 0
		if collider.name == "EnemyWall":
			player_score_val += 1
			player_score.text = str(player_score_val)
			victory_particles[which_victory_particles].transform.origin = transform.origin
			var mat: ParticleProcessMaterial = victory_particles[which_victory_particles].process_material
			mat.direction = Vector3(collision.get_normal().x, collision.get_normal().y, 0)
			mat.color = Autoload.enemy_color
			victory_particles[which_victory_particles].emitting = true
			which_victory_particles += 1
			if which_victory_particles > 1:
				which_victory_particles = 0
			reset_pos()
			score_sound_player.play()
			Input.vibrate_handheld(100)
			Input.start_joy_vibration(0, 0, 1, 0.1)
			lasthit = 0
		if collider.name == "Player Paddle":
			#ball_velocity = Vector2(-ball_velocity.x, ball_velocity.y + collider.current_movement * 0.5) * 1.1
			var bounce = ball_velocity.bounce(collision.get_normal())
			ball_velocity = Vector2(bounce.x, bounce.y + collider.current_movement * 0.5) * 1.1
			paddle_sound_player.pitch_scale = randf_range(0.8, 1.2)
			paddle_sound_player.play()
			
			var mat: ParticleProcessMaterial = collision_particles[which_collision_particles].process_material
			mat.direction = Vector3(collision.get_normal().x, collision.get_normal().y, 0)
			collision_particles[which_collision_particles].emitting = true
			which_collision_particles += 1
			if which_collision_particles > 3:
				which_collision_particles = 0
			Input.vibrate_handheld(50)
			Input.start_joy_vibration(0, 0, 1, 0.05)
			lasthit = 1
		if collider.name == "Enemy Paddle":
			var bounce = ball_velocity.bounce(collision.get_normal())
			ball_velocity = Vector2(bounce.x, bounce.y + collider.current_movement * 0.5) * 1.1
			paddle_sound_player.pitch_scale = randf_range(0.8, 1.2)
			paddle_sound_player.play()
			
			var mat: ParticleProcessMaterial = collision_particles[which_collision_particles].process_material
			mat.direction = Vector3(collision.get_normal().x, collision.get_normal().y, 0)
			collision_particles[which_collision_particles].emitting = true
			which_collision_particles += 1
			if which_collision_particles > 3:
				which_collision_particles = 0
			Input.vibrate_handheld(50)
			Input.start_joy_vibration(0, 0, 1, 0.05)
			lasthit = 2
		if "PowerupTallPaddle" in collider.name:
			powerup_sound_player.play()
			Input.vibrate_handheld(50)
			Input.start_joy_vibration(0, 0, 1, 0.05)
			if lasthit == 1:
				Autoload.player_powerup = 1
				Autoload.player_powerup_timer = 600
			elif lasthit == 2:
				Autoload.enemy_powerup = 1
				Autoload.enemy_powerup_timer = 600
			collider.queue_free()
		if "PowerupSpeedBoost" in collider.name:
			powerup_sound_player.play()
			Input.vibrate_handheld(50)
			Input.start_joy_vibration(0, 0, 1, 0.05)
			if lasthit == 1:
				Autoload.player_powerup = 2
				Autoload.player_powerup_timer = 600
			elif lasthit == 2:
				Autoload.enemy_powerup = 2
				Autoload.enemy_powerup_timer = 600
			collider.queue_free()
		if "PowerupObstacle" in collider.name:
			powerup_sound_player.play()
			Input.vibrate_handheld(50)
			Input.start_joy_vibration(0, 0, 1, 0.05)
			if lasthit == 1:
				Autoload.player_powerup = 3
				Autoload.player_powerup_timer = 600
			elif lasthit == 2:
				Autoload.enemy_powerup = 3
				Autoload.enemy_powerup_timer = 600
			collider.queue_free()
		ball_velocity = Vector2(ball_velocity.x, clampf(ball_velocity.y, -3, 3))
		
func reset_pos():
	transform.origin = Vector2(254, 328)
	player_paddle.transform.origin = Vector2(34, 324)
	enemy_paddle.transform.origin = Vector2(1118, 324)
	ball_velocity = Vector2(1, 1)
	Autoload.player_powerup = 0
	Autoload.player_powerup_timer = 0
	Autoload.enemy_powerup = 0
	Autoload.enemy_powerup_timer = 0
	for child in powerup_spawner.get_children():
		powerup_spawner.remove_child(child)
		child.queue_free()
