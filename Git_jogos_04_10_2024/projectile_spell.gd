extends CharacterBody2D


const SPEED = 500


var spawnPos: Vector2
var spawnRot: float

func _ready():
	global_position = Vector2(spawnPos.x + 20, spawnPos.y + 4)
	global_rotation = spawnRot
	
func _physics_process(delta):
	velocity = Vector2(SPEED, 0)
	move_and_slide()
	if is_on_wall():
		queue_free()
	
func _on_area_2d_body_entered(body: Node2D):
	print("HIT")
	queue_free()
	
func damage():
	return 10		
	
