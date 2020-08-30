extends Node

# Declare member variables here
var initFile = "res://system/progress_init.json"
var usrFile = "user://data/progress.json"
var invFile = "user://data/inventory.json"

var inventory = []
var data = []

# Called when the node enters the scene tree for the first time.
func _ready():
	_load_game()

# Load game progression or setup the new one
func _load_game():
	var file = File.new()
	var inv = File.new()
	
	if not (file.file_exists(usrFile) and inv.file_exists(invFile)):
		var dir = Directory.new()
		dir.open("user://")
		if not dir.dir_exists("data"):
			dir.make_dir("data")
		
		resetGame()
		return
	else:
		file.open(usrFile, File.READ)
		inv.open(invFile, File.READ)
	
	data = parse_json(file.get_as_text())
	file.close()
	inventory = parse_json(inv.get_as_text())
	inv.close()

# Save the game on the client
func _save():
	var file = File.new()
	var inv = File.new()
	
	file.open(usrFile, File.WRITE)
	file.store_line(to_json(data))
	file.close()
	
	inv.open(invFile, File.WRITE)
	inv.store_line(to_json(inventory))
	inv.close()

# Re-initialise to default value (start again mofo)
func resetGame():
	inventory = []
	
	var file = File.new()
	file.open(initFile, File.READ)
	data = parse_json(file.get_as_text())
	file.close()
	
	_save()

# Tell which stage you just complete
func completeStage(stageID):
	for i in range(data.size()):
		if stageID == data[i].id:
			data[i].isCompleted = true
			_save()
			return

func isStageCompleted(stageID) -> bool:
	if !(data is Array) :
		return false
	for i in range(data.size()):
		if stageID == data[i].id:
			return data[i].isCompleted
	return false

func getFirstIncompleteStage() -> Dictionary:
	for i in range(data.size()):
		if !data[i].isCompleted:
			return data[i]
	print_debug("No incomplete node found... Returning first node")
	return data[0]

# Check if you have "x" item in your inventory, can be an array
func hasItems(items):
	if typeof(items) == TYPE_STRING: items = [items]
	
	for item in items:
		if not inventory.has(item): return false
	
	return true

# Add a new item to the inventory. Sucks if you already have it
func addToInventory(item):
	if inventory.find(item) != -1: return
	inventory.push_back(item)
	_save()

# Remove an existing item from the inventory
func removeFromInventory(item):
	var i = inventory.find(item)
	if i == -1 : return
	inventory.remove(i)
	_save()
