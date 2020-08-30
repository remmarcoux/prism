extends Node

export(Array, PackedScene) var gameList : Array

var index = 0

func _ready():
	load_game()

func load_game():
	for c in get_children():
		c.queue_free()
	var game : microgame = gameList[index].instance()
	game.connect("completed", self, "game_completed")
	add_child(game)
	index += 1

func game_completed():
	if index == gameList.size():
		pass #You win, yay!
	else:
		load_game()
