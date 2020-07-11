extends Node

var punch_notes = []
var voice_notes = []
var current_punch_note = null
var current_voice_note = null
var last_punch_note_time = 0
var last_voice_note_time = 0
var yield_started = false
var punch_started = false

func _on_power_update(power):
	$GameUi.update_power(power)
	if power > 150:
		$GameGraphics._on_voice_activate()
		$GameUi._on_voice_activate()
		if not yield_started:
			_on_yield_start()
			yield_started = true
	else:
		$GameGraphics._on_voice_deactivate()
		$GameUi._on_voice_deactivate()
		if yield_started:
			_on_yield_end()
			yield_started = false

func _on_punch_start():
	var note = punch_notes.pop_front()
	if note == null:
		return
	if abs(note["start"] - OS.get_ticks_msec()) <= note["tolerance"]:
		current_punch_note = note
	else:
		$GameUi._on_remove_last_punch_note()

func _on_punch_end():
	if current_punch_note == null: return
	var note = current_punch_note
	if abs((note["start"]+note["duration"]) - OS.get_ticks_msec()) <= note["tolerance"]:
		pass
	else:
		$GameUi._on_remove_last_punch_note()
	current_punch_note = null

func _on_yield_start():
	var note = voice_notes.pop_front()
	if note == null:
		print("no notes")
		return
	if abs(note["start"] - OS.get_ticks_msec()) <= note["tolerance"]:
		current_voice_note = note
		$GameUi._on_voice_start_success(1)
		print("start success")
	else:
		print("start fail")
		print(abs(note["start"] - OS.get_ticks_msec()))
		$GameUi._on_remove_last_voice_note()
	
func _on_yield_end():
	if current_voice_note == null: return
	var note = current_voice_note
	if abs((note["start"]+note["duration"]) - OS.get_ticks_msec()) <= note["tolerance"]:
		print("end success")
	else:
		$GameUi._on_remove_last_voice_note()
	current_voice_note = null

func _process(delta):
	if Input.is_action_just_pressed("punch"):
		$GameGraphics._on_hammer_activate()
		$GameUi._on_hammer_activate()
		if not punch_started:
			punch_started = true
			_on_punch_start()
	if Input.is_action_just_released("punch"):
		$GameGraphics._on_hammer_deactivate()
		$GameUi._on_hammer_deactivate()
		if punch_started:
			punch_started = false
			_on_punch_end()
		
	if OS.get_ticks_msec() - last_punch_note_time > 16000:
		last_punch_note_time = OS.get_ticks_msec()
		var next_punch_note = {"start":OS.get_ticks_msec() + 6000,"duration":200,"tolerance":50}
		punch_notes.push_back(next_punch_note)
		$GameUi.spawn_punch_note(next_punch_note)
	
	if OS.get_ticks_msec() - last_voice_note_time > 1900:
		last_voice_note_time = OS.get_ticks_msec()
		var next_voice_note = {"start":OS.get_ticks_msec() + 6000,"duration":600,"tolerance":200}
		voice_notes.push_back(next_voice_note)
		$GameUi.spawn_voice_note(next_voice_note)
