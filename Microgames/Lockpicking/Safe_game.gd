extends Sprite

signal completed
signal failed

func _start():
	set_process(true)
	$Timer.start()

func _process(delta):
	$Label.text = "Time remaining: " + format_time()

func _on_Safe_safe_opened():
	$Timer.paused = true
	$CanvasModulate.color = Color.white
	$Path2D.hide()
	$EndTimer.start()

func to_double_digits(number: int) -> String:
	return str(number) if number >= 10 else "0" + str(number)

func format_time():
	var seconds : int = $Timer.time_left
	var minutes : int = seconds / 60
	return to_double_digits(minutes) + " : " + to_double_digits(seconds % 60)


func _on_EndTimer_timeout():
	emit_signal("completed")


func _on_Safe_click(index):
	$CanvasLayer.get_node("Click"+str(index)).show()
	$CanvasLayer/Timer.start()


func _on_Timer_timeout():
	for c in $CanvasLayer.get_children():
		if c is Label:
			c.hide()
