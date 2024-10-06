extends Node

const scnLayerTransition := preload("res://scenes/layers/layerTransition.tscn")
var nMainCamera:Camera2D = null
var bPlayerCanFlip:bool = false

var idxCurrentLevel := 0
var arrLevels := [
	"res://scenes/levels/0.tscn",
	"res://scenes/levels/1.tscn",
	"res://scenes/levels/2.tscn",
	"res://scenes/levels/6.tscn",
	"res://scenes/levels/24.tscn",
	"res://scenes/levels/25.tscn",
	"res://scenes/levels/3.tscn",
	"res://scenes/levels/4.tscn",
	"res://scenes/levels/5.tscn",
	"res://scenes/levels/7.tscn",
	"res://scenes/levels/8.tscn",
	"res://scenes/levels/9.tscn",
	"res://scenes/levels/15.tscn",
	"res://scenes/levels/11.tscn",
	"res://scenes/levels/12.tscn",
	"res://scenes/levels/13.tscn",
	"res://scenes/levels/14.tscn",
	"res://scenes/levels/16.tscn",
	"res://scenes/levels/17.tscn",
	"res://scenes/levels/18.tscn",
	"res://scenes/levels/19.tscn",
#	"res://scenes/levels/20.tscn",
#	"res://scenes/levels/21.tscn",
	"res://scenes/levels/22.tscn",
	"res://scenes/levels/23.tscn",
	"res://scenes/levels/10.tscn",
	"res://scenes/levels/26-end.tscn"
]

func _ready() -> void:
	pass
	
func changeSceneTo(strPath:String) -> void:
	var i:LayerTransition = scnLayerTransition.instance()
	i.strTransitionTo = strPath
	i.strFadeMode = 'FadeIn'
	get_tree().root.add_child(i)
	pass
