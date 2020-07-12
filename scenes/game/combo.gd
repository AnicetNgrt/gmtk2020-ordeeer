extends Control


export(int) var combo = 0 setget set_combo

func set_combo(value):
	if value != 0:
		self.show()
	if $combo_value:
		if combo < value and $Tween:
			$combo_value.text = str(value)+"x"
			$combo_value.set("custom_colors/font_color",Color(0,1,0))
			$Tween.interpolate_property($combo_value,"rect_scale",Vector2(1,1),Vector2(1.2,1.2),0.01,Tween.TRANS_CUBIC,Tween.EASE_OUT)
			$Tween.interpolate_property($combo_value,"rect_scale",Vector2(1.2,1.2),Vector2(1,1),0.01,Tween.TRANS_CUBIC,Tween.EASE_OUT,0.1)
			$Tween.interpolate_callback($combo_value,0.1,"set","custom_colors/font_color",Color(1,1,1))
			$Tween.start()
		if combo > value and $Tween:
			$Tween.interpolate_callback(self,0.1,"hide")
			$Tween.start()
	combo = value

# Called when the node enters the scene tree for the first time.
func _ready():
	#$AnimationPlayer.play("idle")
	pass

func on_combo_increase():
	pass
