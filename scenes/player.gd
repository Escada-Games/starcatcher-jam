extends KinematicBody2D
class_name Player

signal sgnGroundPounded

enum States {Idle, Moving, OnAir, GroundPound, Locked, Died, Won, GravityBall, Diver, OnSpin}
export(States) var state = States.Idle setget _setState
func _setState(value) -> void:
	state = value
	
	if state == States.GroundPound:
		AudioManager.playSfx(AudioManager.sfxPlayerGroundPound)
		vVelocity = Vector2()
		twnSquish()
	elif state == States.Died:
		AudioManager.playSfx(AudioManager.sfxPlayerHurt)
		self.set_collision_layer_bit(0, false)
		self.set_collision_mask_bit(0, false)
	elif state == States.Won:
		AudioManager.playSfxWithoutPitchShift(AudioManager.sfxPlayerStarGet)
		nAnimationPlayer.play("win")
		yield(nAnimationPlayer, 'animation_finished')
		global.idxCurrentLevel += 1
		strNextLevel = global.arrLevels[global.idxCurrentLevel]
		global.changeSceneTo(strNextLevel)
	elif state == States.Diver:
		var _v = nTwn.interpolate_property(self, 'global_position', self.global_position, self.global_position + vGravity * 32.0, 0.3, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		_v = nTwn.start()

export(bool) var bCanFlip := false
export(String) var strNextLevel:String = "res://scenes/debugRoot.tscn"
export(String) var strCurrentConstelation = ''

const scnFxPlayerJumpDust := preload("res://scenes/fxPlayerJumpDust.tscn")
const scnFxPlayerLandDust := preload("res://scenes/fxPlayerLandDust.tscn")
const scnFxPlayerLandDustBigger := preload("res://scenes/fxPlayerLandDustBigger.tscn")
const scnFxPlayerRunDust := preload("res://scenes/fxPlayerWalkDust.tscn")

signal sgnDied
export(bool) var bInvertJump = false
var vInitialGlobalPosition := Vector2()
var nGravityBall:GravityBall = null
var vVelocity := Vector2()
var fSpeed := 100.0
var fMaxSpeed := 500.0
var fGravity := 1200.0
var vGravity := Vector2(0,1)
var vTargetGravity := Vector2(0,1)
var bSlowTurn := false
var bSkipFloorNormalAnimation := false
var vFloorNormal := Vector2(0,-1) setget _setFloorNormal
func _setFloorNormal(value) -> void:
	self.vGravity = -value.normalized()
	self.rotation = vGravity.angle() - PI/2
	
	if state == States.GravityBall:
		vFloorNormal = value
		return
	
	if bSkipFloorNormalAnimation:
		bSkipFloorNormalAnimation = false
		vFloorNormal = value
		return
		
	if bSlowTurn:
		nSprite.rotation += (PI/2 if !bSlowTurn else PI) * (1 if nRcFront.is_colliding() else -1) * sign(fSpeed)
		
	var _v = nTwn.interpolate_property(nSprite,'rotation', nSprite.rotation if bSlowTurn else nSprite.rotation + (PI/2 if !bSlowTurn else PI) * (1 if nRcFront.is_colliding() else -1) * sign(fSpeed), 0, 0.2, Tween.TRANS_SINE, Tween.EASE_OUT)
	#var _v = nTwn.interpolate_property(nSprite,'rotation', nSprite.rotation if bSlowTurn else nSprite.rotation + (PI/2 if !bSlowTurn else PI) * (1 if nRcFront.is_colliding() else -1) * sign(fSpeed), 0, 0.1, Tween.TRANS_SINE, Tween.EASE_OUT)
	_v = nTwn.start()
	
	if bSlowTurn:
		bSlowTurn = false
	
	vFloorNormal = value
	
var fJumpForce := 280.0#250.0
var bJumped := false
var t := 0
var bWasRcFrontColliding := false
var bWasRcLeftColliding := false
var nRcLeftCollidingWasCollidingWith:Node2D = null
var bWasRcRightColliding := false
var strCurrentAnimation := 'idle'
var fSpriteAngle := 0
var nDivedOn = null

onready var nTwn:Tween = $tween
onready var nTwnSquish:Tween = $tweenSquish
onready var nSprite:Sprite = $sprite
onready var nColShape2d:CollisionShape2D = $collisionShape2D
onready var nRcFront:RayCast2D = $rcFront
onready var nRcLeft:RayCast2D = $rcFloorLeft
onready var nRcRight:RayCast2D = $rcFloorRight
onready var nAnimationPlayer:AnimationPlayer = $animationPlayer
onready var nRcGravity:RayCast2D = $rcGravity
onready var nRcTargetGravity:RayCast2D = $rcTargetGravity
onready var nRcFloorCheck:RayCast2D = $rcFloorCheck
onready var nArea2d:Area2D = $area2D
onready var nSpriteAmogus:Sprite = $spriteAmogus
onready var nFloorArea2d:Area2D = $floorArea2D

func _ready() -> void:
	if get_parent() is StageManager:
		nSprite.texture = load("res://resources/textures/player/pal" + str(get_parent().iPalette) + ".png")
		pass
	
	bCanFlip = global.bPlayerCanFlip
	bCanFlip = true
	
	if bInvertJump:
		fGravity *= 0.1
	
	#strNextLevel = global.arrLevels[global.idxCurrentLevel]
	
	if randf() <= 0.01:
		nSprite.visible = false
		nSpriteAmogus.visible = true
#	if bCanFlip:
#		nSprite.texture = load("res://resources/textures/playerWithFlip.png")
#
	vInitialGlobalPosition = self.global_position
	set_physics_process(true)

func _input(event: InputEvent) -> void:
	if event.is_action_released("btn_main") and state == States.Moving:
		jump()
		self.state = States.OnAir
		if bInvertJump:
			vGravity *= -1

func _physics_process(delta: float) -> void:
	if OS.is_debug_build():
		$strState.visible = true
		$strFps.visible = true
		$strState.text = str(self.state)
		$strFps.text = 'Fps: ' + str(Engine.get_frames_per_second())
		
		if Input.is_action_just_pressed("ui_goToStageSelect"):
			global.changeSceneTo("res://scenes/debugStageSelect.tscn")
		
		#print(self.global_position)
#	if Input.is_action_just_pressed('ui_debug'):
#		self.state = States.Won
	
	if state == States.Won:
		fnStateWon(delta)
		return
		
	if state == States.OnSpin:
		strCurrentAnimation = 'idle'
		fnStateOnSpin(delta)
		if strCurrentAnimation != nAnimationPlayer.current_animation:
			nAnimationPlayer.play(strCurrentAnimation)
		return
		
	nFloorArea2d.position.x = -8 * sign(fSpeed)
	
	vVelocity.x = clamp(vVelocity.x, -fMaxSpeed, fMaxSpeed)
	vVelocity.y = clamp(vVelocity.y, -fMaxSpeed, fMaxSpeed)
	
	nRcGravity.cast_to = vGravity.rotated(-self.rotation) * 32
	nRcTargetGravity.cast_to = vFloorNormal.rotated(-self.rotation) * 64
	
	t += 1
	if t%10 == 0:
		pass
	vVelocity += vGravity*fGravity*delta
	nRcLeft.force_raycast_update()
	nRcFront.force_raycast_update()
	handleRotation()
	
	$strRcLeft.text = 'Left:' + str(nRcLeft.is_colliding())
	$strRcFront.text = 'Front:' + str(nRcFront.is_colliding())
	var bWasOnFloor = is_on_floor()
	
	match state:
		States.Diver:
			strCurrentAnimation = 'idle'
			fnStateDiver(delta)
			
		States.OnSpin:
			strCurrentAnimation = 'idle'
			fnStateOnSpin(delta)
			
		States.Died:
			strCurrentAnimation = 'dead'
			fnStateDied(delta)
			
		States.Locked:
			strCurrentAnimation = 'onAir'
			fnStateLocked(delta)
			
		States.Idle:
			strCurrentAnimation = 'idle'
			fnStateIdle(delta)
			
		States.Moving:
			strCurrentAnimation = 'run'
			fnStateMoving(delta)
			
		States.OnAir:
			strCurrentAnimation = 'onAir'
			fnStateOnAir(delta)
			
		States.GroundPound:
			strCurrentAnimation = 'onAir'
			fnStateGroundPound(delta)
			
		States.GravityBall:
			strCurrentAnimation = 'idle'
			bWasOnFloor = true
			fnStateGravityBall(delta)
	
	if !bWasOnFloor and is_on_floor():
		createLandDust()
	
	if strCurrentAnimation != nAnimationPlayer.current_animation:
		nAnimationPlayer.play(strCurrentAnimation)
	
	bWasRcFrontColliding = nRcFront.is_colliding()
	bWasRcRightColliding = nRcRight.is_colliding()
	bWasRcLeftColliding = nRcLeft.is_colliding()
	nRcLeftCollidingWasCollidingWith = nRcLeft.get_collider() if nRcLeft.is_colliding() else null
	
func fnStateWon(delta: float) -> void:
	vVelocity = vVelocity.linear_interpolate(Vector2(0,0), 0.1)
	vVelocity += vGravity*fGravity*delta
	vVelocity += vGravity*fGravity*delta
	
	vVelocity = move_and_slide(vVelocity, -vGravity.normalized())

func fnStateDied(delta: float) -> void:
	vVelocity = vVelocity.linear_interpolate(Vector2(0,0), 0.1)
	vVelocity += vGravity*fGravity*delta
	
	vVelocity = move_and_slide(vVelocity, -vGravity.normalized())
	
	self.rotation += delta * 3


func fnStateLocked(delta: float) -> void:
	vVelocity += vGravity*fGravity*delta
	
	vVelocity = move_and_slide(vVelocity, -vGravity.normalized())
	
	if self.is_on_floor():
		AudioManager.playSfx(AudioManager.sfxPlayerLand)
		self.state = States.Idle
		global.nMainCamera.minorShake()
		return

func fnStateGravityBall(delta: float) -> void:
	vVelocity = vVelocity.linear_interpolate(Vector2(0,0), 0.33)
	vVelocity += vGravity*fGravity*delta
	
	vVelocity = move_and_slide(vVelocity, -vGravity.normalized())
	
	self.vFloorNormal = -(nGravityBall.global_position - self.global_position).normalized()
	
#	if !self.is_on_floor():
#		self.state = States.OnAir
#		return
#
	if Input.is_action_just_pressed("btn_main"):
		jump()
		self.state = States.OnAir
		return

func fnStateDiver(_delta: float) -> void:
	vVelocity = Vector2()
	
	#if nTwn.is_active():
		#return
	
	if Input.is_action_just_pressed("btn_main"):
		var _v = nTwn.stop_all()
		self.set_collision_layer_bit(0, false)
		self.set_collision_mask_bit(0, false)
		self.state = States.OnAir
		jump(1.2)
		#jump(1.66)
		#bJumped = false
		return

func fnStateIdle(delta: float) -> void:
	vVelocity = vVelocity.linear_interpolate(Vector2(0,0), 0.33)
	vVelocity += vGravity*fGravity*delta
	
	vVelocity = move_and_slide(vVelocity, -vGravity.normalized())
	
	if !self.is_on_floor():
		self.state = States.OnAir
		return
	
	if Input.is_action_just_pressed("btn_main"):
		self.state = States.Moving
		return

func fnStateOnSpin(_delta: float) -> void:
	return

func fnStateMoving(delta: float) -> void:
	#Engine.time_scale = 0.1
	vVelocity = fSpeed * Vector2(1,0).rotated(self.rotation)
	vVelocity += vGravity*fGravity*delta*10
	#vVelocity = move_and_slide(vVelocity, -vGravity.normalized())
	
	vVelocity = move_and_slide_with_snap(vVelocity, vFloorNormal*16, -vGravity.normalized())
	
	if vVelocity != Vector2():
		nSprite.visible = true
		nSpriteAmogus.visible = false
		
	if Input.is_action_just_released("btn_main"):
		return # Currently using the _input event to handle jumping, to reduce input lag
#		jump()
#		self.state = States.OnAir
#		if bInvertJump:
#			vGravity *= -1
#		return
#
func fnStateOnAir(_delta: float) -> void:
	vVelocity = move_and_slide(vVelocity, -vGravity.normalized())
	
	if Input.is_action_just_pressed("btn_main"):
		self.state = States.GroundPound
		if bInvertJump:
			vGravity *= -1
		return
	
	if is_on_floor():
		AudioManager.playSfx(AudioManager.sfxPlayerLand)
		bJumped = false
		
		if Input.is_action_pressed("btn_main"):
			self.state = States.Moving
			return
		self.state = States.Idle
		
		twnLandSquish()
#		createLandDust()
		return
		
func fnStateGroundPound(delta: float) -> void:
	vVelocity += vGravity*fGravity*delta*4
	vVelocity = move_and_slide(vVelocity, -vGravity.normalized())
	
	if is_on_floor():
		for n in nFloorArea2d.get_overlapping_bodies():
			if n.is_in_group('DiverBlock'):
				self.state = States.Diver
				return
			elif n.is_in_group('PushBlock') and state == States.GroundPound:
				n.getPushed(vGravity)
#			elif n.is_in_group('PushBlock'):
#				print('!!!')
#				self.state = States.Idle
#				n.getPushed(vGravity)
#				return
			elif n.is_in_group('Spinner'):
				
				AudioManager.playSfx(AudioManager.sfxPlayerLand)
				global.nMainCamera.minorShake()
				createLandDustBigger()
				nSprite.scale = Vector2(1,1)
				#twnLandSquish()
				flipDirection()
				AudioManager.playSfx(AudioManager.sfxPlayerGroundPoundLand)
				
				var vLever:Vector2 = -(self.global_position - n.global_position)
				var fSign:float = sign(-vLever.angle_to(vGravity))
				n.spin(PI/2 * fSign)
				self.state = States.OnSpin
				var nOldParent = get_parent()
				
				var v = global_position
				
				get_parent().remove_child(self)
				n.add_child(self)
				if fSign > 0:
					self.rotation -= n.rotation
				else:
					self.rotation += n.rotation * fSign
				
				global_position = v
				
				yield(n.nTwn, 'tween_all_completed')
				
				v = global_position
				
				get_parent().remove_child(self)
				nOldParent.add_child(self)
				self.global_position = v
				
				bSkipFloorNormalAnimation = true
				self.vFloorNormal = vFloorNormal.rotated(PI/2 * fSign)
				bJumped = false

				
				#self.global_position += n.global_position
				#bJumped = false
				self.state = States.Idle
				
				#self.state = States.GroundPound
				return
		
		if !get_floor_normal().is_equal_approx(self.vFloorNormal):
			self.vFloorNormal = get_floor_normal()
		vVelocity *= 0.5
		
		AudioManager.playSfx(AudioManager.sfxPlayerLand)
		bJumped = false
		self.state = States.Idle
		global.nMainCamera.minorShake()
		createLandDustBigger()
		twnLandSquish()
		flipDirection()
		AudioManager.playSfx(AudioManager.sfxPlayerGroundPoundLand)
		
		emit_signal('sgnGroundPounded')
		return
	
	return

func flipDirection() -> void:
	if !bCanFlip:
		return
		
	nSprite.flip_h = !nSprite.flip_h
	fSpeed *= -1
	nRcLeft.position.x *= -1
	nRcFront.position.x *= -1
	nRcFront.cast_to.x *= -1

func handleRotation() -> void:
	if bJumped:
		return
		
	if (state != States.Moving) and (state != States.OnSpin):
		return
	
	if nTwn.is_active():
		return
	
	# Wall ahead
	if nRcLeft.is_colliding() and nRcFront.is_colliding():
		# Special wall ahead
		if (nRcFront.get_collider() as Node2D).is_in_group('SlideBlock'):
			return
			
		self.vFloorNormal = nRcFront.get_collision_normal()
	
	# No floor ahead
	elif bWasRcLeftColliding and !nRcLeft.is_colliding():
		# Special floor ahead
		if (nRcLeftCollidingWasCollidingWith).is_in_group('SlideBlock'):
			self.state = States.OnAir
			return
		self.vFloorNormal = vFloorNormal.rotated(sign(fSpeed)*PI/2)

func createRunDust(fScaleMultiplier:float = 1) -> void:
	var i:AnimatedSprite = scnFxPlayerRunDust.instance()
	i.global_position = self.global_position - Vector2(0, 16).rotated(self.rotation)
	i.rotation = self.rotation
	i.scale *= fScaleMultiplier
	i.flip_h = nSprite.flip_h
	get_parent().add_child(i)

func createLandDust(fScaleMultiplier:float = 1) -> void:
	var i := scnFxPlayerLandDust.instance()
	i.global_position = self.global_position - Vector2(0, 16).rotated(self.rotation)
	i.rotation = self.rotation
	i.scale *= fScaleMultiplier
	get_parent().add_child(i)
	
func createLandDustBigger(fScaleMultiplier:float = 1) -> void:
	var i := scnFxPlayerLandDustBigger.instance()
	i.global_position = self.global_position - Vector2(0, 16).rotated(self.rotation)
	i.rotation = self.rotation
	i.scale *= fScaleMultiplier
	get_parent().add_child(i)

func createJumpDust() -> void:
	var i := scnFxPlayerJumpDust.instance()
	i.global_position = self.global_position - Vector2(0, 16).rotated(self.rotation)
	i.rotation = self.rotation
	get_parent().add_child(i)

func jump(fMultiplier:float = 1) -> void:
	bJumped = true
	self.vVelocity -= vGravity * fJumpForce * fMultiplier
	twnSquish()
	createJumpDust()
	AudioManager.playSfx(AudioManager.sfxPlayerJump)
	return

func twnSquish() -> void:
	var _v = nTwnSquish.interpolate_property(nSprite, 'scale', Vector2(0.5, 1.5), Vector2.ONE, 0.3, Tween.TRANS_BACK, Tween.EASE_OUT)
	_v = nTwnSquish.start()
	return
	
func twnLandSquish() -> void:
	var _v = nTwnSquish.interpolate_property(nSprite, 'scale', Vector2(1.6, 0.4), Vector2.ONE, 0.5, Tween.TRANS_BACK, Tween.EASE_OUT)
	_v = nTwnSquish.start()
	return

func respawn() -> void:
	emit_signal('sgnDied')
	self.vVelocity = Vector2()
	self.rotation = 0
	self.bJumped = false
	self.state = States.Locked
	self.vVelocity = Vector2()
	self.vFloorNormal = Vector2(0,-1)
	self.set_collision_layer_bit(0, true)
	self.set_collision_mask_bit(0, true)
	self.global_position = self.vInitialGlobalPosition
	self.vVelocity = Vector2()
	
	if nSprite.flip_h:
		flipDirection()

func _on_visibilityNotifier2D_screen_exited() -> void:
	if state == States.Won:
		return
		
	if state == States.OnSpin:
		return
	
	yield(get_tree().create_timer(0.33), "timeout")
	respawn()

func _on_area2D_body_entered(body: Node) -> void:
	if state == States.Died:
		return
		
	if state == States.Won:
		return
		
	if state == States.OnSpin:
		return
	
	if body.is_in_group('Blob'):
		if state == States.GroundPound:
			body.steppedOn()
			self.state = States.OnAir
			jump(5)
			
	elif body.is_in_group('GravityBall'):
		print(state)
		if state == States.GroundPound:
			if body.has_method('groundPounded'):
				body.set_collision_layer_bit(0, false)
				body.set_collision_mask_bit(0, false)

				body.groundPounded()
				return
		nGravityBall = body
		self.state = States.GravityBall
#		self.vFloorNormal = -(nGravityBall.global_position - self.global_position).normalized()
		#self.vFloorNormal = get_floor_normal()

	elif body.is_in_group('Jumpy'):
		
		if state == States.OnAir:
			self.state = States.OnAir
			jump(3)
		elif state == States.GroundPound:
			self.state = States.Idle
			flipDirection()
			body.goDown()
	
	elif body.is_in_group('DiverBlock'):
		if state != States.GroundPound:
			return
			
		nDivedOn = body
		self.state = States.Diver
	
#	elif body.is_in_group('PushBlock'):
#		if state != States.GroundPound:
#			return
#		body.getPushed(vGravity)
		
	elif body.is_in_group('AngryBlob'):
		if state == States.GroundPound:
			AudioManager.playSfx(AudioManager.sfxPlayerLandOnSlime)
			body.steppedOn()
			self.state = States.OnAir
			jump(5)
			bSlowTurn = true
			yield(get_tree().create_timer(0.1),"timeout")
			self.vFloorNormal = self.vFloorNormal.rotated(PI)
	elif body.is_in_group('Enemy'):
		global.nMainCamera.minorShake()
		self.vVelocity = vFloorNormal * 3 * fJumpForce
		self.state = States.Died
	elif body.is_in_group('Spike'):
		global.nMainCamera.minorShake()
		self.vVelocity = vFloorNormal * 3 * fJumpForce
		self.state = States.Died
	elif body.is_in_group('Exit'):
		self.state = States.Won
		
		if !self.vFloorNormal.is_equal_approx(Vector2.RIGHT.rotated(body.rotation - PI/2)):
			print(self.vFloorNormal)
			print(Vector2.RIGHT.rotated(body.rotation - PI/2))
			self.vFloorNormal = Vector2.RIGHT.rotated(body.rotation - PI/2)
			
			var twnVelocity := create_tween().set_parallel(true)
			#twnVelocity.tween_property(self, 'vVelocity', Vector2(), 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
			var _v = twnVelocity.tween_property(self, 'vVelocity', -0.1*vVelocity, 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
			#twnVelocity.tween_property(self, 'global_position', self.global_position, 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
			
	elif body.is_in_group('StarPiece'):
		AudioManager.playSfx(AudioManager.sfxPlayerStarPieceGet)
		body.emit_signal('sgnCollected')
	elif body.is_in_group('Upgrade'):
		if body.has_method('disappear'):
			body.disappear()
		global.bPlayerCanFlip = true
		bCanFlip = true
		nSprite.texture = load("res://resources/textures/playerWithFlip.png")
		
func createFootstepSfx() -> void:
	AudioManager.playSfx(AudioManager.sfxPlayerFootstep)


func flipPlayer() -> void:
	self.state = States.OnAir
	bSlowTurn = true
	yield(get_tree().create_timer(0.1),"timeout")
	self.vFloorNormal = self.vFloorNormal.rotated(PI)

func _on_floorArea2D_body_entered(body: Node) -> void:
	if state == States.Died:
		return
		
	if state == States.Won:
		return
		
	if state == States.OnSpin:
		return
		
	if body.is_in_group('Flipper') and state == States.GroundPound:
		body = body as Flipper
		disablePlayerCollision()
		body.playAnimFlip()
		#body.disablePlayerCollision()
		
		if is_zero_approx(vGravity.x):
			self.vVelocity.x = 0
			self.vVelocity.y = clamp(self.vVelocity.y, 100, 120) * sign(self.vVelocity.y)
		else:
			self.vVelocity.y = 0
			self.vVelocity.x = clamp(self.vVelocity.x, 100, 120) * sign(self.vVelocity.x)
		
		self.flipPlayer()
		self.state = States.Locked
	elif body.is_in_group('PushBlock') and state == States.GroundPound:
		body.getPushed(vGravity)

func disablePlayerCollision() -> void:
	self.set_collision_layer_bit(0, false)
	self.set_collision_mask_bit(0, false)
	
func enablePlayerCollision() -> void:
	self.set_collision_layer_bit(0, true)
	self.set_collision_mask_bit(0, true)


func _on_area2D_body_exited(body: Node) -> void:
	if body.is_in_group('Flipper'):
		vVelocity = Vector2()
		state = States.GroundPound
		enablePlayerCollision()
	elif body.is_in_group('DiverBlock'):
		self.set_collision_layer_bit(0, true)
		self.set_collision_mask_bit(0, true)
