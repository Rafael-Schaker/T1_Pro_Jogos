extends CharacterBody2D

@export var speed: float = 30 # Velocidade de movimento horizontal
@export var gravity: float = 500 # Força da gravidade
@export var direction: int = 1 # 1 para direita, -1 para esquerda
@export var damage: int = 1 # Quantidade de dano causado ao jogador
@onready var health = 10

@onready var game_manager = $"../../CanvasLayer" # Gerenciador do jogo, ajuste o caminho se necessário

var is_stuck: bool = false # Indica se o inimigo está parado após colidir
var stuck_timer: float = 0.0 # Tempo acumulado parado
@export var stop_duration: float = 1.0 # Tempo necessário para ficar parado antes de mudar de direção

func _physics_process(delta: float):
	if is_stuck:
		# Contar o tempo enquanto o inimigo está parado
		stuck_timer += delta
		if stuck_timer >= stop_duration:
			is_stuck = false # Retomar movimento
			stuck_timer = 0.0
			direction *= -1 # Inverter a direção
	else:
		# Aplicar gravidade no eixo vertical
		velocity.y += gravity * delta

		# Movimento horizontal
		velocity.x = direction * speed
		move_and_slide()

		# Verificar se colidiu com uma parede no eixo horizontal
		if is_on_wall():
			become_stuck() # Parar o inimigo

# Função para marcar o inimigo como parado
func become_stuck():
	is_stuck = true
	velocity = Vector2.ZERO # Parar completamente o movimento
	stuck_timer = 0.0 # Resetar o timer

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
		game_manager.decrease_health()
		if x_delta > 0:
			body.jump_side(500)
		else: 
			body.jump_side(-500)

# Função para gerenciar dano ao inimigo
func hit(damage: int) -> void:
	health -= damage
	if health <= 0:
		await get_tree().create_timer(0.1).timeout
		self.queue_free()
