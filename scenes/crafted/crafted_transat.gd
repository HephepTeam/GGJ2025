extends Crafted

var state = 0
var oqp = null
var debounce = 0

func change_state(pingouin):
	if debounce == 0:
		state = wrap(state+1, 0, 2)
		if oqp == pingouin:
			oqp.disable_and_hide(false)
			#oqp.enabled = true
			#oqp.visible = true
			oqp = null
		else:
			if oqp == null:
				oqp = pingouin
				oqp.disable_and_hide(true)
				#oqp.enabled = false
				#oqp.visible = false
		$visual.play(str(state))
		debounce = 50
	
func destroy(source):
	if oqp == null:
		queue_free()
	
func _process(delta: float) -> void:
	if debounce > 0:
		debounce -=1
