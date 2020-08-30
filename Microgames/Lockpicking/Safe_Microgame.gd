extends "res://Microgames/Microgame.gd"

func _ready():
	$GameContainer/Safe_game.set_process(false)


func _on_Safe_game_completed():
	emit_signal("completed")
