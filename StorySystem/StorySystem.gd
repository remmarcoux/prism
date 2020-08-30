extends Node

signal onSceneDone;

func _ready():
	pass

func _on_scene_done():
	emit_signal("onSceneDone")
