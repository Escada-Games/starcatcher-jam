extends Node2D
class_name FgParticles

var iPalette := 13

func _ready() -> void:
	if OS.has_feature('HTML5'):
		pass
	$cPUParticles2D.texture = load("res://resources/textures/fgParticles/pal" + str(iPalette) + ".png")
	$cPUParticles2D2.texture = load("res://resources/textures/fgParticles/pal" + str(iPalette) + ".png")
		
