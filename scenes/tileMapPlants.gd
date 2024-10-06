extends TileMap


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for vCell in get_parent().get_used_cells():
		if get_parent().get_cellv(vCell) == 1:
			pass
			#self.set_cell(vCell.x, vCell.y, 3)
			#self.set_cellv(vCell, )
	self.update_dirty_quadrants()

func _get_subtile_coord(id):
	var tiles = self.tile_set
	var rect = self.tile_set.tile_get_region(id)
	var x = randi() % int(rect.size.x / tiles.autotile_get_size(id).x)
	var y = randi() % int(rect.size.y / tiles.autotile_get_size(id).y)
	return Vector2(x, y)
