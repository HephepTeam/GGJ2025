extends Node

signal wood_nb_changed(val)

var wood_nb = 0:
	set(val):
		wood_nb = val
		wood_nb_changed.emit(val)


func play_broken_wood():
	$sfx.pitch_scale = randf_range(0.8,1.2)
	$sfx.play()
