extends Sprite
class_name SpriteFadeCell

export(Vector2) var vInitialScale := Vector2()
export(Vector2) var vFinalScale := Vector2.ONE * 2
export(bool) var bWillGrow := true
export(float) var fTwnDuration := 0.4
export(float) var fTwnDelay := 0.0
onready var nTwn := Tween.new()

func _ready() -> void:
	add_child(nTwn)
	if bWillGrow:
		self.scale = vInitialScale
		var _v=nTwn.interpolate_property(self,
			'scale',
			self.scale,
			self.vFinalScale,
			fTwnDuration+fTwnDelay,
			Tween.TRANS_CUBIC,
			Tween.EASE_IN,
			fTwnDelay
			)
		_v = nTwn.start()
	else:
		self.scale = vFinalScale
		var _v=nTwn.interpolate_property(self,
			'scale',
			self.scale,
			self.vInitialScale,
			fTwnDuration+fTwnDelay,
			Tween.TRANS_CUBIC,
			Tween.EASE_IN,
			fTwnDelay
			)
		_v = nTwn.start()
