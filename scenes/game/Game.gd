extends Node

var note_count = 0

var notes = []
var yield_started = false
var punch_started = false
var yield_expected = false
var punch_expected = false
var last_punch_note_time = 0
var last_voice_note_time = 0
var score = 0
var combo_voice = 0
var combo_punch = 0
var chaos = 0
var last_wrong_timing_time = 0
var yield_success = false

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
	punch_started = true

func _on_punch_end():
	punch_started = false

func _on_yield_start():
	yield_started = true
	
func _on_yield_end():
	yield_started = false

func _process(delta):
	var to_remove = []
	var to_play_voice = []
	var to_play_punch = []
	var t = OS.get_ticks_msec()
	punch_expected = false
	yield_expected = false
	for note in notes:
		if note["start"]+note["duration"] < t:
			if not note["validated"]:
				$GameUi.note_missed()
			to_remove.append(note)
			$GameUi.remove_note(note["id"])
		if note["is_punch"] == true and t >= note["start"] and t <= note["start"]+note["duration"]:
			punch_expected = true
			to_play_punch.push_back(note)
		if note["is_punch"] == false and t >= note["start"] and t <= note["start"]+note["duration"]:
			yield_expected = true
			to_play_voice.push_back(note)
	for note in to_remove:
		notes.erase(note)
	
	if yield_expected and yield_started:
		combo_voice += 0.1
		score += round(combo_voice)
		for note in to_play_voice:
			note["validated"] = true
		if not yield_success:
			yield_success = true
			$GameUi._on_voice_start_success(1)
	if not yield_expected and yield_started:
		combo_voice = 0
		chaos += 1
		if OS.get_ticks_msec() - last_wrong_timing_time > 100:
			$GameUi.wrong_timing()
			last_wrong_timing_time = OS.get_ticks_msec()
	if not yield_expected:
		yield_success = false
	
	if punch_expected and punch_started:
		combo_punch += 0.1
		score += round(combo_punch)
		for note in to_play_punch:
			note["validated"] = true
	if not punch_expected and punch_started:
		combo_punch = 0
		chaos += 1
		if OS.get_ticks_msec() - last_wrong_timing_time > 100:
			$GameUi.wrong_timing()
			last_wrong_timing_time = OS.get_ticks_msec()
	
	chaos += randf()/10
	#print("chaos: "+str(chaos))
	#print("combo_voice: "+str(round(combo_voice)))
	#print("score: "+str(score))
	$GameUi.update_score(score)
	$GameUi.update_combo_voice(combo_voice)
	$GameUi.update_combo_punch(combo_punch)
	
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
		
	if OS.get_ticks_msec() - last_punch_note_time > 1600:
		last_punch_note_time = OS.get_ticks_msec()
		_spawn_note(true, 3000, 1000, 50)
	
	if OS.get_ticks_msec() - last_voice_note_time > 4100:
		last_voice_note_time = OS.get_ticks_msec()
		_spawn_note(false, 3000, 2000, 200)

func _spawn_note(is_punch, start, duration, tolerance):
	var note = {
		"id":note_count,
		"is_punch":is_punch,
		"start":OS.get_ticks_msec()+start,
		"duration":duration,
		"tolerance":tolerance,
		"validated":false
	}
	note_count += 1
	$GameUi.spawn_note(note)
	notes.push_back(note)
