class_name Dialog
extends Resource

export (Array, String, MULTILINE) var events = []

var current_event = 0

func load_file(path: String) -> void:
	var file = File.new()
	file.open(path, File.READ)
	while not file.eof_reached():
		var line = file.get_line()
		if line:
			events.push_back(line)

func is_finished() -> bool:
	return current_event >= events.size()

func current() -> String:
	if not is_finished():
		return events[current_event]
	return ""

func next() -> bool:
	current_event += 1
	return not is_finished()
