extends StaticBody2D

func _ready() -> void:
	if get_parent() is StageManager:
		$sprite.frame = get_parent().iPalette
