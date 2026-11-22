extends Node2D

const ROOM_TILES = preload("res://scripts/room_scripts/room.gd")
var hero := EntityData.new()

func _ready() -> void:
	$Player/Camera2D.make_current()
	var tiles: TileMapLayer = $Dungeon/Room
	var walls: StaticBody2D = $Walls
	var floor_coords: Dictionary = {}
	for variants in ROOM_TILES.TILE_COORDS["FLOOR"].values():
		for atlas_coord in variants:
			floor_coords[atlas_coord] = true

	# Read the finished map after the dungeon child has generated its rooms.
	# Adjacent solid cells in each row share a rectangular collision shape.
	var bounds := tiles.get_used_rect()
	walls.global_transform = tiles.global_transform
	var tile_size := Vector2(tiles.tile_set.tile_size)
	for y in range(bounds.position.y, bounds.end.y):
		var start_x := bounds.position.x
		for x in range(bounds.position.x, bounds.end.x + 1):
			var cell := Vector2i(x, y)
			if x < bounds.end.x and not floor_coords.has(tiles.get_cell_atlas_coords(cell)):
				continue
			if x > start_x:
				var shape := RectangleShape2D.new()
				shape.size = Vector2((x - start_x) * tile_size.x, tile_size.y)
				var collider := CollisionShape2D.new()
				collider.shape = shape
				collider.position = (tiles.map_to_local(Vector2i(start_x, y)) + tiles.map_to_local(Vector2i(x - 1, y))) / 2.0
				walls.add_child(collider)
			start_x = x + 1

func _enter_battle() -> void:
	$Player.set_physics_process(false)
	$Battle.begin(hero, $Player.last_skeleton.stats, $Inventory)

func _end_battle() -> void:
	if hero.health == 0:
		get_tree().reload_current_scene()
		return
	if $Player.last_skeleton.stats.health == 0:
		$Player.last_skeleton.queue_free()
		$Player.last_skeleton = null
	$Battle.hide()
	$Player.set_physics_process(true)

func _inventory_toggled(opened: bool) -> void:
	$Player.set_physics_process(not opened and not $Battle.visible)
	$Battle.set_inventory_open(opened)
