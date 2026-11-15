extends Node2D

enum RoomType { START, BASIC, END, FIGHT }
enum Direction { NORTH, EAST, SOUTH, WEST }

const EXTRA_CONNECTION_CHANCE = 0.15
const ROOM_WIDTH = 16
const ROOM_HEIGHT = 12
const ROOM_ORIGIN = Vector2i(-8, -6)


class Room:
	var type: int
	var array: Array
	var connections: Array
	var entities: Array

	func _init(p_type: int):
		type = p_type
		array = []
		connections = []
		entities = []


#Helpers for directions
func get_neighbor_offset(direction: int) -> Vector2i:
	match direction:
		Direction.NORTH: return Vector2i(-1, 0)
		Direction.EAST: return Vector2i(0, 1)
		Direction.SOUTH: return Vector2i(1, 0)
		Direction.WEST: return Vector2i(0, -1)

	return Vector2i.ZERO

func get_opposite_direction(direction: int) -> int:
	match direction:
		Direction.NORTH: return Direction.SOUTH
		Direction.EAST: return Direction.WEST
		Direction.SOUTH: return Direction.NORTH
		Direction.WEST: return Direction.EAST
		
	return -1

func connect_rooms(room_a: Room, room_b: Room, direction: int) -> void:
	var opposite = get_opposite_direction(direction)

	if not room_a.connections.has(direction):
		room_a.connections.append(direction)

	if not room_b.connections.has(opposite):
		room_b.connections.append(opposite)


func generate_room(room_type: int, paths: Array) -> Array:

	# Most basic 16 x 12 room layout
	var room_map = [
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		[14, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 15],
		[12, 6, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 7, 13],
		[12, 4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 5, 13],
		[12, 4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 5, 13],
		[12, 4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 5, 13],
		[12, 4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 5, 13],
		[12, 4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 5, 13],
		[12, 4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 5, 13],
		[12, 4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 5, 13],
		[12, 8, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 9, 13],
		[16, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 17]
	]

	#Add doorways based on room connections
	for direction in paths:
		match direction:
			Direction.NORTH:
				room_map[1][7] = 1
				room_map[1][7] = 1
				
				room_map[2][7] = 19
				room_map[2][8] = 4
				room_map[0][7] = 5
				room_map[0][8] = 18

			Direction.EAST:
				room_map[5][14] = 1
				room_map[6][14] = 1
				
				room_map[4][15] = 21
				room_map[5][15] = 2
				room_map[6][15] = 3
				room_map[7][15] = 20

			Direction.SOUTH:
				room_map[10][7] = 1
				room_map[10][8] = 1
				
				room_map[11][6] = 18
				room_map[11][7] = 4
				room_map[11][8] = 5
				room_map[11][9] = 20

			Direction.WEST:
				room_map[5][1] = 1
				room_map[6][1] = 1

				room_map[4][0] = 20
				room_map[5][0] = 2
				room_map[6][0] = 3
				room_map[7][0] = 18

	# Room-specific modifications could go here
	match room_type:
		RoomType.START:
			pass
		RoomType.BASIC:
			pass
		RoomType.END:
			pass
		RoomType.FIGHT:
			pass

	return room_map


func generate_paths(dungeon: Array, rows: int, cols: int) -> void:

	var visited = {}
	var stack: Array[Vector2i] = []

	var start = Vector2i(0, 0)

	for r in range(rows):
		for c in range(cols):
			if dungeon[r][c].type == RoomType.START:
				start = Vector2i(r, c)

	visited[start] = true
	stack.append(start)

	# Randomized depth-first search
	while not stack.is_empty():
		var current = stack[-1]
		var options = []

		for direction in range(4):

			var neighbor = current + get_neighbor_offset(direction)

			if neighbor.x < 0 or neighbor.x >= rows:
				continue

			if neighbor.y < 0 or neighbor.y >= cols:
				continue

			if not visited.has(neighbor):
				options.append({
					"position": neighbor,
					"direction": direction
				})

		if options.is_empty():
			stack.pop_back()
			continue

		var choice = options.pick_random()

		var next_position: Vector2i = choice["position"]
		var direction: int = choice["direction"]

		connect_rooms(
			dungeon[current.x][current.y],
			dungeon[next_position.x][next_position.y],
			direction
		)

		visited[next_position] = true
		stack.append(next_position)

	# Add optional connections
	for r in range(rows):
		for c in range(cols):
			var current_room = dungeon[r][c]
			if c + 1 < cols:
				if not current_room.connections.has(Direction.EAST):
					if randf() < EXTRA_CONNECTION_CHANCE:
						connect_rooms(
							current_room,
							dungeon[r][c + 1],
							Direction.EAST
						)

			if r + 1 < rows:
				if not current_room.connections.has(Direction.SOUTH):
					if randf() < EXTRA_CONNECTION_CHANCE:
						connect_rooms(
							current_room,
							dungeon[r + 1][c],
							Direction.SOUTH
						)


func generate_dungeon_matrix(rows: int, cols: int, room_map: Dictionary) -> Array:

	var dungeon = []

	# Create rooms
	for r in range(rows):
		var row = []
		for c in range(cols):

			var room_type = room_map.get(
				Vector2i(r, c),
				RoomType.BASIC
			)

			row.append(Room.new(room_type))

		dungeon.append(row)

	# Generate connections
	generate_paths(dungeon, rows, cols)

	# Generate room arrays
	for r in range(rows):
		for c in range(cols):

			var room = dungeon[r][c]

			room.array = generate_room(
				room.type,
				room.connections
			)

	return dungeon


func render_dungeon(dungeon: Array, rng: RandomNumberGenerator) -> void:
	# Clear both layers ONCE
	$Room.clear()
	$Room/RoomObjects.clear()

	for r in range(dungeon.size()):
		for c in range(dungeon[r].size()):

			var room = dungeon[r][c]

			var origin = ROOM_ORIGIN + Vector2i(
				c * ROOM_WIDTH,
				r * ROOM_HEIGHT
			)

			# Render room tiles
			$Room.generate_room(
				room.array,
				origin,
				rng
			)

			# Generate room objects
			$Room/RoomObjects.generate_objects(
				room.array,
				origin,
				rng
			)


# --------------------------------------------------
# TESTING
# --------------------------------------------------

func _ready() -> void:

	var rng = RandomNumberGenerator.new()
	rng.randomize()

	var room_map = {
		Vector2i(2, 2): RoomType.START,
		Vector2i(0, 0): RoomType.END,
		Vector2i(0, 2): RoomType.FIGHT,
		Vector2i(4, 2): RoomType.FIGHT
	}

	var my_dungeon = generate_dungeon_matrix(5, 5, room_map)

	render_dungeon(my_dungeon, rng)

	print("Dungeon generated successfully!")

	for r in range(my_dungeon.size()):
		for c in range(my_dungeon[r].size()):

			var room = my_dungeon[r][c]

			print(
				"Room [", r, ", ", c, "] ",
				"Type: ", room.type,
				" Connections: ", room.connections
			)
