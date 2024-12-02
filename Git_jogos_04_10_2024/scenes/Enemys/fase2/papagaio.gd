extends CharacterBody2D

@export var speed: float = 55 # Velocidade de movimento horizontal
@export var direction: int = -1 # 1 para direita, -1 para esquerda
@export var damage: int = 1 # Quantidade de dano causado ao jogador
@export var stop_duration_before_die: float = 1.0 # Tempo que o inimigo fica parado antes de morrer
@onready var health = 10

@onready var game_manager = $"../../../../../CanvasLayer"
var is_stuck: bool = false # Indica se o inimigo está parado após bater
var stuck_timer: float = 0.0 # Timer para contar o tempo que está parado

func _physics_process(delta: float):
	if is_stuck:
		# Inimigo está parado
		stuck_timer += delta
		if stuck_timer >= stop_duration_before_die:
			die() # Morre após ficar parado pelo tempo especificado
	else:
		# Movimento horizontal
		velocity.x = direction * speed
		move_and_slide()

		# Verificar se colidiu com uma parede
		if is_on_wall():
			become_stuck() # Para e inicia o timer

# Função para marcar o inimigo como parado
func become_stuck():
	is_stuck = true
	velocity = Vector2.ZERO # Parar completamente o movimento
	stuck_timer = 0.0 # Resetar o timer

# Função para destruir o inimigo
func die():
	print("Inimigo morreu!")
	queue_free() # Remove o inimigo da cena

# Detectar quando um corpo entra na hitbox do inimigo
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		for child in body.get_children():
			if child.name == "AttackShapeRight" or child.name == "AttackShapeLeft":
				if child.disabled == false:
					hit(body.damage())
					return
					
		var y_delta = position.y - body.position.y
		var x_delta = position.x - body.position.x
		print(y_delta)
		#game_manager.decrease_health()
		if x_delta > 0:
			body.jump_side(500)
		else: 
			body.jump_side(-500)

# Função para gerenciar dano ao inimigo
func hit(damage: int) -> void:
	health -= damage
	if health <= 0:
		die()
