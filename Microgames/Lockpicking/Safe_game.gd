extends Sprite

signal completed
signal failed

func _process(delta):
	$game/Label.text = "Time remaining: " + format_time()

func _on_Safe_safe_opened():
	emit_signal("completed")
	$game/Timer.paused = true
	$game/CanvasModulate.color = Color.white
	$game/Path2D.hide()


func to_double_digits(number: int) -> String:
	return str(number) if number >= 10 else "0" + str(number)
	
func format_time():
	var seconds : int = $game/Timer.time_left
	var minutes : int = seconds / 60
	return to_double_digits(minutes) + " : " + to_double_digits(seconds % 60)
