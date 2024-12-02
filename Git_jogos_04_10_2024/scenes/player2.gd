extends CharacterBody2D

@export var speed := 100.0
@export var jump_speed := -500
@export var gravity := 1600
@export var box : PackedScene

@onready var music := $"Slower2019-01-02-8BitMenu-DavidRenda-FesliyanStudios_com"
@onready var main = get_tree().get_root().get_node("FallenCirclesMain") 
@onready var projectile = load("res://projectile_spell.tscn")
@onready var sprite := $PlayerSprite
@onready var idleShape := $IdleShape
@onready var runShapeRight := $RunShapeRight
@onready var runShapeLeft := $RunShapeLeft
@onready var jumpShapeRight := $JumpShapeRight
@onready var jumpShapeLeft := $JumpShapeLeft
@onready var crouchShapeRight := $CrouchShapeRight
@onready var crouchShapeLeft := $CrouchShapeLeft
@onready var crouchedShapeRight := $CrouchedShapeRight
@onready var crouchedShapeLeft := $CrouchedShapeLeft
@onready var attackShapeRight := $AttackShapeRight
@onready var attackShapeLeft := $AttackShapeLeft
@onready var timer := $Timer
@onready var timerSpell := $TimerSpell

@onready var jumpSound := $JumpSound

var isAttacking :bool = false
var AttackCombo :int = 1
var attackKey :bool = false
var isCrouch :bool = false


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
	if event.is_action_pressed("spell") and is_on_floor():
		spell()

func disable_all_shapes():
	idleShape.disabled = true
	runShapeLeft.disabled = true
	runShapeRight.disabled = true
	jumpShapeRight.disabled = true
	jumpShapeLeft.disabled = true
	crouchShapeRight.disabled = true
	crouchShapeLeft.disabled = true
	crouchedShapeRight.disabled = true
	crouchedShapeLeft.disabled = true
	
func disable_attack_shapes():
	attackShapeRight.disabled = true
	attackShapeLeft.disabled = true

func get_8way_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	
func get_side_input():
	velocity.x = 0
	var vel := Input.get_axis("left", "right")
	var jump := Input.is_action_just_pressed("jump")
	var crouch := Input.is_action_pressed("crouch")
	
	
	if is_on_floor() and crouch:
		disable_all_shapes()
		if sprite.flip_h == false:
			crouchShapeRight.disabled = false
		else:
			crouchShapeLeft.disabled = false
		isCrouch = true
	else:
		isCrouch = false

	if is_on_floor() and jump:		
		velocity.y = jump_speed
		disable_all_shapes()
		if sprite.flip_h == false:
			jumpShapeRight.disabled = false
		else:
			jumpShapeLeft.disabled = false
			
		get_tree().call_group("HUD", "updateScore")
		if not jumpSound.playing:
			jumpSound.play()
	velocity.x = vel * speed
	
func attack():
	
	if AttackCombo == 0 or timer.is_stopped():
		sprite.play("attack_0")
		if sprite.flip_h == false:
			attackShapeRight.disabled = false
		else:
			attackShapeLeft.disabled = false
		timer.start()
	elif AttackCombo == 1:
		sprite.play("attack_1")
		if sprite.flip_h == false:
			attackShapeRight.disabled = false
		else:
			attackShapeLeft.disabled = false
	elif AttackCombo == 2:
		sprite.play("attack_2")
		if sprite.flip_h == false:
			attackShapeRight.disabled = false
		else:
			attackShapeLeft.disabled = false
	isAttacking = true
	await sprite.animation_finished
	disable_attack_shapes()
	isAttacking = false
	if AttackCombo == 2:
		AttackCombo = 0
	else:
		AttackCombo += 1

func spell():
	print(timerSpell.time_left)
	if timerSpell.time_left == 0:
		var instance = projectile.instantiate()

		instance.spawnPos = global_position
		instance.spawnRot = global_rotation
		main.add_child(instance)
		timerSpell.start()
	



func animate():
	if velocity.y < 0:
		sprite.play("jump")
	elif velocity.y > 0:
		sprite.play("fall")	
		
func animate_side():
	if isAttacking: return
	if velocity.x > 0 and is_on_floor():
		sprite.flip_h = false
		disable_all_shapes()
		if isCrouch:
			print("CROUCHED")
			sprite.play("crouched")
			crouchedShapeRight.disabled = false
		else:
			sprite.play("run") 
			runShapeRight.disabled = false
	elif velocity.x < 0 and is_on_floor():
		sprite.flip_h = true
		disable_all_shapes()
		if isCrouch:
			sprite.play("crouched")
			crouchedShapeLeft.disabled = false
		else:
			sprite.play("run")
			runShapeLeft.disabled = false
	elif is_on_floor():
		if isCrouch and velocity.x == 0:
			sprite.play("crouched")
		elif velocity.x == 0:
			sprite.play("idle")
			disable_all_shapes()
			idleShape.disabled = false
		
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
		
func damage():
	return 10		

func _physics_process(delta):
	#move_8way(delta)
	animate()
	move_side(delta)
	
func jump_side(x):
	velocity.y = jump_speed
	velocity.x = -x
