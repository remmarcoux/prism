extends Resource
class_name StoryArc

export (int) var id:int
export (Array) var StoryScenes:Array

var index:int

func _getCurrentScene() -> PackedScene:
	if index < StoryScenes.size():
		return StoryScenes[index]
	return null

# returns true when a next scene is found in this story arc
func _progressScenes() -> bool:
	index += 1
	if index < StoryScenes.size():
		return true
	return false
