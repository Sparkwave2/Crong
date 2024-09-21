extends Node2D
class_name LevelSpawner

@export var levels: Array[PackedScene]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):
	pass
	
func spawn_level():
	clear_children()
	var level = levels.pick_random()
	var instance = level.instantiate()
	add_child(instance)
	
func clear_children():
	for child in get_children():
		remove_child(child)
		child.queue_free()
