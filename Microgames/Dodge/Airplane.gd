extends Area2D

export (float) var speed = 300
onready var direction = Vector2(cos(rotation), sin(rotation))

func _process(delta: float) -> void:
	position += delta * speed * direction


func _on_Timer_timeout() -> void:
	queue_free()
