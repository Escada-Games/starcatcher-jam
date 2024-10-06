extends Node2D

var fAngularSpeed := PI/6.0

func _ready() -> void:
	set_process(true)

func _process(delta: float) -> void:
	for n in get_children():
		n.global_rotation = 0
		#n.rotation = -self.rotation
	self.rotation += delta * fAngularSpeed
		
	pass
