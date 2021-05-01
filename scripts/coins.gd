extends Area2D


export var quantity = 0
signal upscore(quantity)


func _on_coins_body_entered(body):
	if body.is_in_group("player"):
		emit_signal("upscore",quantity)
		queue_free()


