extends ColorRect

export(String, MULTILINE) var corporate_buzzwords : String;
export(String, MULTILINE) var vacation_buzzwords : String;
export(String, MULTILINE) var words : String
var email_type

func _ready():
	randomize()
	var wordsArray : Array = words.split("\n")
	var corporate_array: Array = corporate_buzzwords.split("\n")
	var vacation_array: Array = vacation_buzzwords.split("\n")
	corporate_array.shuffle()
	vacation_array.shuffle()
	wordsArray.shuffle()
	
	$HBoxContainer/HBoxContainer/Subject.text += wordsArray[0] + " " + wordsArray[1]
	
	if randi() % 2 :
		for i in 25:
			email_type = "Corporate"
			$HBoxContainer/EmailContent.append_bbcode(corporate_array.pop_front() + " ")
	else:
		for i in 25:
			email_type = "Vacation"
			$HBoxContainer/EmailContent.append_bbcode(vacation_array.pop_front() + " ")
