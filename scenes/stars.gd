extends Node2D

const scnStar := preload("res://scenes/sprStar.tscn")
var iPalette := 13 

func _ready() -> void:
	for _i in range(90):
		var i:SprStar = scnStar.instance()
		i.iPalette = iPalette
		add_child(i)
		i.global_position.x = rand_range(0,315)
		i.global_position.y = rand_range(0,250)
