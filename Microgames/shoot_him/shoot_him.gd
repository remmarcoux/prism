extends Node2D

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		stop_all()
		shoot()

func stop_all():
	$cartridge/AnimationPlayer2.stop()
	$printer/AnimationPlayer.stop()
	$toner/AnimationPlayer2.stop()

func shoot():
	play_gunshot()
	var target = $printer/RayCast2D.get_collider()
	if target:
		$printer/RayCast2D/Line2D.show()
		if target == $toner/Area2D:
			win()
		elif target == $cartridge/Area2D:
			lose()
	pass

func win():
	print("You win!!!")
	pass

func lose():
	print("Oh no!")
	pass

func play_gunshot():
	$AudioStreamPlayer.play()
