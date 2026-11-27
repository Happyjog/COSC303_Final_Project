extends LineEdit

var regex
var old_text

func get_seed(): # return random seed if there is none, otherwise 
	if text == "":
		return randi()
	else:
		return text.to_int()
	pass


# make sure that the text box only receives numbers
func _ready(): 
	regex = RegEx.new()
	old_text = ""
	regex.compile("^[0-9]*$")
	text_changed.connect(_validate_text)

func _validate_text(new_text: String):
	if regex.search(new_text):
		old_text = new_text
	else:
		text = old_text
