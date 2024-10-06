tool
extends Node2D

var nCamera:Camera2D = null

func _ready() -> void:
	#if !OS.has_feature('editor'):
	if !Engine.is_editor_hint():
		self.queue_free()
	nCamera = get_parent()
	set_process(true)
	
func _process(_delta: float) -> void:
	if nCamera:
		self.global_position = nCamera.zoom * Vector2(315,250)/2.0
