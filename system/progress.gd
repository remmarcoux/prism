extends Node

# Declare member variables here
var  initFile = "res://system/progress.json"
var usrFile = "user://data/progress.json"
var data = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	load_game()

# Load game progression or setup the new one
func load_game():
	var file = File.new()
	if not file.file_exists(usrFile):
		file.open(initFile, File.READ)
	else:
		file.open(usrFile, File.READ)
	
	data = parse_json(file.get_as_text())
	file.close()
	

# Save the game on the client
func save():
	var file = File.new()
	file.open(usrFile, File.WRITE)
	file.store_line(to_json(data))
	file.close()

# Re-initialise to default value (start again mofo)
func resetGame():
	var file = File.new()
	file = file.open(initFile, File.READ)
	data = parse_json(file.get_as_text())
	file.close()
	save()

func completeStage(stageID):
	for i in data:
		if stageID == data[i].id:
			data[i].isCompleted = true
			return
