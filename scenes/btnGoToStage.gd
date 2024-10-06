extends Button

var strStage:String = ''

func _ready() -> void:
	pass

func _on_btnGoToStage_pressed() -> void:
	if strStage != '':
		global.changeSceneTo(strStage)
