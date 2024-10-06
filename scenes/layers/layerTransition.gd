extends CanvasLayer
class_name LayerTransition

export(int) var iCellSize := 16
export(String) var strTransitionTo := "res://scenes/mainMenu.tscn"
export(String, 'FadeIn', 'FadeOut') var strFadeMode := 'FadeIn'
const scnSprCell := preload("res://scenes/layers/sprFadeCell.tscn")
onready var nTwn := Tween.new()
onready var nSprite := Sprite.new()

func _ready() -> void:
	var _v = null
	add_child(nTwn)
	add_child(nSprite)
	nSprite.z_index = 64
	nSprite.texture = load("res://resources/meta/icon.png")
	nSprite.position = Vector2(315,250) - 16 * Vector2.ONE
	nSprite.modulate.a = 0 if strFadeMode == 'FadeIn' else 1
	
	for i in range(0,512,iCellSize):
		for j in range(0,288,iCellSize):
			var k:SpriteFadeCell = scnSprCell.instance()
			k.global_position = Vector2(i,j)# * iCellSize
			k.fTwnDelay = 0.08*(i+j)/pow(iCellSize,2)
			if strFadeMode == 'FadeOut':
				k.bWillGrow = false
			add_child(k)
	
	yield(get_tree().create_timer(0.3),"timeout")
	_v = nTwn.interpolate_property(
		nSprite,
		'modulate:a',
		nSprite.modulate.a,
		1 if strFadeMode == 'FadeIn' else 0,
		0.3,
		Tween.TRANS_CUBIC,
		Tween.EASE_IN_OUT
	)
	if strFadeMode == 'FadeIn':
		_v = nTwn.interpolate_property(
			nSprite,
			'position:y',
			nSprite.position.y-32,
			nSprite.position.y,
			0.6,
			Tween.TRANS_CUBIC,
			Tween.EASE_IN_OUT
		)
	_v = nTwn.start()
	yield(get_tree().create_timer(0.5),"timeout")
	
	if strFadeMode == 'FadeIn':
		var l = get_script().new()
		l.strFadeMode = 'FadeOut'
		_v = get_tree().change_scene(strTransitionTo)
		get_tree().root.call_deferred('add_child',l)
		call_deferred('queue_free')
	else:
		self.queue_free()
