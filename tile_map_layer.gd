extends TileMapLayer


func generate_room():
	position = Vector2(10.0, 1000.0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	generate_room()
	pass # Replace with function body.


# Called7 every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
