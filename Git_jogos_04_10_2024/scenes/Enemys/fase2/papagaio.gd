extends CharacterBody2D

@export var speed: float = 55 # Velocidade de movimento horizontal
@export var direction: int = -1 # 1 para direita, -1 para esquerda
@export var damage: int = 1 # Quantidade de dano causado ao jogador
@onready var health = 10

@onready var game_manager = $"../../CanvasLayer" # Gerenciador do jogo, ajuste o caminho se necessário

var stuck_timer: float = 0.0 # Tempo acumulado parado
@export var stuck_duration: float = 2.0 # Tempo necessário para mudar de direção

func _physics_process(delta: float):
	# Movimento horizontal
	velocity.x = direction * speed

	# Mover o inimigo
	move_and_slide()

	# Verificar se colidiu com uma parede no eixo horizontal
	if is_on_wall():
		invert_direction() # Inverter direção ao bater na parede

	# Verificar se está parado por muito tempo
	if abs(velocity.x) < 1.0:
		stuck_timer += delta
		if stuck_timer >= stuck_duration:
			invert_direction() # Inverter direção após ficar parado
			stuck_timer = 0.0 # Resetar o timer

# Função para inverter a direção do inimigo
func invert_direction():
	direction *= -1 # Inverter a direção horizontal

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
