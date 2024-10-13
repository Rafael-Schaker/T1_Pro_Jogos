extends Area2D


func _on_body_entered(body):
	$CoinSfx.play()
	queue_free()
	get_tree().call_group("pickup", "pickCoin")
