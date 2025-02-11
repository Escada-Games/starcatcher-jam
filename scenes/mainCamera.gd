extends Camera2D
 
export(bool) var bFollowPlayer := false
var nPlayer:Player = null

var _duration = 0.0
var _period_in_ms = 0.0
var _amplitude = 0.0
var _timer = 0.0
var _last_shook_timer = 0
var _previous_x = 0.0
var _previous_y = 0.0
var _last_offset = Vector2(0, 0)
 
 
func _ready() -> void:
	global.nMainCamera = self
	set_process(true)
	set_physics_process(bFollowPlayer)
	
	if bFollowPlayer:
		self.anchor_mode = Camera2D.ANCHOR_MODE_DRAG_CENTER
		self.position += Vector2(315, 250) / 2.0
		self.nPlayer = $"%player"
		self.rotating = true

 
func _physics_process(_delta: float) -> void:
	if bFollowPlayer:
		self.global_position = nPlayer.global_position + 315 * (Vector2.ONE * 0.4 * nPlayer.vFloorNormal + 0.2 * Vector2(sign(nPlayer.fSpeed), 1).rotated(nPlayer.vFloorNormal.angle() + PI/2))
		self.rotation = lerp_angle(self.rotation, nPlayer.rotation, 0.1)#

# Shake with decreasing intensity while there's time remaining.
func _process(delta):
	# Only shake when there's shake time remaining.
	if _timer == 0:
		set_offset(Vector2())
		set_process(false)
		return
	# Only shake on certain frames.
	_last_shook_timer = _last_shook_timer + delta
	# Be mathematically correct in the face of lag; usually only happens once.
	while _last_shook_timer >= _period_in_ms:
		_last_shook_timer = _last_shook_timer - _period_in_ms
		# Lerp between [amplitude] and 0.0 intensity based on remaining shake time.
		var intensity = _amplitude * (1 - ((_duration - _timer) / _duration))
		# Noise calculation logic from http://jonny.morrill.me/blog/view/14
		var new_x = rand_range(-1.0, 1.0)
		var x_component = intensity * (_previous_x + (delta * (new_x - _previous_x)))
		var new_y = rand_range(-1.0, 1.0)
		var y_component = intensity * (_previous_y + (delta * (new_y - _previous_y)))
		_previous_x = new_x
		_previous_y = new_y
		# Track how much we've moved the offset, as opposed to other effects.
		var new_offset = Vector2(x_component, y_component)
		set_offset(get_offset() - _last_offset + new_offset)
		_last_offset = new_offset
	# Reset the offset when we're done shaking.
	_timer = _timer - delta
	if _timer <= 0:
		_timer = 0
		set_offset(get_offset() - _last_offset)
 
 
# Kick off a new screenshake effect.
# 0.2, 15, and 8
func shake(duration, frequency, amplitude):
	# Don't interrupt current shake duration
	if(_timer != 0):
		return
   
	# Initialize variables.
	_duration = duration
	_timer = duration
	_period_in_ms = 1.0 / frequency
	_amplitude = amplitude
	_previous_x = rand_range(-1.0, 1.0)
	_previous_y = rand_range(-1.0, 1.0)
	# Reset previous offset, if any.
	set_offset(get_offset() - _last_offset)
	_last_offset = Vector2(0, 0)
	set_process(true)
	
func minorShake() -> void:
	shake(0.2, 15, 8)
	
func mediumShake() -> void:
	shake(0.3, 20, 10)
