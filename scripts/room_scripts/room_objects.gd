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



func generate_objects(layout: Array, origin: Vector2i, rng: RandomNumberGenerator) -> void:

	if layout.is_empty():
		return

	var height = layout.size()
	var width = layout[0].size()

	for y in range(height):
		for x in range(width):

			var tile_type: int = layout[y][x]
			var item = null

			# Only spawn objects on supported tile types
			match tile_type:

				1: # Interior floor
					if rng.randf() < 0.04:
						item = TEXTURE_TILES["FLOOR"].pick_random()

				6: # Top-left floor corner
					if rng.randf() < 0.04:
						item = TEXTURE_TILES["TOP_LEFT_FLOOR"].pick_random()

				10: # Top wall
					if rng.randf() < 0.04:
						item = TEXTURE_TILES["TOP_WALL"].pick_random()

				4: # Left floor edge
					if rng.randf() < 0.04:
						item = TEXTURE_TILES["LEFT_FLOOR"].pick_random()

				5: # Right floor edge
					if rng.randf() < 0.04:
						item = TEXTURE_TILES["LEFT_FLOOR"].pick_random()

			if item != null:
				set_cell(
					origin + Vector2i(x, y),
					source_id,
					item
				)
