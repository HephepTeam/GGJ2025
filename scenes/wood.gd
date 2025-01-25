extends Sprite2D


var target := Vector2(0,0)

func _ready():
	var tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(self, "global_position", target, 1.0)
	tween.tween_property(self, "scale", Vector2(0,0), 1.2)
	
