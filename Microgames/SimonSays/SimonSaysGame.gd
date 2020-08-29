extends Node2D

enum ESimonsaysGameState {
	PreGame,
	SimonTurn,
	PlayerTurn,
	WrongAnswer,
	Win,
	Loose,
}

onready var displayNodes : Array = [$Up, $Left, $Down, $Right]

var animTimer : float = 0.25

var roundState : int

var roundSolution : Array
var roundDisplayTimer : float
var roundInputTimer : float
var roundPauseTimer : float = 0.1

var currentIndex : int
var currentTimer : float
var currentPauseTimer : float
var currentAnswer : Array

func _ready():
	reset_minigame()
	start_simon_says_round(GenerateSolution(6), 0.5, 10.0)

func _process(delta:float):
	match roundState:
		ESimonsaysGameState.PreGame : return
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
	roundState = ESimonsaysGameState.SimonTurn
	roundDisplayTimer = displayTime
	roundInputTimer = playerReactionTime
	roundSolution = solution
	set_highlight(roundSolution[currentIndex])

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
	
	if currentAnswer.size() == roundSolution.size():
		roundState = ESimonsaysGameState.Win
	else:
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

func on_wrong_answer():
	# TODO: Negative Feedback
	currentAnswer.clear()
	currentPauseTimer = roundPauseTimer
	setup_current_round()
	roundState = ESimonsaysGameState.WrongAnswer

func on_correct_answer():
	# TODO: Positive Feedback
	pass

func update_display_from_inputs():
	set_highlight(process_key_down())
	

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
