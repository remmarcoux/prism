extends Node2D

enum ERunawayButton {
	Left,
	Right,
}

export (float) var timeLimit:float = 5
export (float) var targetProgress:float = 100
export (float) var progressPerInputs:float = 1

var timer:float = 0
var lastInput:int = -1

func _ready():
	pass

func _process(delta: float):
	pass

