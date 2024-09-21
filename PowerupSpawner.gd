extends Node2D

@export var powerup: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):
	if randi_range(0, 1000) == 0:
		var instance = powerup.instantiate()
		add_child(instance)
		instance.position = Vector2(randi_range(60, 1118-60), randi_range(20, 648-20))
		match randi_range(0, 7):
			0:
				instance.name = "PowerupTallPaddle"
				instance.get_node("Sprite").modulate = Color.ORANGE
				instance.get_node("GPUParticles2D").modulate = Color.ORANGE
				instance.get_node("Label").text = "Tall Paddle"
			1:
				instance.name = "PowerupSpeedBoost"
				instance.get_node("Sprite").modulate = Color.CYAN
				instance.get_node("GPUParticles2D").modulate = Color.CYAN
				instance.get_node("Label").text = "Speed Boost"
			2:
				instance.name = "PowerupObstacle"
				instance.get_node("Sprite").modulate = Color.GREEN
				instance.get_node("GPUParticles2D").modulate = Color.GREEN
				instance.get_node("Label").text = "Obstacle"
			3:
				instance.name = "PowerupFastball"
				instance.get_node("Sprite").modulate = Color.BLUE
				instance.get_node("GPUParticles2D").modulate = Color.BLUE
				instance.get_node("Label").text = "Fastball"
			4:
				instance.name = "PowerupGravity"
				instance.get_node("Sprite").modulate = Color.DARK_GREEN
				instance.get_node("GPUParticles2D").modulate = Color.DARK_GREEN
				instance.get_node("Label").text = "Gravity"
			5:
				instance.name = "PowerupVertBoost"
				instance.get_node("Sprite").modulate = Color.YELLOW
				instance.get_node("GPUParticles2D").modulate = Color.YELLOW
				instance.get_node("Label").text = "Vert Boost"
			6:
				instance.name = "PowerupRCBall"
				instance.get_node("Sprite").modulate = Color.PURPLE
				instance.get_node("GPUParticles2D").modulate = Color.PURPLE
				instance.get_node("Label").text = "RC Ball"
			7:
				instance.name = "PowerupChronoField"
				instance.get_node("Sprite").modulate = Color.MEDIUM_SPRING_GREEN
				instance.get_node("GPUParticles2D").modulate = Color.MEDIUM_SPRING_GREEN
				instance.get_node("Label").text = "Chrono Field"
	pass
