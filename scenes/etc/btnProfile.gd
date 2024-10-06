extends Button

export(bool) var bGrabFocus := false

onready var nTwn:Tween = $tween


func _ready() -> void:
	set_process(false)
	if bGrabFocus:
		self.grab_focus()

func _process(_delta: float) -> void:
	if !self.has_focus():
		return
	
	if Input.is_action_just_released("btn_main"):
		get_node(self.focus_next).grab_focus()
	

func _on_btnProfile_focus_entered() -> void:
	var _v = nTwn.remove_all()
	_v = nTwn.interpolate_property(self,'rect_position:y', self.rect_position.y, -16, 0.4,Tween.TRANS_BACK, Tween.EASE_OUT)
	_v = nTwn.start()
	set_process(true)

func _on_btnProfile_focus_exited() -> void:
	var _v = nTwn.remove_all()
	_v = nTwn.interpolate_property(self,'rect_position:y', self.rect_position.y, 0, 0.3,Tween.TRANS_QUINT, Tween.EASE_OUT)
	_v = nTwn.start()
	set_process(false)

func onPressed() -> void:
	print('ei!')
	$marginContainer/vBoxContainer/strProfileName.text = 'Pressed!'
	pass
