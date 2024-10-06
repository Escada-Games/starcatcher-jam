extends StaticBody2D

func _ready() -> void:
	self.modulate.a = 0
	set_process(false)
	yield(get_tree().create_timer(1.0), "timeout")
	set_process(true)

func _process(delta: float) -> void:
	self.modulate.a += delta
	self.modulate.a = clamp(self.modulate.a, 0.0, 1.0)
