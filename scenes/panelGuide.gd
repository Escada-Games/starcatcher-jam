extends Panel

export(float) var fWaitTime := 1.0

func _ready() -> void:
	set_process(false)
	self.modulate.a = 0
	yield(get_tree().create_timer(fWaitTime), "timeout")
	set_process(true)
	
func _process(delta: float) -> void:
	self.modulate.a += delta
	self.modulate.a = clamp(self.modulate.a, 0, 1)
