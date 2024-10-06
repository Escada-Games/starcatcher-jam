tool
extends HBoxContainer

export(String, 'Press', 'Hold', 'Release') var strCommand := 'Press'
export(String) var strFunction := 'AAA'

func _ready() -> void:
	set_process(true)

func _process(_delta: float) -> void:
	$strCommand.text = strCommand + ':'
	$strFunction.text = strFunction
