extends KinematicBody2D
class_name Jumpy

onready var nTwn := $tween
var bHasGoneDown := false

func _ready() -> void:
	pass


func goDown() -> void:
	if bHasGoneDown:
		return
		
	bHasGoneDown = true
	
	nTwn.interpolate_property(self, 'global_position:y', self.global_position.y, self.global_position.y + 64, 0.8, Tween.TRANS_BACK, Tween.EASE_OUT)
	nTwn.start()
	
	yield(nTwn,"tween_all_completed")
	
	nTwn.interpolate_property(self, 'global_position:y', self.global_position.y, self.global_position.y - 64, 2.0, Tween.TRANS_BACK, Tween.EASE_IN_OUT, 1.0)
	nTwn.start()
	
	yield(nTwn,"tween_all_completed")
	
	bHasGoneDown = false
	pass
