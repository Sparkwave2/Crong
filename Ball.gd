extends CharacterBody2D
class_name Ball

@export var player_score: Label
@export var enemy_score: Label

@export var player_paddle: PlayerPaddle
@export var enemy_paddle: EnemyPaddle

@export var paddle_sound_player: AudioStreamPlayer
@export var wall_sound_player: AudioStreamPlayer
@export var score_sound_player: AudioStreamPlayer
@export var powerup_sound_player: AudioStreamPlayer

@export var collision_particles: Array[GPUParticles2D]
@export var victory_particles: Array[GPUParticles2D]

@export var powerup_spawner: Node2D
@export var level_spawner: LevelSpawner

var which_collision_particles = 0
var which_victory_particles = 0

var player_score_val = 0
var enemy_score_val = 0

var ball_velocity = Vector2(1, 1)

var speed_mult = 1

var timer = 30

var lasthit = 0
# 0 - Unknown
# 1 - Player
# 2 - Enemy

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _process(delta):
	if Autoload.player_powerup == 4 and lasthit == 1:
		speed_mult = 1.5
	elif Autoload.enemy_powerup == 4 and lasthit == 2:
		speed_mult = 1.5
	elif Autoload.player_powerup == 8 and position.distance_to(player_paddle.position) <= 200:
		speed_mult = 0.5
	elif Autoload.enemy_powerup == 8 and position.distance_to(enemy_paddle.position) <= 200:
		speed_mult = 0.5
	else:
		speed_mult = 1
	if Autoload.player_powerup == 5 and lasthit == 1:
		ball_velocity -= Vector2(0, -10 * delta)
	elif Autoload.enemy_powerup == 5 and lasthit == 2:
		ball_velocity -= Vector2(0, -10 * delta)
		
	if Autoload.player_powerup == 7 and lasthit == 1:
		ball_velocity.y += player_paddle.current_movement * delta * 2
	elif Autoload.enemy_powerup == 7 and lasthit == 2:
		ball_velocity.y += enemy_paddle.current_movement * delta * 2
		
	var collision = move_and_collide(ball_velocity * delta * speed_mult * 200)
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
		if "StageObstacle" in collider.name:
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
			if lasthit == 1:
				Autoload.player_powerup = 1
				Autoload.player_powerup_timer = 600
			elif lasthit == 2:
				Autoload.enemy_powerup = 1
				Autoload.enemy_powerup_timer = 600
		if "PowerupSpeedBoost" in collider.name:
			if lasthit == 1:
				Autoload.player_powerup = 2
				Autoload.player_powerup_timer = 600
			elif lasthit == 2:
				Autoload.enemy_powerup = 2
				Autoload.enemy_powerup_timer = 600
		if "PowerupObstacle" in collider.name:
			if lasthit == 1:
				Autoload.player_powerup = 3
				Autoload.player_powerup_timer = 600
			elif lasthit == 2:
				Autoload.enemy_powerup = 3
				Autoload.enemy_powerup_timer = 600
		if "PowerupFastball" in collider.name:
			if lasthit == 1:
				Autoload.player_powerup = 4
				Autoload.player_powerup_timer = 600
			elif lasthit == 2:
				Autoload.enemy_powerup = 4
				Autoload.enemy_powerup_timer = 600
		if "PowerupGravity" in collider.name:
			if lasthit == 1:
				Autoload.player_powerup = 5
				Autoload.player_powerup_timer = 600
			elif lasthit == 2:
				Autoload.enemy_powerup = 5
				Autoload.enemy_powerup_timer = 600
		if "PowerupVertBoost" in collider.name:
			if lasthit == 1:
				Autoload.player_powerup = 6
				Autoload.player_powerup_timer = 600
			elif lasthit == 2:
				Autoload.enemy_powerup = 6
				Autoload.enemy_powerup_timer = 600
		if "PowerupRCBall" in collider.name:
			if lasthit == 1:
				Autoload.player_powerup = 7
				Autoload.player_powerup_timer = 600
			elif lasthit == 2:
				Autoload.enemy_powerup = 7
				Autoload.enemy_powerup_timer = 600
		if "PowerupChronoField" in collider.name:
			if lasthit == 1:
				Autoload.player_powerup = 8
				Autoload.player_powerup_timer = 600
			elif lasthit == 2:
				Autoload.enemy_powerup = 8
				Autoload.enemy_powerup_timer = 600
		if "Powerup" in collider.name:
			powerup_sound_player.play()
			Input.vibrate_handheld(50)
			Input.start_joy_vibration(0, 0, 1, 0.05)
			collider.queue_free()
			
	if Autoload.player_powerup == 5 and lasthit == 1:
		return
	elif Autoload.enemy_powerup == 5 and lasthit == 2:
		return
		
	if Autoload.player_powerup == 6 and lasthit == 1:
		ball_velocity = Vector2(ball_velocity.x, clampf(ball_velocity.y, -6, 6))
	elif Autoload.enemy_powerup == 6 and lasthit == 2:
		ball_velocity = Vector2(ball_velocity.x, clampf(ball_velocity.y, -6, 6))
	else:
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
	level_spawner.spawn_level()
