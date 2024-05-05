extends Node2D

@export var hold_to_exit_text: Label

var exit_progress = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_key_pressed(KEY_ESCAPE) or Input.is_key_pressed(KEY_Q):
		exit_progress += delta * 100
	elif exit_progress > 0:
		exit_progress -= delta * 100
		
	if exit_progress > 100:
		get_tree().change_scene_to_file("res://menu.tscn")
		
	hold_to_exit_text.modulate = Color(255, 255, 255, exit_progress * 2.55)
