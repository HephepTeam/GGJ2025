extends StaticBody2D
class_name Crafted

var rnd_scale = [1.0, -1.0]

func _ready():
	scale.x = rnd_scale.pick_random()
	
func outline(val: bool):
	$visual.material.set_shader_parameter("Enabled", val)

func _on_interaction_zone_body_entered(body: Node2D) -> void:
	pass
	#if body is Pingouin:
		#outline(true)


func _on_interaction_zone_body_exited(body: Node2D) -> void:
	pass
	#if body is Pingouin:
		#outline(false)

func interact(destroy: bool = false, source = null):
	if destroy:
		destroy(source)
	else:
		change_state(source)
		
func change_state(source):
	pass
		
func destroy(source):
	queue_free()

func _on_interaction_zone_area_entered(area: Area2D) -> void:
	if area.get_parent() is Pingouin:
		outline(true)


func _on_interaction_zone_area_exited(area: Area2D) -> void:
	if area.get_parent() is Pingouin:
		outline(false)
