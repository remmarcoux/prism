extends Control

signal finished

export (AudioStream) var music
export (Resource) var dialog

onready var left_character := $Left
onready var right_character := $Right
onready var message_box := $Box

func _ready() -> void:
	if music :
		AudioManager.play_music(music, AudioManager.ELoopType.LoopLast)
	run_to_next_message()

func run_to_next_message() -> void:
	var event : String = dialog.current()
	if event.begins_with("#left:"):
		left_character.texture = load("res://" + event.substr(6))
		dialog.next()
		run_to_next_message()
	elif event.begins_with("#right:"):
		right_character.texture = load("res://" + event.substr(7))
		dialog.next()
		run_to_next_message()
	else:
		message_box.display_text(event)


func _on_Box_next_message_requested() -> void:
	if dialog.next():
		run_to_next_message()
	else:
		StorySystem._on_scene_done()
		emit_signal("finished")
