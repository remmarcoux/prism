extends Node2D

export(String, MULTILINE) var corporate_buzzwords : String;
export(String, MULTILINE) var vacation_buzzwords : String;
var corporate_array := []
var vacation_array := []

func _ready():
	randomize()
	corporate_array = corporate_buzzwords.split("\n")
	vacation_array = vacation_buzzwords.split("\n")
	
	corporate_array.shuffle()
	vacation_array.shuffle()
	
	if randi() % 2 :
		for i in 25:
			$Sheet/RichTextLabel.bbcode_text += corporate_array.pop_front() + " "
	else:
		for i in 25:
			$Sheet/RichTextLabel.bbcode_text += vacation_array.pop_front() + " "
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
