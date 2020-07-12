extends Control

const miss_label = preload("res://scenes/ui/miss_label.tscn")
const timing_label = preload("res://scenes/ui/timing_label.tscn")

onready var order_labels = [
	$order1, $order2,$order3, $order4,  
	$order5, $order6,$order7, $order8, 
]

var current_order_label = null

var punch_sounds = [
	preload("res://assets/sfx/table_punch/tp1.wav"),
	#preload("res://assets/sfx/table_punch/tp2.wav"),
	#preload("res://assets/sfx/table_punch/tp3.wav")
]

func update_power(power):
	$voice_bar.value = power

func update_score(score):
	$score.score = score

func update_combo_voice(combo):
	$combo_voice.combo = round(combo)

func update_combo_punch(combo):
	$combo_punch.combo = round(combo)

func note_missed():
	var label = miss_label.instance()
	add_child(label)

func wrong_timing():
	var label = timing_label.instance()
	add_child(label)

func _on_voice_activate():
	$voice_indicator.show()
	
func _on_voice_start_success(level):
	current_order_label = order_labels[randi()%order_labels.size()]
	current_order_label.show()
	$OrderTween.interpolate_callback(current_order_label,1,"hide")
	$OrderTween.start()

func _on_voice_deactivate():
	$voice_indicator.hide()

func _on_hammer_activate():
	$punch_indicator.show()
	$table_punch_player.stream = punch_sounds[randi() % punch_sounds.size()]
	$table_punch_player.play()
	
func _on_hammer_start_success(level):
	pass

func _on_hammer_deactivate():
	$punch_indicator.hide()

func remove_note(id):
	get_node("note"+str(id)).queue_free()

func is_note_removed(id):
	return has_node("note"+str(id))

func spawn_note(note):
	var track_pos = $spawn_voice_notes.position
	if note["is_punch"] == true:
		track_pos = $spawn_punch_notes.position
	var rect = ColorRect.new()
	add_child_below_node($punch_track,rect)
	rect.color = Color("ffffff")
	rect.rect_position = track_pos
	var duration_to_bar = note["start"]-OS.get_ticks_msec()
	var distance_to_bar = track_pos.y - $rythm_bar.rect_position.y
	var speed = (distance_to_bar/duration_to_bar)
	var height = note["duration"] * speed
	rect.rect_size = Vector2(89,height)
	var destination = Vector2(track_pos.x, $rythm_bar.rect_position.y-height)
	var true_duration = (duration_to_bar+(height/speed))/1000
	var tween = Tween.new()
	add_child(tween)
	tween.interpolate_property(rect,"rect_position",rect.rect_position,destination,true_duration,Tween.TRANS_LINEAR)
	tween.start()
	rect.name = "note"+str(note["id"])
	return true_duration
