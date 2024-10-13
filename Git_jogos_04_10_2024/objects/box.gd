extends Area2D

func _ready() -> void:
	pass
	# Alternativa: usando Tween via código
	#var tween := get_tree().create_tween()
	#tween.tween_property(self, "scale", Vector2(1.5,1.5), 0.2)
	#tween.tween_property(self, "scale", Vector2(1,1), 0.2)
	
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	print("SAIU!")
	queue_free()
