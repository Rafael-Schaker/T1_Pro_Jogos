extends Area2D
@onready var game_manager = $"../../CanvasLayer"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if (body.name == "Player"):
		game_manager.decrease_health()
		#game_manager.decrease_health()
		#game_manager.decrease_health()

	pass # Replace with function body.
