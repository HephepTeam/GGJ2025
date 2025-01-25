extends Area2D
class_name Semi


func outline(val: bool):
	$visual.material.set_shader_parameter("Enabled", val)
