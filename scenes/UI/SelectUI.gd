extends Control

signal object_chosed(obj)

@export var enabled = false
@export var Possible_object : Array[PackedScene]

var player : int



func _process(delta: float) -> void:
	if enabled:
		if Input.is_action_just_pressed(str(player)+"_X"):
			var object_idx = 0
			$X.outline(true)
			$Y.outline(false)
			$B.outline(false)
			await get_tree().create_timer(0.2).timeout
			enabled = false
			visible = false
			object_chosed.emit(Possible_object[object_idx])
		elif Input.is_action_just_pressed(str(player)+"_Y"):
			var object_idx = 1
			$X.outline(false)
			$Y.outline(true)
			$B.outline(false)
			await get_tree().create_timer(0.2).timeout
			enabled = false
			visible = false
			object_chosed.emit(Possible_object[object_idx])
		elif Input.is_action_just_pressed(str(player)+"_B"):
			var object_idx = 2
			$X.outline(false)
			$Y.outline(false)
			$B.outline(true)
			await get_tree().create_timer(0.2).timeout
			enabled = false
			visible = false
			object_chosed.emit(Possible_object[object_idx])
