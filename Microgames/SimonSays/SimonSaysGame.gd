extends Node2D

signal completed
signal failed

enum ESimonsaysGameState {
	PreGame,
	SimonTurn,
	PlayerTurn,
	WrongAnswer,
	Win,
	Loose,
}

export (int) var numberOfSteps : int
export (float) var playerReactionTimeLimit : float
export (float) var roundPauseTimer : float = 0.1
export (float) var displayTime : float = 0.5

export (float) var animTimer : float = 0.25

onready var displayNodes : Array = [$Up, $Left, $Down, $Right]

var roundState : int

var roundSolution : Array
var roundDisplayTimer : float
var roundInputTimer : float

var masterTimer : float

var currentIndex : int
var currentTimer : float
var currentPauseTimer : float
var currentAnswer : Array

func _ready():
	reset_minigame()

func _start():
	start_simon_says_round(GenerateSolution(numberOfSteps), displayTime, playerReactionTimeLimit)

func _process(delta:float):
	$Timer.text = format_time()
	match roundState:
		ESimonsaysGameState.PreGame : process_pregame(delta)
		ESimonsaysGameState.SimonTurn: process_simon_round(delta)
		ESimonsaysGameState.PlayerTurn: process_player_round(delta)
		ESimonsaysGameState.WrongAnswer: process_wrong_answer(delta)
		ESimonsaysGameState.Win: process_win(delta)
		ESimonsaysGameState.Loose: process_loose(delta)

func GenerateSolution(size:int) -> Array:
	randomize()
	var solution = [];
	for i in range(size):
		solution.append(randi()%4)
	return solution

func reset_minigame():
	roundState = ESimonsaysGameState.PreGame
	roundDisplayTimer = 0.0
	roundInputTimer = 0.0
	roundSolution = []
	setup_current_round()

func setup_current_round() :
	currentTimer = 0.0
	currentIndex = 0
	currentPauseTimer = roundPauseTimer
	currentAnswer = []

func start_simon_says_round(solution : Array, displayTime : float, playerReactionTime : float):
	currentIndex = 0
	roundState = ESimonsaysGameState.SimonTurn
	roundDisplayTimer = displayTime
	roundInputTimer = playerReactionTime
	roundSolution = solution
	masterTimer = roundInputTimer
	set_highlight(roundSolution[currentIndex])

func process_pregame(delta:float):
	if Input.is_action_pressed("ui_select"):
		_start()

func process_simon_round(delta:float):
	if currentTimer == 0.0 && currentPauseTimer == roundPauseTimer :
		set_highlight(-1)

	if currentPauseTimer > 0.0 :
		currentPauseTimer -= delta
		return
		
	if currentTimer == 0.0 :
		set_highlight(roundSolution[currentIndex])

	currentTimer += delta
	if currentTimer >= roundDisplayTimer:
		currentIndex += 1
		currentTimer = 0.0
		currentPauseTimer = roundPauseTimer
		
		if currentIndex >= roundSolution.size() :
			roundState = ESimonsaysGameState.PlayerTurn
			set_highlight(-1)
			return

func process_player_round(delta:float):
	if currentPauseTimer > 0:
		currentPauseTimer -= delta
		return
		
	currentTimer += delta
	masterTimer -= delta
	if masterTimer < 0:
		on_loose()
		return
	
	if currentTimer >= roundInputTimer:
		on_wrong_answer()
		return
	
	update_display_from_inputs()

	var lastPress = process_key_presses()		
	if lastPress == -1:
		return
	
	currentAnswer.append(lastPress)
	
	for i in range(currentAnswer.size()):
		if currentAnswer[i] != roundSolution[i]:
			on_wrong_answer()
			return
	
	on_correct_answer()

func process_wrong_answer(delta:float):
	currentPauseTimer -= delta
	if currentPauseTimer < 0 :
		roundState = ESimonsaysGameState.SimonTurn

func process_win(delta:float):
	currentTimer += delta
	if currentTimer >= animTimer:
		currentTimer = 0.0
		currentIndex += 1
		if currentIndex >= displayNodes.size():
			currentIndex = 0
		set_highlight(currentIndex)

func process_loose(delta:float):
	pass


func on_win():
	emit_signal("completed")

func on_loose():
	emit_signal("failed")
	$Timer.hide()
	roundState = ESimonsaysGameState.Loose

func on_wrong_answer():
	# TODO: Negative Feedback
	currentAnswer.clear()
	currentPauseTimer = roundPauseTimer
	setup_current_round()
	roundState = ESimonsaysGameState.WrongAnswer

func on_correct_answer():
	# TODO: Positive Feedback
	if currentAnswer.size() == roundSolution.size():
		roundState = ESimonsaysGameState.Win
		emit_signal("completed")

func update_display_from_inputs():
	set_highlight(process_key_down())

func to_double_digits(number: int) -> String:
	return str(number) if number >= 10 else "0" + str(number)

func format_time():
	var seconds : int = masterTimer
	var minutes : int = seconds / 60
	return to_double_digits(minutes) + " : " + to_double_digits(seconds % 60)

func set_highlight(index:int):
		var i:int = 0
		for node in displayNodes :
			node.animation = "default" if i != index else "active"
			i += 1

func process_key_presses() -> int:
	if Input.is_action_just_pressed("ui_up"):
		return 0
	if Input.is_action_just_pressed("ui_left"):
		return 1
	if Input.is_action_just_pressed("ui_down"):
		return 2
	if Input.is_action_just_pressed("ui_right"):
		return 3
	return -1

func process_key_down() -> int:
	if Input.is_action_pressed("ui_up"):
		return 0
	if Input.is_action_pressed("ui_left"):
		return 1
	if Input.is_action_pressed("ui_down"):
		return 2
	if Input.is_action_pressed("ui_right"):
		return 3
	return -1
