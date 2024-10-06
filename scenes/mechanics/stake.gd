extends KinematicBody2D

var vOldVelocity := Vector2()
var vVelocity := Vector2()
var fSpeed := 400.0

func _ready() -> void:
	#Not Working!
	self.queue_free()
	set_physics_process(true)

func _physics_process(_delta: float) -> void:
	vVelocity = move_and_slide(vVelocity, Vector2())
	
	#print(vVelocity)
	
	if !is_zero_approx(vOldVelocity.length()) and is_zero_approx(vVelocity.length()):
		global.nMainCamera.mediumShake()
	
	vOldVelocity = vVelocity

func getPushed(vDirection:Vector2) -> void:
	if !is_zero_approx(vDirection.x): vVelocity.x = vDirection.x * fSpeed
	if !is_zero_approx(vDirection.y): vVelocity.y = vDirection.y * fSpeed
