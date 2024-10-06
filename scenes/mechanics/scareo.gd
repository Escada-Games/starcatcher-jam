extends KinematicBody2D

var vVelocity := Vector2()
export(Vector2) var vDirection := Vector2(0,1) 
var fSpeed := 300.0#400.0
var bSleeping := false
onready var nTwn:Tween = $tween
onready var nColShape2d:CollisionShape2D = $collisionShape2D

func _ready() -> void:
	for n in get_tree().get_nodes_in_group('Player'):
		var _v = (n as Player).connect('sgnGroundPounded', self, 'onPlayerGroundPound')
	
	set_physics_process(true)

func _physics_process(_delta: float) -> void:
	if bSleeping: 
		return
	
	vVelocity = vVelocity.linear_interpolate(fSpeed * vDirection, 0.05)
	vVelocity = move_and_slide(vVelocity)
	
	if is_zero_approx(vVelocity.length()):
		resetCollision()
		bSleeping = true

func onPlayerGroundPound() -> void:
	fSpeed *= -1.0
	bSleeping = false
	squishCollision()
	pass

func squishCollision() -> void:
	if !is_zero_approx(vDirection.x):
		nColShape2d.scale.y = 0.9
		pass
	elif !is_zero_approx(vDirection.y):
		nColShape2d.scale.x = 0.9
		
func resetCollision() -> void:
	nColShape2d.scale = Vector2.ONE
