extends Area2D
class_name Wood


func _ready():
	pass
	
func launch(new_target: Vector2):
	var tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(self, "global_position", new_target, 1.0)
	tween.tween_property(self, "scale", Vector2(0.1,0.1), 1.2)
	
