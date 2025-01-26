extends Sprite2D

#func _input(event: InputEvent) -> void:
	#if event is InputEventKey:
		#expand(0.05)

func expand(expand_factor):
	var new_scale = Vector2()
	new_scale.x = scale.x + expand_factor
	new_scale.y = scale.y + expand_factor * 0.9
	
	var tween_x = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	var tween_y = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween_x.tween_property(self,"scale:x", new_scale.x, 1.0)
	$bloup.play()
	if scale.y < 1.2:
		tween_y.set_parallel().tween_property(self,"scale:y", new_scale.y, 0.8)
