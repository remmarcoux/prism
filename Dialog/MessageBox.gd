extends Control

signal next_message_requested

export (float) var text_speed := 25.0

onready var label = $Text
onready var animator = $AnimationPlayer

func display_text(text: String) -> void:
	if text.empty():
		label.clear()
		animator.stop()
		return
	label.parse_bbcode(text)
	label.scroll_to_line(0) # workaround for bad caching in get_total_character_count
	var spd = text_speed / label.get_total_character_count()
	label.percent_visible = 0.0
	animator.play("write", -1, spd)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if animator.is_playing():
			animator.stop()
			label.percent_visible = 1.0
		else:
			emit_signal("next_message_requested")
