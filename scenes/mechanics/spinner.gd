extends KinematicBody2D

onready var nTwn:Tween = $tween

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func spin(fAngle := PI/2) -> void:
	var _v = nTwn.interpolate_property(self, 'rotation', self.rotation, self.rotation + fAngle, 0.4, Tween.TRANS_BACK, Tween.EASE_OUT)
	_v = nTwn.start()
