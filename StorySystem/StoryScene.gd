extends Node

var story_resource:StoryArc
var currentScene:Node

func _ready():
	_load_story_from_save()
	StorySystem.connect("onSceneDone", self, "_load_next_story_scene")

func _load_story_from_save():
	var stageData = Progress.getFirstIncompleteStage()
	_load_story(stageData.path)

func _load_story(story_path:String):
	story_resource = load(story_path)
	_load_current_story_scene()

func _load_next_story_scene():
	if story_resource._progressScenes():
		_load_current_story_scene()
	else:
		# Story arc is completed
		Progress.completeStage(story_resource.id)
		_load_story_from_save()

func _load_current_story_scene():
	_clear_current()
	currentScene = story_resource._getCurrentScene().instance()
	add_child(currentScene)

func _clear_current():
	if currentScene != null:
		currentScene.queue_free()
		currentScene = null
