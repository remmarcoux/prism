extends Control

export (AudioStream) var introMenuMusic
export (AudioStream) var mainMenuMusic
export (AudioManager.ELoopType) var music_loop_method
export (Resource) var storyScene

func _ready():
	AudioManager.play_music([introMenuMusic, mainMenuMusic], music_loop_method)
	if !Progress.isStageCompleted(1) && false :
		$"ContentSafeZone/Menu buttons/Load".text = "Start Game"
		$"ContentSafeZone/Menu buttons/New".hide()

func _on_Load_pressed():
	get_tree().change_scene_to(storyScene)

func _on_New_pressed():
	$ContentSafeZone/DeleteSavePopup.show_modal()

func _on_Quit_pressed():
	get_tree().quit()

func _on_DeleteSavePopup_confirmed():
	Progress.resetGame()
	get_tree().change_scene_to(storyScene)
