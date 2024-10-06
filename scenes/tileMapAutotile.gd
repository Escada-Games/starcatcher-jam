extends TileMap
class_name AutotileRandomFill

export(int) var iPalette := 0 setget _setPalette
func _setPalette(value) -> void:
	iPalette = value
	self.tile_set = load("res://resources/textures/tilemaps/" + str(iPalette) + ".tres")
	
export(bool) var bAllowRandomFill := true

func _ready() -> void:
	var nStageManager:Node2D = get_parent().get_parent()
	if nStageManager is StageManager:
		self.iPalette = nStageManager.iPalette
		pass
		
	
	if !bAllowRandomFill:
		return
	
	for v in get_used_cells():
		var vAutotileCoord:Vector2 = get_cell_autotile_coord(v.x, v.y)
		if vAutotileCoord == Vector2(2,1):
			set_cellv(v, 1, randf() < 0.5, false, false, Vector2(randi() % 4, randi() % 4))
