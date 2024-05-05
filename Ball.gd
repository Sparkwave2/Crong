extends CharacterBody2D
class_name Ball

@export var player_score: Label
@export var enemy_score: Label

@export var player_paddle: CharacterBody2D
@export var enemy_paddle: CharacterBody2D

@export var paddle_sound_player: AudioStreamPlayer
@export var wall_sound_player: AudioStreamPlayer
@export var score_sound_player: AudioStreamPlayer

var player_score_val = 0
var enemy_score_val = 0

var ball_velocity = Vector2(1, 1)

var last_bounce = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _process(delta):
	var collision = move_and_collide(ball_velocity * delta * 200)
	if collision:
		var collider = collision.get_collider()
		match collider.name:
			"UpDownWall":
				ball_velocity = Vector2(ball_velocity.x + 0.2, -ball_velocity.y + 0.2)
				wall_sound_player.play()
			"PlayerWall":
				enemy_score_val += 1
				enemy_score.text = str(enemy_score_val)
				reset_pos()
				score_sound_player.play()
			"EnemyWall":
				player_score_val += 1
				player_score.text = str(player_score_val)
				reset_pos()
				score_sound_player.play()
			"Player Paddle":
				ball_velocity = Vector2(-ball_velocity.x, ball_velocity.y + collider.current_movement * 0.5) * 1.1
				paddle_sound_player.play()
				last_bounce = 0
			"Enemy Paddle":
				ball_velocity = Vector2(-ball_velocity.x, ball_velocity.y + collider.current_movement * 0.5) * 1.1
				paddle_sound_player.play()
				last_bounce = 1
		ball_velocity = Vector2(ball_velocity.x, clampf(ball_velocity.y, -3, 3))
		
func reset_pos():
	transform.origin = Vector2(254, 328)
	player_paddle.transform.origin = Vector2(34, 324)
	enemy_paddle.transform.origin = Vector2(1118, 324)
	ball_velocity = Vector2(1, 1)
