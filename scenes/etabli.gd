extends Area2D


func _ready():
	Global.wood_nb_changed.connect(_on_wood_nb_changed)

func _on_wood_nb_changed(val):
	$BoiitePlaceholder/Label.text = str(val)

func _on_body_entered(body: Node2D) -> void:
	if body is Pingouin:
		body.enable_Etabli_UI(true)


func _on_body_exited(body: Node2D) -> void:
	if body is Pingouin:
		body.enable_Etabli_UI(false)

func _on_collector_area_entered(area: Area2D) -> void:
	if area is Wood:
		Global.wood_nb += 1
		area.queue_free()


func _on_pingouin_not_enough_wood() -> void:
	$AnimationPlayer.play("blink")
	$sfx.play()
	await get_tree().create_timer(1.0).timeout
	$AnimationPlayer.stop()
	$BoiitePlaceholder/Label.modulate = Color.WHITE
