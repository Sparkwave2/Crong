extends VBoxContainer

@export var powerup_particles: GPUParticles2D
@export var powerup_sprite: Sprite2D

@export var title_text: RichTextLabel
@export var description_text: RichTextLabel

@export var select_sound: AudioStreamPlayer
@export var exit_sound: AudioStreamPlayer

var selected_powerup = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	select_sound.play()
	refresh()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_previous_pressed():
	select_sound.play()
	selected_powerup -= 1
	if selected_powerup < 1:
		selected_powerup = 8
	refresh()


func _on_next_pressed():
	select_sound.play()
	selected_powerup += 1
	if selected_powerup > 8:
		selected_powerup = 1
	refresh()

func refresh():
	match selected_powerup:
		1:
			title_text.text = "Tall Paddle"
			description_text.text = "Makes your paddle 1.5x taller, making it easier to hit the ball. The paddle also has to travel less to reach the edges."
			powerup_particles.modulate = Color.ORANGE
			powerup_sprite.modulate = Color.ORANGE
		2:
			title_text.text = "Speed Boost"
			description_text.text = "Increases your paddle's max speed, so you can catch up with the ball easier. This one is especially powerful."
			powerup_particles.modulate = Color.CYAN
			powerup_sprite.modulate = Color.CYAN
		3:
			title_text.text = "Obstacle"
			description_text.text = "Adds an obstacle in front of your paddle to help you deflect the ball. Be careful, as it may bounce it back towards you and cost you a point."
			powerup_particles.modulate = Color.GREEN
			powerup_sprite.modulate = Color.GREEN
		4:
			title_text.text = "Fastball"
			description_text.text = "Makes the ball temporarily 1.5x faster if you were the last one to hit it. Goes back to normal afterwards or when hit by the opponent."
			powerup_particles.modulate = Color.BLUE
			powerup_sprite.modulate = Color.BLUE
		5:
			title_text.text = "Gravity"
			description_text.text = "Adds some gravity to the ball, making it way harder to predict. A sure win against the AI."
			powerup_particles.modulate = Color.DARK_GREEN
			powerup_sprite.modulate = Color.DARK_GREEN
		6:
			title_text.text = "Vert Boost"
			description_text.text = "Increases the maximum vertical speed of the ball. Make sure to hit it while moving at max speed!"
			powerup_particles.modulate = Color.YELLOW
			powerup_sprite.modulate = Color.YELLOW
		7:
			title_text.text = "RC Ball"
			description_text.text = "Lets you control the ball a bit by moving your paddle. Ineffective against AI, but might be good in multiplayer."
			powerup_particles.modulate = Color.PURPLE
			powerup_sprite.modulate = Color.PURPLE
		8:
			title_text.text = "Chrono Field"
			description_text.text = "Adds a forcefield that slows down the ball by 50% when in proximity."
			powerup_particles.modulate = Color.MEDIUM_SPRING_GREEN
			powerup_sprite.modulate = Color.MEDIUM_SPRING_GREEN


func _on_back_pressed():
	get_tree().change_scene_to_file("res://menu.tscn")
