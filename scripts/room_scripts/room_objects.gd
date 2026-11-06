extends TileMapLayer

@export var source_id: int = 0

# Atlas coordinates for items
const TEXTURE_TILES = {
	"FLOOR": [
		Vector2i(8,6),
		Vector2i(7, 7),
		Vector2i(9,5),
		Vector2i(9,4),
		Vector2i(5,8)
	],
	"TOP_WALL": [
		Vector2i(0,9),
		Vector2i(2,9)
	],
	"LEFT_FLOOR": [
		Vector2i(1,9)
	],
	"TOP_LEFT_FLOOR": [
		Vector2i(4,6)
	]
}


func generate_objects(layout: Array, origin: Vector2i, rng: RandomNumberGenerator):
	clear()

	var height = layout.size()
	var width = layout[0].size()

	for y in range(height):
		for x in range(width):
			# Only consider floor tiles
			if rng.randf() < 0.06: # 4% chance to spawn an object
				var item = null
				if layout[y][x] == 1: # floor
					item = TEXTURE_TILES["FLOOR"][
						rng.randi_range(0, TEXTURE_TILES["FLOOR"].size() - 1)
					]
				elif layout[y][x] == 6: #top left corner
					item = TEXTURE_TILES["TOP_LEFT_FLOOR"][
						rng.randi_range(0, TEXTURE_TILES["TOP_LEFT_FLOOR"].size() - 1)
					]
				elif layout[y][x] == 10: #top wall
					item = TEXTURE_TILES["TOP_WALL"][
						rng.randi_range(0, TEXTURE_TILES["TOP_WALL"].size() - 1)
					]
				elif layout[y][x] == 4: #left floor
					item = TEXTURE_TILES["LEFT_FLOOR"][
						rng.randi_range(0, TEXTURE_TILES["LEFT_FLOOR"].size() - 1)
					]
				elif layout[y][x] == 4: #right floor
					item = TEXTURE_TILES["LEFT_FLOOR"][
						rng.randi_range(0, TEXTURE_TILES["LEFT_FLOOR"].size() - 1)
					]
				
				if item != null:
					set_cell(
						origin + Vector2i(x, y),
						source_id,
						item
					)
								
