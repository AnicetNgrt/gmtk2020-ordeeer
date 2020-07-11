extends Node2D

func _on_voice_activate():
	$hand_g._go_action()
	
func _on_voice_deactivate():
	$hand_g._go_idle()

func _on_hammer_activate():
	$hand_d._go_action() 

func _on_hammer_deactivate():
	$hand_d._go_idle()
