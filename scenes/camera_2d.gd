extends Camera2D

@export var object1: CharacterBody2D
@export var object2: CharacterBody2D

var speed = 100

func _process(delta):
	if is_instance_valid(object2):
		self.global_position = (object1.global_position + object2.global_position) * 0.5
	else:
		self.global_position = self.global_position.lerp(object1.global_position, delta * speed)

	#var zoom_factor1 = abs(object1.global_position.x-object2.global_position.x)/(1920-100)
	#var zoom_factor2 = abs(object1.global_position.y-object2.global_position.y)/(1080-100)
	#var zoom_factor = max(max(zoom_factor1, zoom_factor2), 0.5)

	#self.zoom = Vector2(zoom_factor, zoom_factor)
