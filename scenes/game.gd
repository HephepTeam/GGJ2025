extends Node2D

func _ready():
	for ping in $playzone.get_children():
		if ping is Pingouin:
			ping.game = self


func _on_semi_instanciated(semi: Node2D):
	$playzone.add_child(semi)
	semi.grow_finished.connect(_grow_finished)
	
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
