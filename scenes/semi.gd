extends Area2D
class_name Semi

signal grow_finished(pow)
@export var grow_power := 0.03
@onready var state_steps  = $visual.sprite_frames.get_animation_names().size()
@export var y_offset = -112
var state_idx = 0
var time = 0.0
var wood_target = Vector2(0,0)


@export var evolve_time = 2.0
@export var fleurs : Array[SpriteFrames]

func outline(val: bool):
	$visual.material.set_shader_parameter("Enabled", val)
	
func _ready():
	if !fleurs.is_empty():
		$visual.sprite_frames = fleurs.pick_random()
	$visual.play(str(state_idx))
	
func evolve():
	if state_idx < state_steps-1:
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

			
func interact(water: bool = false):
	if water:
		if state_idx == 0:
			evolve()
	elif  state_idx < state_steps-1:
		destroy()
	else:
		harvest()
		
			
func destroy():
	queue_free() #todo animate and return wood
	
func harvest():
	for i in range(randi_range(2,4)):
		var inst = load("res://scenes/wood.tscn").instantiate()
		inst.global_position = global_position + Vector2(randf_range(-20,20 ), randf_range(-20,20 ))
		add_sibling(inst)
		inst.launch(wood_target)
	Global.play_broken_wood()
	destroy()
