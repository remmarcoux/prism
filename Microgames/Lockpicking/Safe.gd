extends Node2D

signal safe_opened

onready var handle = $Handle
onready var knob = $Knob
export(float) var speed := 80.0
export(float) var pin_range := 8.0

var combination = []
var current_unlocked = 0
var unlocked := false

func _ready():
	create_combination()

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		reset_safe()
	if not unlocked:
		if Input.is_action_pressed("ui_right"):
			knob.rotation_degrees += delta * speed
		elif Input.is_action_pressed("ui_left"):
			knob.rotation_degrees -= delta * speed
		check_for_pin()
	
func check_for_pin() -> void:
	if not unlocked:
		var distance_to_pin = abs(knob.rotation_degrees - combination[current_unlocked])
		if distance_to_pin < pin_range:
			print("Click on !" + str(current_unlocked))
			$AudioStreamPlayer.stream = load("res://Microgames/Lockpicking/click_cadena_01.wav")
			$AudioStreamPlayer.play()
			current_unlocked += 1
			if current_unlocked == combination.size():
				unlocked = true
				$AudioStreamPlayer.stream = load("res://Microgames/Lockpicking/metal_drum_impact_thud_06.wav")
				$AudioStreamPlayer.play()
				print("Unlocked!")
				open_safe()
		elif current_unlocked > 0:
			if is_pass_treshold():
				is_pass_treshold()
				print("Ahah fuck you!")
				current_unlocked = 0
				close_safe()

func is_pass_treshold():
	var power = pow(-1, current_unlocked-1)
	var A = power * knob.rotation_degrees
	var T = power * (combination[current_unlocked-1] + (power * pin_range))
	return A > T

func open_safe():
	handle.rotation_degrees = -90
	emit_signal("safe_opened")

func close_safe():
	handle.rotation_degrees = 0

func reset_safe():
	$Tween. remove_all()
	$Tween.interpolate_property(knob, "rotation_degrees", knob.rotation_degrees, 0, 2, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$Tween.start()
	set_process(false)

func create_combination():
	randomize()
	combination.clear()
	combination.append(rand_range(20,350))
	combination.append(combination[0] - rand_range(20,350))
	combination.append(combination[1] + rand_range(20, combination[0]-combination[1]))
	print(combination)

func _on_Tween_tween_all_completed():
	current_unlocked = 0
	set_process(true)
