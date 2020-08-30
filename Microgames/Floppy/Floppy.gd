extends Node2D

signal game_lost
signal game_won

const Obstacle = preload("res://Microgames/Floppy/Obstacle.tscn")

export (float) var fly_strength := 250.0
export (float) var gravity := 300.0

var player_speed := 0.0

onready var player = $Player
onready var animator = $AnimationPlayer
onready var container = $ObstacleContainer

func _ready() -> void:
	if not owner:
		position = Vector2(512, 300)
		_start()

func _start() -> void:
	player.position = Vector2(0, 0)
	player_speed = 0.0
	randomize()
	for obstacle in container.get_children():
		obstacle.position.y = 200 * (randf() - 0.5)
	animator.play("slide_obstacles")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		player_speed = -fly_strength
	player.position.y += player_speed * delta
	player_speed += min(gravity * delta, 300)
	# out of bounds means death
	if abs(player.position.y) > 360:
		obstacle_hit(null)

func obstacle_hit(_whoelse) -> void:
	print("ouch")
	animator.stop()
	_start()

func obstacles_cleared(_anim) -> void:
	emit_signal("game_won")
