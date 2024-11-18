extends CanvasLayer

@export var hearts : Array[Node]
@onready var animation_player: AnimationPlayer = $"../Player/AnimationPlayer"

var lives = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func decrease_health():
	#lives -= 1
	#print(lives)
	#animation_player.play("Flash")
	get_tree().change_scene_to_file("res://Our_game_scenes/game_over_continue.tscn")
	#for h in 3:
	#	if (h <lives):
	#		hearts[h].show()
	#	else:
	#		hearts[h].hide()
	#if(lives == 0):
	#	get_tree().change_scene_to_file("res://Our_game_scenes/game_over_continue.tscn")
