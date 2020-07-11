extends Sprite

export(Texture) var idle_texture setget _set_idle_texture

func _set_idle_texture(value):
	idle_texture = value

export(Texture) var action_texture setget _set_action_texture

func _set_action_texture(value):
	action_texture = value

func _go_idle():
	texture = idle_texture
	$AnimationPlayer.play("idle")

func _go_action():
	texture = action_texture
	$AnimationPlayer.stop(false)

func _ready():
	$AnimationPlayer.play("idle")
