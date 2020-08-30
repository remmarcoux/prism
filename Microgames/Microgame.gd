extends Node
class_name microgame

signal completed
signal failed

export var game_title : String
export var game_rules : String

func _ready():
	$Control/VBoxContainer/Title.parse_bbcode("[center]" + game_title)
	$Control/VBoxContainer/Description.parse_bbcode("[center]" + game_rules)

func start():
	propagate_call("_start")
	pass

func complete_game() -> void:
	emit_signal("completed")

func fail_game() -> void:
	emit_signal("failed")
