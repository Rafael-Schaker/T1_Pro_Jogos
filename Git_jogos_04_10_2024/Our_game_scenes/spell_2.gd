extends RigidBody2D

@onready var game_manager = $"../../CanvasLayer"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if (body.name == "Player"):
		var y_delta = position.y - body.position.y
		var x_delta = position.x - body.position.x
		#game_manager.decrease_health()
		#game_manager.decrease_health()
		#game_manager.decrease_health()
		get_tree().change_scene_to_file("res://Our_game_scenes/continue.tscn")
	pass # Replace with function body.
