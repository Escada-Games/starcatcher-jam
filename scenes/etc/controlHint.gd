extends Control

var fHoldTime := 0.0
var fMaximumHoldTime := 0.5
onready var nProgressBarHold:ProgressBar = $marginContainer/panelContainer/vBoxContainer/progressBarHold

func _ready() -> void:
	set_process(true)

func _process(delta: float) -> void:
	nProgressBarHold.max_value = fMaximumHoldTime
	nProgressBarHold.value = fHoldTime
	
	if Input.is_action_pressed("btn_main"):
		fHoldTime += delta
	else:
		fHoldTime -= 2 * delta
	fHoldTime = clamp(fHoldTime, 0.0, fMaximumHoldTime)
	
	if fHoldTime >= fMaximumHoldTime:
		fHoldTime = 0.0
		if get_focus_owner().has_method('onPressed'):
			get_focus_owner().onPressed()
