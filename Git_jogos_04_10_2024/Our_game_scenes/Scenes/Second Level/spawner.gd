extends Area2D

@export var enemy_scene: PackedScene # Cena do inimigo a ser instanciada
@export var spawn_interval: float = 5.0 # Intervalo entre spawns
@export var max_enemies: int = 5 # Número máximo de inimigos simultâneos
@export var y_range: float = 10.0 # Faixa de variação no eixo Y

var spawned_enemies: int = 0 # Contador de inimigos ativos

func _ready():
	# Começar a gerar inimigos
	spawn_enemy()
	# Agendar spawns periódicos
	var timer = get_tree().create_timer(spawn_interval, true)
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))

# Função para instanciar um inimigo
func spawn_enemy():
	if spawned_enemies < max_enemies: # Limitar o número de inimigos simultâneos
		var enemy = enemy_scene.instance()
		# Calcular a posição aleatória dentro do intervalo no eixo Y
		var spawn_position = position
		spawn_position.y += randf_range(-y_range, y_range)
		enemy.position = spawn_position
		get_parent().add_child(enemy) # Adicionar o inimigo à cena
		spawned_enemies += 1
		# Conectar o sinal de remoção do inimigo
		enemy.connect("tree_exited", Callable(self, "_on_enemy_removed"))

# Timer de spawn

# Quando o inimigo for removido, reduzir o contador
func _on_enemy_removed():
	spawned_enemies -= 1


func _on_timer_timeout():
	spawn_enemy()
