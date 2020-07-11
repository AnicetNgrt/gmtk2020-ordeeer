extends Node

var lastime = 0
var effect
var recording
var power = 0

signal power_update(power)

func _ready():
	var idx = AudioServer.get_bus_index("Record")
	effect = AudioServer.get_bus_effect(idx, 0)
	effect.set_recording_active(true)
	effect.format = 0

func _physics_process(delta):
	if OS.get_ticks_msec() - lastime > 35:
		lastime = OS.get_ticks_msec()
		effect.set_recording_active(false)
		recording = effect.get_recording()
		effect.set_recording_active(true)
		if recording == null: return
		var data = recording.get_data()
		var s = 0
		for i in range(44,data.size()):
			s += data[i] * data[i]
		var power = sqrt(s/(data.size()-44))
		emit_signal("power_update", power)
