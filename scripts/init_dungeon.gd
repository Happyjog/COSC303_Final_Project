extends Node2D

# Enums are typically Capitalized in GDScript
enum RoomType { START, BASIC, END, FIGHT }

class Room:
	func _init(type: RoomType, connections: Array, array: Array, entities: Array):
		self.type = type
		self.array = array
		self.connections = connections
		self.entities = entities

# Placeholder function for generating a room's inner layout/tilemap
func generate_room(room_type: RoomType, paths: Array) -> Array:
	var room_map = []
	
	#### Create some funtion to place gates in all directions where there is a path
	
	match room_type:
		RoomType.START: pass
		RoomType.BASIC: pass #just return room 
		RoomType.END: pass 
		RoomType.FIGHT: pass
		
	return []

func generate_path(room_type: RoomType) -> Array:
	
	return []

func generate_dungeon_matrix(rows: int, cols: int, room_map: Dictionary) -> Array:
	var dungeon = [] # Initialize the top-level array
	for r in range(rows):
		dungeon.append([]) # Initialize each row as an empty array 
		
		for c in range(cols):
			var room_type = room_map.get([r, c], RoomType.BASIC)
			var paths = generate_path(room_type)
			var room_data = Room.new(room_type, paths, generate_room(room_type, paths), [null])
			
			# Push the room into the current row
			dungeon[r].append(room_data)
			
	return dungeon

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	const room_map = { # Definition of the room layout, otherwise it is auto generated
		#row, col: room_type
		[2, 2]: RoomType.START,
		[0, 0]: RoomType.END,
		[0, 2]: RoomType.FIGHT,
		[4, 2]: RoomType.FIGHT
	}

	# Pass the matrix size dimensions here (e.g., 5 rows, 5 columns)
	var my_dungeon = generate_dungeon_matrix(5, 5, room_map)
	print("Dungeon generated successfully: ", my_dungeon.size(), " rows.")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
