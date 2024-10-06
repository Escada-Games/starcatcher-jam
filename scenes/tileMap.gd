extends TileMap


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for vCell in get_used_cells():
		if randf() < 0.15:
			set_cellv(vCell, 1 + randi() % 15)
