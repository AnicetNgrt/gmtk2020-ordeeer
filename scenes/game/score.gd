extends Control


export(int) var score = 0 setget set_score

func set_score(value):
	if $score_value: 
		$score_value.text = str(value)
		if score < value and $Tween:
			$score_value.set("custom_colors/font_color",Color(0,1,0))
			$Tween.interpolate_property($score_value,"rect_scale",Vector2(1,1),Vector2(1.2,1.2),0.01,Tween.TRANS_CUBIC,Tween.EASE_OUT)
			$Tween.interpolate_property($score_value,"rect_scale",Vector2(1.2,1.2),Vector2(1,1),0.01,Tween.TRANS_CUBIC,Tween.EASE_OUT,0.1)
			$Tween.interpolate_callback($score_value,0.1,"set","custom_colors/font_color",Color(1,1,1))
			$Tween.start()
	score = value

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("idle")

func on_score_increase():
	pass
