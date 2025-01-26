extends Node2D

@onready var etabli = $playzone/etabli

func _ready():
	$playzone/Pingouin.disable_and_hide(true)
	$playzone/Pingouin2.disable_and_hide(true)
	for ping in $playzone.get_children():
		if ping is Pingouin:
			ping.game = self


func _on_semi_instanciated(semi: Node2D):
	if semi.is_in_group("wood"):
		semi.wood_target = etabli.global_position
	$playzone.add_child(semi)
	semi.grow_finished.connect(_grow_finished)
	
func _on_crafted_instanciated(crafted: Node2D):
	$playzone.add_child(crafted)
	
func _grow_finished(power: float):
	$bubble.expand(power)

func check_available_pos(pos: Vector2):
	for semi in $playzone.get_children():
		if semi is Semi:
			if semi.global_position == pos:
				return false
	return true


func _on_texture_button_pressed() -> void:
	get_tree().quit()

func enable_pingouins():
	$playzone/Pingouin.disable_and_hide(false)
	$playzone/Pingouin2.disable_and_hide(false)

func _replace_p2():
	var inst = load("res://scenes/pingouin_placeholder.tscn").instantiate()
	inst.global_position = $playzone/Pingouin2.global_position
	$playzone.add_child(inst)
	$playzone/Pingouin2.queue_free()
	
func play_music():
	$AudioStreamPlayer.play()
