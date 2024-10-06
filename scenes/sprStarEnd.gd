extends Sprite
class_name SpriteConstellationStar

onready var nTwn:Tween = $tween
export(bool) var bFormsLine := true

var fAngularSpeed := 0.0
var vTargetPosition := Vector2()

func _ready() -> void:
	fAngularSpeed = rand_range(-PI, PI) / 4.0
	vTargetPosition = self.global_position
	
	var fAngle := rand_range(0, 2*PI)
	self.global_position.x += 500 * cos(fAngle)
	self.global_position.y += 500 * sin(fAngle)
	
	var _v = nTwn.interpolate_property(self,'global_position', self.global_position, vTargetPosition, rand_range(1.0,5.0),Tween.TRANS_BACK,Tween.EASE_OUT)
	_v = nTwn.start()
	
	set_process(true)

func _process(delta: float) -> void:
	self.rotation += fAngularSpeed * delta
	
