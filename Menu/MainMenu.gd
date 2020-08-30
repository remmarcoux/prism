extends Control

export (PackedScene) var loadGameNodePath
export (PackedScene) var newGameNodePath

func _ready():
	if !Progress.isStageCompleted(1):
		$"ContentSafeZone/Menu buttons/Load".text = "Start Game"
		$"ContentSafeZone/Menu buttons/New".hide()

func _on_Load_pressed():
	get_tree().change_scene_to(loadGameNodePath)


func _on_New_pressed():
	get_tree().change_scene_to(newGameNodePath)


func _on_Quit_pressed():
	get_tree().quit()
