extends CharacterBody2D
class_name Pingouin

signal semi_to_spawn(semi)
signal crafted_to_spawn(crafted)
signal not_enough_wood

@export_category("Player")
@export_enum("P1", "P2") var player: int 
@export_category("Movement")
@export var speed = 200
@export var hop_heigth = 30
@export_category("Animation")
@export var scale_speed = 10
@export_category("instanciable")
@export var semi_scene : PackedScene
@export var crafted_scene : PackedScene
var semi_in_range = null
var crafted_in_range = null
@export_category("")
var tool_idx = 0
enum tools {RIEN=0, ARROSOIR, DECO }
var interact_pressed = false
@export var interact_speed = 30
var destroy_pressed = false

var enabled = true


var game = null
var tween : Tween
var bounce_tween : Tween
var hoping = false
var x_direction : int
@onready var init_visual_pos_y = $Visual.position.y
@onready var init_visual_scale = $Visual.scale


func disable_and_hide(val):
	enabled = !val
	visible = !val
	if val:
		set_collision_layer_value(1, false)
		set_collision_mask_value(1,false)
	else:
		set_collision_layer_value(1, true)
		set_collision_mask_value(1,true)
		
	print(collision_mask)
	await get_tree().physics_frame

func _ready():
	switch_tool(tool_idx)
	$Marker2D/Viseur/ProgressBar.visible = false
	$CanBuild.visible = false

func _physics_process(delta: float) -> void:
	if enabled:
		var h_move = clamp(Input.get_joy_axis(player,JOY_AXIS_LEFT_X) + Input.get_axis(str(player)+"_left", str(player)+"_right"), -1.0, 1.0)
		if abs(h_move) < 0.4:
			h_move = 0.0
		#var h_move = int(Input.get_axis(player+"_move_left", player+"_move_right"))
		var v_move = clamp(Input.get_joy_axis(player,JOY_AXIS_LEFT_Y) + Input.get_axis(str(player)+"_up", str(player)+"_down"), -1.0, 1.0)
		if abs(v_move) < 0.4:
			v_move = 0.0
		#var v_move =  Input.get_axis(player+"_move_up", player+"_move_down")
		var direction = Vector2(h_move, v_move).normalized()
		
		if int(h_move) != 0:
			x_direction = int(h_move)
		velocity = direction * speed
		
		move_and_slide()
		
		if (velocity.length() > 0):
			$Visual.play("move")
			hop()
			$Marker2D/Viseur.visible = false
			$Visual/Aile.visible = false
			$Visual/tools.visible = false
		else:
			$Marker2D/Viseur.visible = true
			$Visual/Aile.visible = true
			$Visual/tools.visible = true
			$Visual.play("default")
			if tween:
				tween.kill()
				hoping = false
			$Visual.position.y = init_visual_pos_y
			
		if h_move > 0:
			$Visual.flip_h = true
			$Visual/tools.scale.x = -3.33
			$Visual/Aile.scale.x = -1.0
			$Visual/NootVisual.scale.x = -1.0
			$interactZone.scale.x = -1.0
		elif h_move <0:
			$Visual.flip_h = false
			$Visual/tools.scale.x = 3.33
			$Visual/Aile.scale.x = 1.0
			$Visual/NootVisual.scale.x = 1.0
			$interactZone.scale.x = 1.0
		
	$Visual.scale = $Visual.scale.lerp(init_visual_scale, delta * scale_speed)

func stop_water_sound():
	$water.stop()

var interact_just_pressed = false
var switch_just_pressed = false
func _process(delta):
	if enabled:
		#$Marker2D/Viseur.global_position = snapped(global_position+ Vector2(64 * x_direction, 32), Vector2(64,64))
		$Marker2D/Viseur.global_position = global_position+ Vector2(64 * x_direction, 32)
		
		if bool(Input.get_joy_axis(player, JOY_AXIS_TRIGGER_RIGHT) or Input.is_action_just_pressed(str(player)+"_switch")):
			if !switch_just_pressed:
				switch_just_pressed = true
				tool_idx = wrapi(tool_idx+1, 0, 3)
				switch_tool(tool_idx)
		else:
			switch_just_pressed = false
		
		if Input.is_action_just_pressed(str(player)+"_noot"):
			print(player)
			$Visual/NootVisual.visible = true
			$noot.play()
			await $noot.finished
			$Visual/NootVisual.visible = false
			
			
		if Input.is_action_just_pressed(str(player)+"_interact"):
			if !interact_pressed :
				if game.check_available_pos($Marker2D/Viseur.global_position):
					interact_pressed = true
				else:
					if semi_in_range: #check tool
						interact_pressed = true
		elif Input.is_action_just_pressed(str(player)+"_destroy"):
			if !destroy_pressed:
				destroy_pressed = true

		elif Input.is_action_just_released(str(player)+"_interact"):
			interact_pressed = false
		elif Input.is_action_just_released(str(player)+"_destroy"):
			destroy_pressed = false
		
		if destroy_pressed:
			if crafted_in_range or semi_in_range:
				$Marker2D/Viseur/Cross.visible = true
				$Marker2D/Viseur/ProgressBar.visible = true
				$Marker2D/Viseur/ProgressBar.value += delta * interact_speed
				if $Marker2D/Viseur/ProgressBar.value>=100:
					$Marker2D/Viseur/ProgressBar.visible = false
					$Marker2D/Viseur/ProgressBar.value = 0
					interact_pressed = false
					if semi_in_range:
						semi_in_range.interact(false)
					elif crafted_in_range:
						if crafted_in_range is Placeholder:
							crafted_in_range.interact(true,self)
		
		elif interact_pressed:
			match tool_idx:
				tools.RIEN:
					if (!crafted_in_range and !semi_in_range) or (crafted_in_range is Placeholder):
						$Marker2D/Viseur/Cross.visible = false
						$Marker2D/Viseur/ProgressBar.visible = true
						$Marker2D/Viseur/ProgressBar.value += delta * interact_speed
						if $Marker2D/Viseur/ProgressBar.value>=100:
							interact_pressed = false
							var inst = semi_scene.instantiate()
							inst.global_position = $Marker2D/Viseur.global_position
							tool_idx = 1
							switch_tool(tool_idx)
							semi_to_spawn.emit(inst)	
					else:
						if crafted_in_range and !(crafted_in_range is Placeholder):
							if crafted_in_range.has_method("interact"):
								crafted_in_range.interact(false, self)
				tools.ARROSOIR:
					if semi_in_range:
						$water.play()
						$Anim.play("rotat_rosoir")
						
						semi_in_range.interact(true)
	
				tools.DECO:
					if !semi_in_range and !crafted_in_range:
						$Marker2D/Viseur/Cross.visible = false
						$Marker2D/Viseur/ProgressBar.visible = true
						$Marker2D/Viseur/ProgressBar.value += delta * interact_speed
						if $Marker2D/Viseur/ProgressBar.value>=100:
							interact_pressed = false
							if crafted_scene:
								var inst = crafted_scene.instantiate()
								inst.global_position = $Marker2D/Viseur.global_position
								crafted_scene = null
								$CanBuild.visible = false
								crafted_to_spawn.emit(inst)
							
		else:
			$Marker2D/Viseur/Cross.visible = false
			interact_pressed = false
			destroy_pressed = false
			$Marker2D/Viseur/ProgressBar.visible = false
			$Marker2D/Viseur/ProgressBar.value = 0
	else:
		if Input.is_action_just_pressed(str(player)+"_interact"):
			if crafted_in_range:
				crafted_in_range.interact(false, self)
		
func hop():
	if !hoping:
		hoping = true
		if tween:
			tween.kill()
		tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
		tween.tween_property($Visual, "position:y", $Visual.position.y - hop_heigth, 0.1)
		tween.set_parallel(true).tween_property($shadow, "scale", Vector2(0.8,0.8), 0.1)
		tween.set_parallel(false).set_ease(Tween.EASE_IN).tween_property($Visual, "position:y", init_visual_pos_y, 0.1)
		tween.set_parallel(true).tween_property($shadow, "scale", Vector2(1.0,1.0), 0.1)
		await tween.finished
		bounce()
		hoping = false
		
func bounce():
	$Visual.scale.x =  init_visual_scale.x *1.3
	$Visual.scale.y =  init_visual_scale.y *0.8
	$tap.pitch_scale = randf_range(0.8,1.2)
	$tap.play()
	#if bounce_tween:
		#bounce_tween.kill()
	#bounce_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	#bounce_tween.tween_property($Visual, "scale", Vector2(init_visual_scale.x * 1.2, init_visual_scale.y * 0.8 ), 0.05)
	#bounce_tween.tween_property($Visual, "scale", init_visual_scale , 0.5)
	pass


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is Semi:
		area.outline(true)
		semi_in_range = area
		

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area is Semi:
		area.outline(false)
		semi_in_range = null

		

func enable_graine_UI(val):
	$SelectUI.player = player
	$SelectUI.enabled = val
	$SelectUI.visible = val
	
func enable_Etabli_UI(val):
	$EtabliUI.player = player
	$EtabliUI.enabled = val
	$EtabliUI.visible = val
	
var MAX_TOOLS = 3	
func switch_tool(idx):
	var tools = $Visual/tools.get_children()
	for i in MAX_TOOLS:
		if i == tool_idx:
			tools[i].visible = true
		else:
			tools[i].visible = false
			

func _on_select_ui_object_chosed(obj: Variant) -> void:
	semi_scene = obj
	tool_idx = 0
	switch_tool(tool_idx)
	
func _on_etabli_ui_object_chosed(obj: Variant, price) -> void:
	if !crafted_in_range and !semi_in_range:
		if Global.wood_nb >=price :
			if crafted_scene == null:
				Global.wood_nb = Global.wood_nb - price
				crafted_scene = obj
				$CanBuild.visible = true
				tool_idx = 2
				switch_tool(tool_idx)
			else:
				not_enough_wood.emit()
		else:
			not_enough_wood.emit()


func _on_interact_zone_area_entered(area: Area2D) -> void:
	if area is Crafted_zone:
		crafted_in_range = area.get_parent()


func _on_interact_zone_area_exited(area: Area2D) -> void:
	if area is Crafted_zone:
		crafted_in_range = null
