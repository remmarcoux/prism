extends Node

export (AudioStream) var music
export(Array, PackedScene) var gameList : Array

var index = 0

func _ready():
	AudioManager.play_music(music, AudioManager.ELoopType.LoopLast)
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
		AudioManager.play_sfx("res://Audio/SFX/minigame-WIN_01.wav")
		StorySystem._on_scene_done()
	else:
		AudioManager.play_sfx("res://Audio/SFX/minigame_halfwin.wav")
		load_game()
