extends CharacterBody2D

@export var speed := 100.0
@export var jump_speed := 1.0
@export var gravity := 4.0
@export var box : PackedScene

@onready var sprite := $PlayerSprite
@onready var jumpSound := $JumpSound

var isAttacking :bool = false
var AttackCombo :int = 1
var attackKey :bool = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("filter"):
		var filtro := AudioServer.get_bus_effect(1, 0) as AudioEffectLowPassFilter
		# Liga/desliga o efeito (na verdade, só troca a frequência de corte)
		if filtro.cutoff_hz == 500:
			filtro.cutoff_hz = 20500
		else:
			filtro.cutoff_hz = 500
	if event.is_action_pressed("attack") and is_on_floor():
		attack()
	else:
		AttackCombo = 0


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
	velocity.x = vel * speed
	
func attack():
	if AttackCombo == 0:
		sprite.play("attack_0")
	elif AttackCombo == 1:
		sprite.play("attack_1")
	elif AttackCombo == 2:
		sprite.play("attack_2")
	isAttacking = true
	
	await sprite.animation_finished
	isAttacking = false
	if AttackCombo == 2:
		AttackCombo = 0
	else:
		AttackCombo += 1
	
func animate():
	if velocity.y < 0:
		sprite.play("jump")
	elif velocity.y > 0:
		sprite.play("fall")	
		
func animate_side():
	if isAttacking: return
	if velocity.x > 0 and is_on_floor():
		sprite.flip_h = false
		sprite.play("run") 
	elif velocity.x < 0 and is_on_floor():
		sprite.flip_h = true
		sprite.play("run")
	elif is_on_floor():
		sprite.play("idle")
		
func move_8way(delta):
	get_8way_input()
	animate()
	var collision_info : KinematicCollision2D = move_and_collide(velocity * delta)
	if collision_info:
		velocity = velocity.bounce(collision_info.get_normal())
		move_and_collide(velocity * delta * 10)
		
func move_side(delta):
	if not isAttacking:
		velocity.y += gravity * delta
		#print(velocity.y)
		get_side_input()
		animate_side()
		move_and_slide()

func _physics_process(delta):
	#move_8way(delta)
	animate()
	move_side(delta)
	
func jump_side(x):
	velocity.y = jump_speed
	velocity.x = -x
