extends CharacterBody2D

@export var speed = 400
@export var rotation_speed = 1.5

var rotation_direction = 0

var target : Vector2 = position

func get_8way_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
#	var dx = Input.get_action_strength("right")-Input.get_action_strength("left")
#	var dy = Input.get_action_strength("down")-Input.get_action_strength("up")
#	var delta = Vector2(dx,dy)
#	print(delta)
	#print(input_direction)
	velocity = input_direction * speed
	
func get_rotation_input():
	rotation_direction = Input.get_axis("left", "right")
	#print("Direção: ",rotation_direction)
	velocity = transform.x * Input.get_axis("down", "up") * speed
	#print(transform.x)
	
func get_mouse_rotation():
	look_at(get_global_mouse_position())
	#print(transform.x)
	velocity = transform.x * Input.get_axis("down", "up") * speed

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			target = get_global_mouse_position()
			print(target)

func _physics_process(delta: float) -> void:
	# Descomente o bloco desejado de acordo com o tipo
	# de movimento:
	
	# 1. 8-way movement
	#get_8way_input()
	
	# 2. Rotation + movement
	#get_rotation_input()
	#rotation += rotation_direction * rotation_speed * delta
	
	# 3. Mouse rotation + movement
	#get_mouse_rotation()
	
	# 4. Mouse click + movement
	velocity = position.direction_to(target) * speed
	print(velocity)
	#look_at(target)
	if position.distance_to(target) > 5:
		move_and_slide()
	
	# Descomente para todos os outros (1, 2 e 3)
	#move_and_slide()
