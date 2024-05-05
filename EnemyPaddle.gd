extends CharacterBody2D

@export var ball: Ball

var current_movement: float = 0

var speed: float = 5

func _process(delta):
	var target_movement
	
	if ball.transform.origin.y > transform.origin.y:
		target_movement = 1
	elif ball.transform.origin.y < transform.origin.y:
		target_movement = -1
	else:
		target_movement = 0
		
	current_movement = lerpf(target_movement, current_movement, 1 - delta*10)
		
	move_and_collide(Vector2(0, current_movement * speed * delta * 60))
	
	speed = 5 + ball.player_score_val
