extends CharacterBody2D

@export var speed: float = 30 # Velocidade de movimento horizontal
@export var gravity: float = 500 # Força da gravidade
@export var direction: int = 1 # 1 para direita, -1 para esquerda
@export var damage: int = 1 # Quantidade de dano causado ao jogador
@onready var health = 10

@onready var game_manager = $"../../CanvasLayer" # Gerenciador do jogo, ajuste o caminho se necessário

var stuck_timer: float = 0.0 # Tempo acumulado parado
@export var stuck_duration: float = 2.0 # Tempo necessário para mudar de direção

func _physics_process(delta: float):
	# Aplicar gravidade no eixo vertical
	velocity.y += gravity * delta

	# Verificar se está tocando o chão
	if is_on_floor():
		# Movimento horizontal apenas no chão
		velocity.x = direction * speed
		stuck_timer = 0.0 # Resetar o timer quando está no chão
	else:
		# Se não está no chão, parar o movimento horizontal
		velocity.x = 0
		stuck_timer += delta
		if stuck_timer >= stuck_duration:
			direction *= -1 # Inverter direção após ficar parado
			stuck_timer = 0.0 # Resetar o timer

	# Mover o inimigo
	move_and_slide()

	# Verificar se colidiu com uma parede no eixo horizontal
	if is_on_wall():
		direction *= -1 # Inverter direção horizontal

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
