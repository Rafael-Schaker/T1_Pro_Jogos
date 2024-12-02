extends CharacterBody2D

@export var SPEED = 100

var dir: float
var spawnPos: Vector2
var spawnRot: float

func _ready() -> void:
	global_position = spawnPos
	global_rotation = spawnRot
	
	
func _physics_process(delta):
	velocity = Vector2(SPEED,0)
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D):
	print("HIT")
	queue_free()
	
