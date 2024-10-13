extends CharacterBody2D

@export var speed := 300.0
@export var jump_speed := -2000.0
@export var gravity := 4000.0
@export var box : PackedScene

@onready var sprite := $PlayerSprite
@onready var jumpSound := $JumpSound

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("filter"):
		var filtro := AudioServer.get_bus_effect(1, 0) as AudioEffectLowPassFilter
		# Liga/desliga o efeito (na verdade, só troca a frequência de corte)
		if filtro.cutoff_hz == 500:
			filtro.cutoff_hz = 20500
		else:
			filtro.cutoff_hz = 500
	
func get_8way_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	
func get_side_input():
	velocity.x = 0
	var vel := Input.get_axis("left", "right")
	var jump := Input.is_action_just_pressed("jump")

	if is_on_floor() and jump:		
		velocity.y = jump_speed
		get_tree().call_group("HUD", "updateScore")
		if not jumpSound.playing:
			jumpSound.play()
		# cria uma caixa na posição do jogador
		var b := box.instantiate()
		b.position = global_position
		owner.add_child(b)
	velocity.x = vel * speed
	
func animate():
	if velocity.x > 0:
		sprite.play("right")
	elif velocity.x < 0:
		sprite.play("left")
	elif velocity.y > 0:
		sprite.play("down")
	elif velocity.y < 0:
		sprite.play("up")
	else:
		sprite.stop()
		
func animate_side():
	if velocity.x > 0:
		sprite.play("right")
	elif velocity.x < 0:
		sprite.play("left")
	else:
		sprite.stop()
		
func move_8way(delta):
	get_8way_input()
	animate()
	var collision_info : KinematicCollision2D = move_and_collide(velocity * delta)
	if collision_info:
		velocity = velocity.bounce(collision_info.get_normal())
		move_and_collide(velocity * delta * 10)
		
func move_side(delta):
	velocity.y += gravity * delta
	#print(velocity.y)
	get_side_input()
	animate_side()
	move_and_slide()

func _physics_process(delta):
	#move_8way(delta)
	move_side(delta)
