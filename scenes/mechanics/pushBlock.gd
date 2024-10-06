extends KinematicBody2D

var vOldVelocity := Vector2()
var vVelocity := Vector2()
var fSpeed := 400.0
var vDefaultPosition := Vector2()
onready var nColShape2d:CollisionShape2D = $collisionShape2D
onready var nTwn:Tween = $tween
onready var nSprite:Sprite = $sprite

func _ready() -> void:
	vDefaultPosition = self.global_position
	if get_node_or_null("%player"):
		var _v = ($"%player" as Player).connect("sgnDied", self, 'resetPosition')
	set_physics_process(true)

func resetPosition() -> void:
	if !self.global_position.is_equal_approx(vDefaultPosition):
		var _v = nTwn.interpolate_property(nSprite, 'scale', Vector2(), Vector2.ONE*2, 0.3,Tween.TRANS_BACK, Tween.EASE_OUT)
		_v = nTwn.start()
	
	self.global_position = vDefaultPosition
	self.vOldVelocity = Vector2()
	self.vVelocity = Vector2()
	self.nColShape2d.scale = Vector2.ONE

func _physics_process(_delta: float) -> void:
	if vVelocity.is_equal_approx(Vector2()):
		return
		
		
	vVelocity = move_and_slide(vVelocity, Vector2())
	
	var kc2d := move_and_collide(vVelocity * _delta, true, true, true)
	if kc2d:
		print(kc2d.normal)
		return
	
	if !is_zero_approx(vOldVelocity.length()) and is_zero_approx(vVelocity.length()):
		global.nMainCamera.mediumShake()
		nColShape2d.scale = Vector2.ONE
	
	vOldVelocity = vVelocity

func getPushed(vDirection:Vector2) -> void:
	#print(vDirection)
	if vDirection.x != 0:
		nColShape2d.scale.y = 0.9
	else:
		nColShape2d.scale.x = 0.9
		
	#nColShape2d.scale = 0.9 * Vector2.ONE
	if !is_zero_approx(vDirection.x): vVelocity.x = vDirection.x * fSpeed
	if !is_zero_approx(vDirection.y): vVelocity.y = vDirection.y * fSpeed
	vOldVelocity = Vector2()
