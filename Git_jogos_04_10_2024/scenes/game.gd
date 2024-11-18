extends Node2D

@onready var player : CharacterBody2D
@onready var sceneLimit : Marker2D
@onready var score : int = 0

var currentScene = null

func _ready() -> void:
	currentScene = get_child(1) # pega o 2o. filho (o nodo Level)	
	player = currentScene.get_node("Player")
	sceneLimit = currentScene.get_node("SceneLimit")

func _on_timer_timeout() -> void:
	print("Timer!")
	
# descomente se quiser ver o call_group
# chamando também esta função!
#func updateScore():
#	print("Chamado por call_group!")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		call_deferred("goto_scene", "res://scenes/level2.tscn")

func _physics_process(delta: float) -> void:
	if sceneLimit == null: # troquei de cena?
		sceneLimit = currentScene.get_node("SceneLimit")
		player = currentScene.get_node("Player")
	if player.position.y > sceneLimit.position.y:
		get_tree().change_scene_to_file("res://scenes/gameover.tscn")		
		
func goto_scene(path: String):
	print("Total children: "+str(get_child_count()))
	var world := get_child(1)
	if world == null:
		return
	world.free()
	var res := ResourceLoader.load(path)
	currentScene = res.instantiate()
	sceneLimit = null	
	add_child(currentScene)

# Chamada quando for necessário atualizar o score,
# recebe a qtd a ser incrementada e também
# atualiza o label
func increaseScore(amount: int):
	score += amount
	$HUD.setScore(score)

# Chamada quando notificada via call_group pela
# moeda
func pickCoin():
	increaseScore(5)
