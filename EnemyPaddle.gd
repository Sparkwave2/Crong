extends CharacterBody2D

@export var ball: Ball
@export var ball_prediction: CharacterBody2D
@export var ball_prediction2: CharacterBody2D
@export var ball_prediction3: CharacterBody2D

var current_movement: float = 0

var speed: float = 5

func _process(delta):
	var target_movement
	var distance_from_ball = transform.origin.x - ball.transform.origin.x # Distance from enemy paddle to ball, for the purpose of math
	
	var space_state = get_world_2d().direct_space_state # use global coordinates, not local to node
	
	# TIME TO ENGAGE THE JANK PREDICTION ENGINE!
	# First let's shoot a ray from the ball to the direction it's travelling
	# We're shooting from slightly ahead of it because otherwise it collides with itself
	var query = PhysicsRayQueryParameters2D.create(ball.transform.origin + ball.ball_velocity * 10, ball.transform.origin + ball.ball_velocity * 10000, 0b00000000_00000000_00000000_00000010)
	var result = space_state.intersect_ray(query)
	if result: # If hit...
		if result["collider"].name != "PredictionWall":
			# Is it the prediction wall? If no, then we'll bounce
			var bouncepos: Vector2 = result["position"]
			var bouncenorm: Vector2 = result["normal"]
			# Set prediction 1 at the bounce point
			ball_prediction.transform.origin = bouncepos
			# And then shoot another ray, from prediction 1 to the mirrored direction
			# Unfortunately this only works with Y mirroring but is good enough for now
			var query2 = PhysicsRayQueryParameters2D.create(ball_prediction.transform.origin + (Vector2(ball.ball_velocity.x, -ball.ball_velocity.y)) * 10, ball_prediction.transform.origin + (Vector2(ball.ball_velocity.x, -ball.ball_velocity.y) * 10000), 0b00000000_00000000_00000000_00000010)
			var result2 = space_state.intersect_ray(query2)
			
			if result2 and result2["collider"].name != "PredictionWall":
				# If that one hits too, then that means we have a double bounce
				var bouncepos2: Vector2 = result2["position"]
				var bouncenorm2: Vector2 = result2["normal"]
				# Set prediction 2 as the second bounce point
				ball_prediction2.transform.origin = bouncepos2
				# And then shoot the last ray from there, in the original direction because -1 * -1 = 1
				var query3 = PhysicsRayQueryParameters2D.create(ball_prediction2.transform.origin + ball.ball_velocity * 10, ball_prediction2.transform.origin + ball.ball_velocity * 10000, 0b00000000_00000000_00000000_00000010)
				var result3 = space_state.intersect_ray(query3)
				
				if result3: # Welp, this is the best we can do, so don't check what it collides with
					var bouncepos3: Vector2 = result3["position"]
					var bouncenorm3: Vector2 = result3["normal"]
					# Set prediction 3 as the third and last bounce point
					ball_prediction3.transform.origin = bouncepos3
					#print("Double bounce detected, using prediction3...")
					#print("We are going to bounce off of " + result["collider"].name + ", then again off of " + result2["collider"].name + " and finally hit " + result3["collider"].name)
			elif result2 and result2["collider"].name == "PredictionWall":
				# Seems like we're not going to bounce a second time after all, set the variables
				ball_prediction2.transform.origin = result2["position"]
				ball_prediction3.transform.origin = ball_prediction2.transform.origin
				#print("Single bounce detected, using prediction2...")
				#print("We are going to bounce off of " + result["collider"].name + " and then hit " + result2["collider"].name)
			else:
				# Confused state, let's fall back to what we know
				ball_prediction2.transform.origin = result["position"]
				ball_prediction3.transform.origin = ball_prediction2.transform.origin
				#print("Error detecting second bounce, using prediction1...")
				#print("We are going to bounce off of " + result["collider"].name + " and then god knows what")
		elif result["collider"].name == "PredictionWall":
			# If yes, then we won't bounce, use direct line
			ball_prediction.transform.origin = result["position"]
			ball_prediction2.transform.origin = result["position"]
			ball_prediction3.transform.origin = result["position"]
			#print("No bounce detected, using prediction1...")
			#print("We are going to hit " + result["collider"].name)
	else:
		ball_prediction.transform.origin = ball.transform.origin
		ball_prediction2.transform.origin = ball.transform.origin
		ball_prediction3.transform.origin = ball.transform.origin
		#print("Cannot find ball trajectory, using ball position...")
		#print("No clue what we're going to hit")
		
		
	# JANK PREDICTION ENGINE OVER!
	
	var actual_prediction: Vector2
	match Autoload.difficulty:
		0:
			# If easy, then just use the first collision point every single time
			actual_prediction = ball_prediction.transform.origin
		1:
			# If medium, use the collision point after the first bounce
			actual_prediction = ball_prediction2.transform.origin
		2:
			# If hard, use the collision point after 2 bounces
			actual_prediction = ball_prediction3.transform.origin
		
	if actual_prediction.y > transform.origin.y:
		target_movement = 1
	elif actual_prediction.y < transform.origin.y:
		target_movement = -1
	else:
		target_movement = 0
		
	
		
	current_movement = lerpf(target_movement, current_movement, 1 - delta*10)
		
	move_and_collide(Vector2(0, current_movement * speed * delta * 60))
	
	#speed = 5 + ball.player_score_val
