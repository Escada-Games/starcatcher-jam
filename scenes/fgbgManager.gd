extends Node2D
class_name FgBgManager

const scnBgStars := preload("res://scenes/stars.tscn")
const scnBgNebula := preload("res://scenes/bgNebula.tscn")
const scnFgParticles := preload("res://scenes/fgParticles.tscn")

export(bool) var bRandomizePalette := false
export(int, 0, 13) var iPalette := 13


func _ready() -> void:
	if get_parent() is StageManager:
		iPalette = get_parent().iPalette
	
	if bRandomizePalette:
		randomize()
		iPalette = randi() % 14
	
	$layerBg/bgNebula.queue_free()
	$layerBg/stars.queue_free()
	$fgRockParticles.queue_free()
	
	var k = scnFgParticles.instance()
	k.iPalette = iPalette
	add_child(k)
	
	var j = scnBgNebula.instance()
	j.iPalette = iPalette
	j.z_index = -1000
	$layerBg.add_child(j)
	
	var i = scnBgStars.instance()
	i.iPalette = iPalette
	i.z_index = -10
	$layerBg.add_child(i)
