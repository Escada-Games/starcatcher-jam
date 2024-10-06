extends Node2D

var arrStarPieces := []
var nCurrentStarPiece:StaticBody2D = null
onready var nStarPieces:Node2D = $starPieces
onready var nTwn:Tween = $tween
onready var nExit:StaticBody2D = $exit

func _ready() -> void:
	var _v = null
	if $"%player":
		if !$"%player".is_connected('sgnDied', self, '_ready'):
			_v = $"%player".connect('sgnDied', self, '_ready')
	
	arrStarPieces = []
	
	for _n in nStarPieces.get_children():
		var n:StarPiece = (_n as StarPiece)
		
		arrStarPieces.append(n)
		
		
		if !n.is_connected('sgnCollected', self, 'starCollected'):
			_v = n.connect('sgnCollected', self, 'starCollected')
		if n.name != '0':
			n.scale = Vector2.ZERO
			n.set_collision_layer_bit(1, false)
			n.set_collision_mask_bit(1, false)
		else:
			n.scale = Vector2.ZERO
			_v = nTwn.interpolate_property(n, 'scale', Vector2.ZERO, Vector2.ONE, 0.4, Tween.TRANS_BACK, Tween.EASE_IN)
			_v = nTwn.start()
			n.set_collision_layer_bit(1, true)
			n.set_collision_mask_bit(1, true)
			
	nExit.scale = Vector2.ZERO
	nExit.set_collision_layer_bit(1, false)
	nExit.set_collision_mask_bit(1, false)
	
	nCurrentStarPiece = arrStarPieces.pop_front()
	

func starCollected() -> void:
	var _v = null
	nCurrentStarPiece.set_collision_layer_bit(1, false)
	nCurrentStarPiece.set_collision_mask_bit(1, false)
	_v = nTwn.interpolate_property(nCurrentStarPiece, 'scale', Vector2.ONE, Vector2.ZERO, 0.4, Tween.TRANS_BACK, Tween.EASE_IN)
	
	nCurrentStarPiece = arrStarPieces.pop_front()
	if !nCurrentStarPiece:
		nCurrentStarPiece = nExit
	
	nCurrentStarPiece.set_collision_layer_bit(1, true)
	nCurrentStarPiece.set_collision_mask_bit(1, true)
	_v = nTwn.interpolate_property(nCurrentStarPiece, 'scale', Vector2.ZERO, Vector2.ONE, 0.4, Tween.TRANS_BACK, Tween.EASE_OUT, 0.1)
	_v = nTwn.start()
