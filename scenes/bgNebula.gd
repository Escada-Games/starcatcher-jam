extends Node2D

#var arrTextures:Array = [
#	"res://resources/textures/nebulas/sprNebula1.png",
#	"res://resources/textures/nebulas/sprNebula2.png",
#	"res://resources/textures/nebulas/sprNebula3.png",
#	"res://resources/textures/nebulas/sprNebula4.png",
#	"res://resources/textures/nebulas/sprNebula5.png"
#]

var iPalette := 13
onready var nSprite:Sprite = $sprite

func _ready() -> void:
	if randf() < 0.5:
		nSprite.scale.x *= -1
	if randf() < 0.5:
		nSprite.scale.y *= -1
		
	var idx := randi() % 22

	nSprite.texture = load("res://resources/textures/nebulas/palette" + str(iPalette) + "/" + str(idx) + ".png")
	set_physics_process(true)

func _physics_process(delta: float) -> void:
	nSprite.rotation += delta/10000.0
