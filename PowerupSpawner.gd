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
		match randi_range(0, 2):
			0:
				instance.name = "PowerupTallPaddle"
				instance.get_node("Sprite").modulate = Color.ORANGE
				instance.get_node("GPUParticles2D").modulate = Color.ORANGE
			1:
				instance.name = "PowerupSpeedBoost"
				instance.get_node("Sprite").modulate = Color.CYAN
				instance.get_node("GPUParticles2D").modulate = Color.CYAN
			2:
				instance.name = "PowerupObstacle"
				instance.get_node("Sprite").modulate = Color.GREEN
				instance.get_node("GPUParticles2D").modulate = Color.GREEN
	pass
