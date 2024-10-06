extends KinematicBody2D

onready var nTwn:Tween = $tween
onready var nSprite:AnimatedSprite = $animatedSprite
onready var nColShape2d:CollisionShape2D = $collisionShape2D
onready var nRcFront:RayCast2D = $rcFront
onready var nRcLeft:RayCast2D = $rcFloorLeft
onready var nRcRight:RayCast2D = $rcFloorRight

var bWasRcLeftColliding := false
var vVelocity := Vector2()
var fSpeed := 80.0
var fGravity := 1800.0#1800.0
var vGravity := Vector2(0,1)
var vTargetGravity := Vector2(0,1)
export(Vector2) var vFloorNormal := Vector2(0,-1) setget _setFloorNormal
func _setFloorNormal(value) -> void:
	self.vGravity = -value.normalized()
	self.rotation = vGravity.angle() - PI/2
	if nSprite:
		var _v = nTwn.interpolate_property(nSprite,'rotation', nSprite.rotation + PI/2 * (1 if nRcFront.is_colliding() else -1), 0, 0.25, Tween.TRANS_SINE, Tween.EASE_OUT)
		_v = nTwn.start()
		
	vFloorNormal = value
	
	
func _ready() -> void:
	self.vGravity = -vFloorNormal.normalized()
	self.rotation = vGravity.angle() - PI/2
	set_physics_process(true)

func _physics_process(delta: float) -> void:
	handleRotation()
	
	vVelocity = fSpeed * Vector2(1,0).rotated(self.rotation)
	vVelocity += vGravity*fGravity*delta
	vVelocity = move_and_slide(vVelocity, -vGravity.normalized())
	
	bWasRcLeftColliding = nRcLeft.is_colliding()

func handleRotation() -> void:
#	if nTwn.is_active():
#		return
	
	# Wall ahead
	if nRcLeft.is_colliding() and nRcFront.is_colliding():
		self.vFloorNormal = nRcFront.get_collision_normal()
	
	# No floor ahead
	elif bWasRcLeftColliding and !nRcLeft.is_colliding():
		self.vFloorNormal = vFloorNormal.rotated(PI/2)
