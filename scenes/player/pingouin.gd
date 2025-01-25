extends CharacterBody2D
class_name Pingouin

signal semi_to_spawn(semi)

@export_category("Player")
@export_enum("P1", "P2") var player: String 
@export_category("Movement")
@export var speed = 200
@export var hop_heigth = 30
@export_category("Animation")
@export var scale_speed = 10
@export_category("instanciable")
@export var semi_scene : PackedScene
@export_category("")
var interact_pressed = false
@export var interact_speed = 30


var game = null
var tween : Tween
var bounce_tween : Tween
var hoping = false
var x_direction : int
@onready var init_visual_pos_y = $Visual.position.y
@onready var init_visual_scale = $Visual.scale

func _ready():
	$Marker2D/Viseur/ProgressBar.visible = false

func _physics_process(delta: float) -> void:
	var h_move = int(Input.get_axis(player+"_move_left", player+"_move_right"))
	var v_move =  Input.get_axis(player+"_move_up", player+"_move_down")
	var direction = Vector2(h_move, v_move)
	
	if h_move != 0:
		x_direction = h_move
	velocity = direction * speed
	
	move_and_slide()
	
	if (velocity.length() > 0):
		$Visual.play("move")
		hop()
	else:
		$Visual.play("default")
		if tween:
			tween.kill()
			hoping = false
		$Visual.position.y = init_visual_pos_y
		
	if h_move > 0:
		$Visual.flip_h = true
	elif h_move <0:
		$Visual.flip_h = false
		
	$Visual.scale = $Visual.scale.lerp(init_visual_scale, delta * scale_speed)


func _process(delta):
	$Marker2D/Viseur.global_position = snapped(global_position+ Vector2(64 * x_direction, 32), Vector2(64,64))
	
	if Input.is_action_just_pressed(player+"_interact"):
		if game.check_available_pos($Marker2D/Viseur.global_position):
			interact_pressed = true
		else:
			if semi_in_range: #check tool
				interact_pressed = true
	elif Input.is_action_just_released(player+"_interact"):
		interact_pressed = false
	
	if interact_pressed:
		$Marker2D/Viseur/ProgressBar.visible = true
		$Marker2D/Viseur/ProgressBar.value += delta * interact_speed
		if $Marker2D/Viseur/ProgressBar.value>=100:
			if !semi_in_range:
				interact_pressed = false
				var inst = semi_scene.instantiate()
				inst.global_position = $Marker2D/Viseur.global_position
				semi_to_spawn.emit(inst)
			else:
				interact_pressed = false
				semi_in_range.queue_free()
				semi_in_range = null
			$Marker2D/Viseur/ProgressBar.visible = false
			$Marker2D/Viseur/ProgressBar.value = 0
			 
	else:
		$Marker2D/Viseur/ProgressBar.visible = false
		$Marker2D/Viseur/ProgressBar.value = 0
	
func hop():
	if !hoping:
		hoping = true
		if tween:
			tween.kill()
		tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
		tween.tween_property($Visual, "position:y", $Visual.position.y - hop_heigth, 0.1)
		tween.set_ease(Tween.EASE_IN).tween_property($Visual, "position:y", init_visual_pos_y, 0.1)
		await tween.finished
		bounce()
		hoping = false
		
func bounce():
	$Visual.scale.x =  init_visual_scale.x *1.2
	$Visual.scale.y =  init_visual_scale.y *0.8
	#if bounce_tween:
		#bounce_tween.kill()
	#bounce_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	#bounce_tween.tween_property($Visual, "scale", Vector2(init_visual_scale.x * 1.2, init_visual_scale.y * 0.8 ), 0.05)
	#bounce_tween.tween_property($Visual, "scale", init_visual_scale , 0.5)
	pass

var semi_in_range = null
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is Semi:
		area.outline(true)
		semi_in_range = area
		

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area is Semi:
		area.outline(false)
		semi_in_range = null
