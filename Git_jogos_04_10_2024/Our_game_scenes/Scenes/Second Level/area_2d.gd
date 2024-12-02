extends Area2D

@export var enemy_scene: PackedScene # Cena do inimigo a ser instanciada
@export var spawn_interval: float = 2.0 # Intervalo entre spawns
@export var max_enemies: int = 50 # Número máximo de inimigos simultâneos

@onready var collision_shape = $CollisionShape2D # Referência à CollisionShape2D
var spawned_enemies: int = 0 # Contador de inimigos ativos

func _ready():
	# Começar a gerar inimigos
	print('ready')
	spawn_enemy()
	# Agendar spawns periódicos
	var timer = get_tree().create_timer(spawn_interval, true)
	timer.connect("timeout", Callable(self, "_on_spawn_timer_timeout"))

# Função para instanciar um inimigo
func spawn_enemy():
	if not enemy_scene: # Certifique-se de que a cena está configurada
		print("Erro: 'enemy_scene' não foi atribuída.")
		return

	if spawned_enemies < max_enemies: # Limitar o número de inimigos simultâneos
		print('spawnou')
		var enemy = enemy_scene.instantiate() # Use instantiate() em vez de instance()
		# Calcular a posição aleatória dentro do intervalo do SegmentShape2D
		var spawn_position = get_random_position_in_segment()
		enemy.position = spawn_position
		get_parent().add_child(enemy) # Adicionar o inimigo à cena
		spawned_enemies += 1
		# Conectar o sinal de remoção do inimigo
		enemy.connect("tree_exited", Callable(self, "_on_enemy_removed"))

# Obter uma posição aleatória ao longo do SegmentShape2D
func get_random_position_in_segment() -> Vector2:
	var shape = collision_shape.shape
	if shape is SegmentShape2D:
		var a = shape.a
		var b = shape.b
		var t = randf() # Valor aleatório entre 0 e 1
		return global_position + a.lerp(b, t)
	else:
		print("Forma de colisão não suportada para SegmentShape2D.")
		return global_position

# Timer de spawn
func _on_timer_timeout():
	spawn_enemy()

# Quando o inimigo for removido, reduzir o contador
func _on_enemy_removed():
	spawned_enemies -= 1
