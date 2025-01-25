extends Area2D
class_name Semi

signal grow_finished(pow)
@onready var grow_power := 0.03
@onready var state_steps  = $visual.sprite_frames.get_animation_names().size()
@export var y_offset = -112
var state_idx = 0
var time = 0.0

@export var evolve_time = 2.0

func outline(val: bool):
	$visual.material.set_shader_parameter("Enabled", val)
	
func _ready():
	$visual.play(str(state_idx))	
	
func evolve():
	print(state_steps)
	if state_idx < state_steps-1:
		print(state_idx)
		state_idx +=1
		$visual.play(str(state_idx))
		var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
		tween.tween_property($visual, "scale:y", $visual.scale.y * 1.2, 0.2)
		tween.tween_property($visual, "scale:y", $visual.scale.y, 0.2)
		if state_idx == state_steps-1:
			grow_finished.emit(grow_power)
			

func _process(delta):
	if state_idx > 0:
		time += delta
		if time >=evolve_time:
			time = 0.0
			evolve()
	if state_idx > 1:
		$visual.offset.y = y_offset
	else:
		$visual.offset.y = -32
			
func interact(water: bool = false):
	if water:
		if state_idx == 0:
			evolve()
	elif  state_idx < state_steps:
		destroy()
	else:
		harvest()
		
			
func destroy():
	queue_free() #todo animate and return wood
	
func harvest():
	destroy()
