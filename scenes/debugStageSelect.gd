extends Node

const scnBtnGoToScene:Resource = preload("res://scenes/btnGoToStage.tscn")
onready var nVboxStages:VBoxContainer = $control/marginContainer/panel/marginContainer/scrollContainer/vbox

func _ready() -> void:
	var strDir:String = "res://scenes/levels/"
	var dir:Directory = Directory.new()
	var _v = dir.open(strDir)
	_v = dir.list_dir_begin()
	
	var file_name = dir.get_next()
	while file_name != "":
		if dir.current_is_dir():
			pass
		else:
			var nBtn:Button = scnBtnGoToScene.instance()
			nBtn.text = file_name
			nBtn.strStage = strDir + file_name
			nVboxStages.add_child(nBtn)
		file_name = dir.get_next()
