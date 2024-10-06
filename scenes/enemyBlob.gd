extends KinematicBody2D

onready var nAnimationPlayer:AnimationPlayer = $animationPlayer
onready var nTwn:Tween = $tween
onready var nSprite:AnimatedSprite = $animatedSprite
onready var nColShape2d:CollisionShape2D = $collisionShape2D
onready var nRcBack:RayCast2D = $rcBack
onready var nRcFront:RayCast2D = $rcFront
onready var nRcLeft:RayCast2D = $rcFloorLeft
onready var nRcRight:RayCast2D = $rcFloorRight
onready var nTmr:Timer = $timer

var bWasRcLeftColliding := false
var bWasRcRightColliding := false
var vVelocity := Vector2()
var fLastSpeed := 0.0
var fSpeed := 100.0
var fAppliedSpeed := 0.0
var fGravity := 1800.0
var vGravity := Vector2(0,1)
var vTargetGravity := Vector2(0,1)
export(Vector2) var vFloorNormal := Vector2(0,-1) setget _setFloorNormal
func _setFloorNormal(value) -> void:
	self.vGravity = -value.normalized()
	self.rotation = vGravity.angle() - PI/2
	if nSprite:
		var _v = nTwn.interpolate_property(nSprite,'rotation', nSprite.rotation + PI/2 * (1 if nRcFront.is_colliding() else -1), 0, 0.2, Tween.TRANS_SINE, Tween.EASE_OUT)
		_v = nTwn.start()
		
	vFloorNormal = value
	
func _ready() -> void:
	self.vGravity = -vFloorNormal.normalized()
	self.rotation = vGravity.angle() - PI/2
	set_physics_process(true)

func _physics_process(delta: float) -> void:
	#handleRotation()
	
	fAppliedSpeed = lerp(fAppliedSpeed, 0.0, 0.1)
	
	if !nRcRight.is_colliding() or !nRcLeft.is_colliding():
		fAppliedSpeed *= 0.95
	
	vVelocity = fAppliedSpeed * Vector2(1,0).rotated(self.rotation)
	vVelocity += vGravity*fGravity*delta
	vVelocity = move_and_slide(vVelocity, -vGravity.normalized())

func handleRotation() -> void:
	# No floor ahead
	if (bWasRcLeftColliding and !nRcLeft.is_colliding()) or\
		(bWasRcRightColliding and !nRcRight.is_colliding()) or\
		nRcBack.is_colliding() or nRcFront.is_colliding():
		fSpeed *= -1
		#self.vFloorNormal = vFloorNormal.rotated(PI/2)
	bWasRcLeftColliding = nRcLeft.is_colliding()
	bWasRcRightColliding = nRcRight.is_colliding()
	
func steppedOn() -> void:
	nAnimationPlayer.stop()
	nAnimationPlayer.play("steppedOn")

func _on_timer_timeout() -> void:
	nTmr.wait_time = 2 * rand_range(0.8, 1.2)
	nTmr.start()
	handleRotation()
	fAppliedSpeed = fSpeed
