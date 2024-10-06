extends KinematicBody2D
class_name Flipper

onready var nSprite:Sprite = $sprite
onready var nTwn:Tween = $tween


func _ready() -> void:
	pass

func disablePlayerCollision() -> void:
	self.set_collision_layer_bit(0, false)
	self.set_collision_mask_bit(0, false)
	
func enablePlayerCollision() -> void:
	self.set_collision_layer_bit(0, true)
	self.set_collision_mask_bit(0, true)

func playAnimFlip() -> void:
	var _v = nTwn.interpolate_property(nSprite, 'rotation', nSprite.rotation, nSprite.rotation + PI, 0.5, Tween.TRANS_BACK, Tween.EASE_OUT)
	_v = nTwn.start()
	pass
