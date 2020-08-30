extends Node2D

const Airplane = preload("res://Microgames/Dodge/Airplane.tscn")

signal game_lost
signal game_won

export (float) var spawn_distance := 250.0
export (bool) var retry_on_death := true

onready var container = $PlaneContainer
onready var animator = $AnimationPlayer
onready var player = $Player
onready var center = Vector2(0, 0) if owner else Vector2(512, 300)

func _ready() -> void:
	if not owner:
		_start()

func _start() -> void:
	randomize()
	reset_game()

func spawn_airplane() -> void:
	var theta = TAU * randf()
	var plane = Airplane.instance()
	plane.position = player.position + spawn_distance * Vector2(cos(theta), sin(theta))
	plane.rotation = theta + PI
	plane.connect("body_entered", self, "player_hit")
	container.add_child(plane)

func player_hit(_whoelse) -> void:
	player.is_alive = false
	animator.play("death")
	for plane in container.get_children():
		plane.queue_free()

func reset_game() -> void:
	player.modulate = Color(1, 1, 1, 1)
	player.position = center
	player.is_alive = true
	animator.play("airplanes")

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	match anim_name:
		"airplanes":
			emit_signal("game_won")
		"death":
			if retry_on_death:
				reset_game()
			else:
				emit_signal("game_lost")
