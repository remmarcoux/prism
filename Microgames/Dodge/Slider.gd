extends KinematicBody2D

export (int) var speed := 200

enum ControlType {
	Keys,
	Mouse,
}
export(ControlType) var control_type := ControlType.Keys

var is_alive := false

func _process(delta: float) -> void:
	var move = Vector2.ZERO
	match control_type:
		ControlType.Keys:
			move = process_keys()
		ControlType.Mouse:
			move = process_mouse()
	if move and is_alive:
		move_and_slide(move.normalized() * speed)

func process_keys() -> Vector2:
	var move = Vector2()
	if Input.is_action_pressed("ui_up"):
		move.y -= 1
	if Input.is_action_pressed("ui_down"):
		move.y += 1
	if Input.is_action_pressed("ui_left"):
		move.x -= 1
	if Input.is_action_pressed("ui_right"):
		move.x += 1
	return move

func process_mouse() -> Vector2:
	var mouse = get_viewport().get_mouse_position()
	var move = mouse - position
	if move.length_squared() < 5:
		move = Vector2.ZERO
	return move
