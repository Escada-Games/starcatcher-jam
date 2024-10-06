extends AudioStreamPlayer

var bPitchShift := true

func _ready() -> void:
	if bPitchShift:
		self.pitch_scale *= rand_range(0.8,1.2)

func _on_sfxPlayer_finished() -> void:
	self.queue_free()
