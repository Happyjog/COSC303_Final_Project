extends TileMapLayer

@export var source_id: int = 1

const TILE_COORDS = {
	"OUTSIDE": Vector2i(8,7),
	"WALL": {
		"TOP_LEFT": [Vector2i(0, 0)],
		"TOP_RIGHT": [Vector2i(5, 0)],
		"BOTTOM_LEFT": [Vector2i(0, 4)],
		"BOTTOM_RIGHT": [Vector2i(5, 4)],
		"TOP": [
			Vector2i(1, 0),
			Vector2i(2, 0),
			Vector2i(3, 0),
			Vector2i(4, 0)
		],
		"BOTTOM": [
			Vector2i(1, 4),
			Vector2i(2, 4),
			Vector2i(3, 4),
			Vector2i(4, 4)
		],
		"WALL_LEFT": [
			Vector2i(0, 1),
			Vector2i(0, 2),
			Vector2i(0, 3)
		],
		"WALL_RIGHT": [
			Vector2i(5, 1),
			Vector2i(5, 2),
			Vector2i(5, 3)
		]
	},
	"FLOOR": {
		"TILE": [
			Vector2i(6,0),
			Vector2i(7,0),
			Vector2i(8,0),
			Vector2i(9,0),
			Vector2i(6,1),
			Vector2i(7,1),
			Vector2i(8,1),
			Vector2i(9,1),
			Vector2i(6,2),
			Vector2i(7,2),
			Vector2i(8,2),
			Vector2i(9,2)
		],
		"TOP_LEFT": [Vector2i(1,1)],
		"TOP_RIGHT": [Vector2i(4,1)],
		"BOTTOM_LEFT": [Vector2i(1,3)],
		"BOTTOM_RIGHT": [Vector2i(4,3)],
		"TOP": [Vector2i(2,1), Vector2i(3,1)],
		"BOTTOM": [Vector2i(2,3), Vector2i(3,3)],
		"LEFT": [Vector2i(1,2)],
		"RIGHT": [Vector2i(4,2)]
	}
}

# Returns a random atlas coordinate from an array
func get_random_tile_coord(coords: Array, rng: RandomNumberGenerator) -> Vector2i:
	return coords[rng.randi_range(0, coords.size() - 1)]

# Converts an integer tile type into its atlas coordinate
func get_tile_coord(tile_type: int, rng: RandomNumberGenerator) -> Vector2i:
	# FLOOR TILES: 0-8
	match tile_type:
		0: return TILE_COORDS["OUTSIDE"]
		1: return get_random_tile_coord(TILE_COORDS["FLOOR"]["TILE"], rng)
		2: return get_random_tile_coord(TILE_COORDS["FLOOR"]["TOP"], rng)
		3: return get_random_tile_coord(TILE_COORDS["FLOOR"]["BOTTOM"], rng)
		4: return TILE_COORDS["FLOOR"]["LEFT"][0]
		5: return TILE_COORDS["FLOOR"]["RIGHT"][0]
		6: return TILE_COORDS["FLOOR"]["TOP_LEFT"][0]
		7: return TILE_COORDS["FLOOR"]["TOP_RIGHT"][0]
		8: return TILE_COORDS["FLOOR"]["BOTTOM_LEFT"][0]
		9: return TILE_COORDS["FLOOR"]["BOTTOM_RIGHT"][0]
		10: return get_random_tile_coord(TILE_COORDS["WALL"]["TOP"], rng)
		11: return get_random_tile_coord(TILE_COORDS["WALL"]["BOTTOM"], rng)
		12: return get_random_tile_coord(TILE_COORDS["WALL"]["WALL_LEFT"], rng)
		13: return get_random_tile_coord(TILE_COORDS["WALL"]["WALL_RIGHT"], rng)
		14: return TILE_COORDS["WALL"]["TOP_LEFT"][0]
		15: return TILE_COORDS["WALL"]["TOP_RIGHT"][0]
		16: return TILE_COORDS["WALL"]["BOTTOM_LEFT"][0]
		17: return TILE_COORDS["WALL"]["BOTTOM_RIGHT"][0]

		
		

	push_error("Invalid room tile type: " + str(tile_type))
	return TILE_COORDS["OUTSIDE"]

# Generates a room from an NxM integer matrix.
func generate_room(layout: Array, origin: Vector2i, rng: RandomNumberGenerator):
	#check that the matrix isn't empty.
	if layout.is_empty():
		push_error("Room layout cannot be empty.")
		return

	# Get matrix dimensions.
	var height = layout.size()

	if not layout[0] is Array:
		push_error("Room layout must contain arrays.")
		return

	var width = layout[0].size()

	if width == 0:
		push_error("Room layout cannot have empty rows.")
		return

	# Check that every row has the same width.
	for row in layout:
		if not row is Array or row.size() != width:
			push_error("All rows must have the same number of columns.")
			return

	#validate tile values before clearing the existing map.
	for row in layout:
		for tile_type in row:
			if tile_type < 0 or tile_type > 17:
				push_error("Invalid room tile type: " + str(tile_type))
				return

	clear()

	# Generate each tile.
	for y in range(height):
		for x in range(width):
			var tile_type: int = layout[y][x]
			var atlas_coord = get_tile_coord(tile_type, rng)
			set_cell(
				origin + Vector2i(x, y),
				source_id,
				atlas_coord
			)

	print("Generated room: ", width, " x ", height)		

#runs the first time tile map layer shows up
func _ready():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	var array = [
		[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
		[14,10,10,10,10,10,10,10,10,10,10,10,10,10,10,15],
		[12,6,2,2,2,2,2,2,2,2,2,2,2,2,7,13],
		[12,4,1,1,1,1,1,1,1,1,1,1,1,1,5,13],
		[12,4,1,1,1,1,1,1,1,1,1,1,1,1,5,13],
		[12,4,1,1,1,1,1,1,1,1,1,1,1,1,5,13],
		[12,4,1,1,1,1,1,1,1,1,1,1,1,1,5,13],
		[12,8,3,3,3,3,3,3,3,3,3,3,3,3,9,13],
		[16,11,11,11,11,11,11,11,11,11,11,11,11,11,11,17]
	]
	
	generate_room(array, Vector2i(-8, -5), rng)
	$RoomObjects.generate_objects(array, Vector2i(-8, -5), rng)
	
	pass
	
