extends StaticBody2D
class_name ExitStar

onready var nSprite:Sprite = $sprite

func _ready() -> void:
	if get_parent() is StageManager:
		nSprite.frame = get_parent().iPalette
