extends Node2D

signal completed
signal failed


enum ERunawayButton {
	Left,
	Right,
}

export (float) var timeLimit:float = 5
export (float) var targetProgress:float = 100
export (float) var progressPerInputs:float = 5
export (bool) var startsActive = false

var timer:float = 0
var lastInput:int = -1
var progress: float = 0

var isActive: bool = true

func _ready():
	$ExplosionTimer.max_value = timeLimit
	$EscapeProgress.max_value = targetProgress
	isActive = startsActive

func _start():
	isActive = true


func _process(delta: float):
	_update_visuals()
	if !isActive:
		return
	if _check_win_condition() || _check_loose_condition():
		isActive = false
		
	_process_gameplay(delta)
	
func _update_visuals():
	$Left.animation = "active" if lastInput == 0 || !isActive else "default"
	$Right.animation = "active" if lastInput == 1 || !isActive else "default"
	$ExplosionTimer.value = timeLimit - timer
	$EscapeProgress.value = progress

func _check_loose_condition() -> bool:
	if timer > timeLimit :
		print_debug("You Loose...")
		emit_signal("failed")
		return true
	return false

func _check_win_condition() -> bool:
	if progress >= targetProgress:
		print_debug("You Win!")
		emit_signal("completed")
		return true
	return false

func _process_gameplay(delta: float):
	timer += delta
	var key = process_key_presses()
	if (key == 0 && lastInput != 0) || (key == 1 && lastInput != 1) :
		lastInput = key
		progress += progressPerInputs

func process_key_presses() -> int:
	if Input.is_action_just_pressed("ui_left"):
		return 0
	if Input.is_action_just_pressed("ui_right"):
		return 1
	return -1
	
