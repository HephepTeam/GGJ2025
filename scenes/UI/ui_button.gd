extends TextureRect

@export var text : String

func _ready():
	set_text(text)

func outline(val: bool):
	material.set_shader_parameter("Enabled", val)
	
func set_text(new_text: String):
	$Label.text = new_text
