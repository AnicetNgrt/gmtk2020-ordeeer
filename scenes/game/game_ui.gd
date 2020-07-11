extends Control

onready var order_labels = [
	$order1, $order2,$order3, $order4,  
	$order5, $order6,$order7, $order8, 
]

var current_order_label = null

var punch_sounds = [
	preload("res://assets/sfx/table_punch/tp1.wav"),
	preload("res://assets/sfx/table_punch/tp2.wav"),
	preload("res://assets/sfx/table_punch/tp3.wav")
]

var punch_notes = []
var voice_notes = []

func update_power(power):
	$voice_bar.value = power

func _on_voice_activate():
	$voice_indicator.show()
	
func _on_voice_start_success(level):
	print("hi")
	current_order_label = order_labels[randi()%order_labels.size()]
	current_order_label.show()

func _on_remove_last_voice_note():
	var note_rect = voice_notes.pop_front()
	note_rect.hide()

func _on_remove_voice_note(rect):
	punch_notes.erase(rect)
	rect.hide()

func _on_voice_deactivate():
	$voice_indicator.hide()
	if current_order_label != null:
		current_order_label.hide()
		current_order_label = null

func _on_hammer_activate():
	$punch_indicator.show()
	$table_punch_player.stream = punch_sounds[randi() % punch_sounds.size()]
	$table_punch_player.play()
	
func _on_hammer_start_success(level):
	pass
	
func _on_remove_last_punch_note():
	var note_rect = punch_notes.pop_front()
	note_rect.hide()

func _on_remove_punch_note(rect):
	punch_notes.erase(rect)
	rect.hide()

func _on_hammer_deactivate():
	$punch_indicator.hide()

func spawn_voice_note(note):
	var rect = ColorRect.new()
	add_child(rect)
	rect.color = Color("fab700")
	var duration = note["start"]-OS.get_ticks_msec()
	var length_to_bar = $spawn_voice_notes.position.y - $rythm_bar.rect_position.y
	var height = note["duration"] / (duration/length_to_bar) 
	rect.rect_size = Vector2(89,height)
	rect.rect_position = $spawn_voice_notes.position
	var destination = Vector2($spawn_voice_notes.position.x, $rythm_bar.rect_position.y-height)
	var tween = Tween.new()
	add_child(tween)
	tween.interpolate_property(rect,"rect_position",rect.rect_position,destination,(duration+((duration/length_to_bar)*height))/1000,Tween.TRANS_LINEAR)
	#tween.interpolate_callback(rect,(duration+((duration/length_to_bar)*height))/1000,"hide")
	tween.interpolate_callback(self,(duration+((duration/length_to_bar)*height))/1000,"_on_remove_voice_note",rect)
	tween.start()
	voice_notes.push_back(rect)

func spawn_punch_note(note):
	var rect = ColorRect.new()
	add_child(rect)
	rect.color = Color("fab700")
	var duration = note["start"]-OS.get_ticks_msec()
	var length_to_bar = $spawn_punch_notes.position.y - $rythm_bar.rect_position.y
	var height = note["duration"] / (duration/length_to_bar) 
	rect.rect_size = Vector2(89,height)
	rect.rect_position = $spawn_punch_notes.position
	var destination = Vector2($spawn_punch_notes.position.x, $rythm_bar.rect_position.y-height)
	var tween = Tween.new()
	add_child(tween)
	tween.interpolate_property(rect,"rect_position",rect.rect_position,destination,(duration+((duration/length_to_bar)*height))/1000,Tween.TRANS_LINEAR)
	#tween.interpolate_callback(rect,(duration+((duration/length_to_bar)*height))/1000,"hide")
	tween.interpolate_callback(self,(duration+((duration/length_to_bar)*height))/1000,"_on_remove_punch_note",rect)
	tween.start()
	punch_notes.push_back(rect)
