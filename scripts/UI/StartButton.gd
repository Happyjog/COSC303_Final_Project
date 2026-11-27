extends Button

const mainScenePath = "res://main.tscn"

func _on_button_press():
	get_tree().change_scene_to_file(mainScenePath)
	pass
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(_on_button_press)
	pass # Replace with function body.
