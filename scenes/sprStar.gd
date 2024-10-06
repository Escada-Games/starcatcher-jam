extends Sprite
class_name SprStar

var fRotationSpeed:float = 0.0
var iPalette := 13
onready var nTwn:Tween = $tween
onready var nTmr:Timer = $timer

func _ready() -> void:
	self.frame_coords.x = randi() % self.hframes
	self.frame_coords.y = iPalette
	
	self.scale *= rand_range(1.0, 1.5)
	self.modulate = Color.darkgray
	fRotationSpeed = rand_range(-PI/8, PI/8)
	set_process(true)

func _process(delta: float) -> void:
	self.rotation += fRotationSpeed * delta

func _on_timer_timeout() -> void:
	if randf() < 0.05:
		blink()

func blink() -> void:
	var _v = nTwn.interpolate_property(self, 'modulate', Color.white, Color.darkgray, rand_range(0.3, 2.0), Tween.TRANS_CUBIC, Tween.EASE_OUT)
	_v = nTwn.start()
