extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body is Pingouin:
		body.enable_graine_UI(true)


func _on_body_exited(body: Node2D) -> void:
	if body is Pingouin:
		body.enable_graine_UI(false)
