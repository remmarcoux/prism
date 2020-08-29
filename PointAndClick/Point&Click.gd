extends Node2D

onready var objects = [
	$External,
	$Internal,
]

func _on_object_input_event(_viewport: Node, event: InputEvent, _shape_idx: int, object_id: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		print("object %d selected" % object_id)
