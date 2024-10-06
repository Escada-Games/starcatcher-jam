extends StaticBody2D

func _ready() -> void:
	pass

func disappear() -> void:
	var nTwn := Tween.new()
	add_child(nTwn)
	yield(get_tree(),"idle_frame")
	var _v = nTwn.interpolate_property($sprite, 'scale', Vector2.ONE, Vector2.ZERO, 0.5, Tween.TRANS_BACK, Tween.EASE_IN)
	_v = nTwn.start()
	yield(nTwn,"tween_all_completed")
	yield(get_tree(),"idle_frame")
	self.queue_free()
