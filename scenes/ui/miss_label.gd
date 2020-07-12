extends Label

func _ready():
	var destination = Vector2(rect_position.x, rect_position.y-300)
	$Tween.interpolate_property(self, "rect_position", rect_position, destination, 1, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0.2)
	$Tween.interpolate_callback(self, 1.2, "queue_free")
	$Tween.start()
