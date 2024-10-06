extends AnimatedSprite
class_name AnimatedSpriteFx

func _ready() -> void:
	self.play('default')
	var _v = self.connect("animation_finished", self, 'queue_free')
