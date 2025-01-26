extends CanvasLayer

var skipped = false

func _ready():
	$menu/HBoxContainer/ButtonOnePlayer.grab_focus()

func _on_p_pressed() -> void:
	if !skipped:
		skipped = true
		get_parent().enable_pingouins()
		get_parent()._replace_p2()
		get_parent().play_music()
		var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		tween.tween_property($P1, "modulate:a", 0.0, 3.0)
		tween.set_parallel(true).tween_property($P2, "modulate:a", 0.0, 3.0)
		$menu.visible = false

func _on_2p_pressed() -> void:
	if !skipped:
		skipped = true
		get_parent().enable_pingouins()
		get_parent().play_music()
		var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		tween.tween_property($P1, "modulate:a", 0.0, 3.0)
		tween.set_parallel(true).tween_property($P2, "modulate:a", 0.0, 3.0)
		$menu.visible = false
