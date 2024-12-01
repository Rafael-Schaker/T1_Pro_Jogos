extends RigidBody2D

@onready var game_manager = $"../../CanvasLayer"
@onready var health = 10
@onready var detect_box = $DetectFloor


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if (body.name == "Player"):
		for child in body.get_children():
			if child.name == "AttackShapeRight" or child.name == "AttackShapeLeft":
				if child.disabled == false:
					hit(body.damage())
					return
					
		var y_delta = position.y - body.position.y
		var x_delta = position.x - body.position.x
		print(y_delta)
		game_manager.decrease_health()
		if (x_delta > 0):
			body.jump_side(500)
		else: 
			body.jump_side(-500)
	

	
func hit(damage) -> void:
	health -= damage
	if health <= 0 :
		await get_tree().create_timer(0.).timeout
		self.queue_free()
	
	
