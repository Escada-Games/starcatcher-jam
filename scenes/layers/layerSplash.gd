extends CanvasLayer

onready var nTwn:Tween = $tween
onready var nSprite:Sprite = $sprite

func _ready() -> void:
	self.visible = true
	var _v = null
	_v = nTwn.interpolate_property(nSprite, 'modulate:a', 1, 0, 0.66, Tween.TRANS_SINE, Tween.EASE_IN)
	_v = nTwn.start()
	yield(nTwn, "tween_all_completed")
	yield(get_tree(), "idle_frame")
	self.queue_free()
