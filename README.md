# COSC303_Final_Project
[Project Repository](https://github.com/Happyjog/COSC303_Final_Project.git)
Updated dungeon crawling RPG with a graphical interface and randomly generated dungeon.

### Compile & Run:
g++ main.cpp Dungeon.cpp Entity.cpp Item.cpp presets.cpp -o game
./game

## Controls:
> w = move north
> a = move west
> s = move south
> d = move east
> q = quit

## Self-Created Rubrik
```
+3 Code quality and documentation.
+5 Time complexity requirement for dungeon generation and path finding O(n).
+10 Display with godot works (Alex works on room generation, Jouji finds sprites and backgrounds).
+10 Adding new mechanics in the game. (at least 2, 5 points each)
+10 Graph-based path finding algorithm. (Both partners will work on a part of this)
+2 Header + readme info. 
```

## Time Log
### Alex
| Date  | Time      | Description                          | Notes/Link |
|-------|-----------|--------------------------------------|------------|
| 10/15 | 2         | Downloaded and Learned Godot Engine  |            |

### Jouji
| Date  | Time(hrs) | Description                          | Notes/Link |
|-------|-----------|--------------------------------------|------------|
|       |           |                                      |            |


### Current Progress Reflection
We debated using the c++ engine for godot, as the work done previously was in c++, but ultimatley we decided that  the effort required to run c++ in godot would be greater than the simply transfering the current work into GDScript.

Progress summary: What you completed.
Reflection and next-step plan: What went well, what changed, what remains, and what help you need
Shared repository: A link that the TAs and instructor can access.
Individual code contribution: A link or clear reference to the relevant file, commit, branch, or repository location.
Time log: Your individual record of project work.
Milestone rubric: You individualized 40-point milestone rubric.

Alex code:
generates a randomly arranged tilemap layer
a similar cersion of this will be used for the actual game to
generate rooms

extends TileMapLayer

@export var map_width: int = 50
@export var map_height: int = 50

# Atlas coordinates for tiles in your TileSet.
@export var tile_choices: Array[Vector2i] = [
    Vector2i(0, 0), # Grass
    Vector2i(1, 0), # Dirt
    Vector2i(2, 0)  # Stone
]

@export var source_id: int = 0

func _ready() -> void:
    generate_map()

func generate_map() -> void:
    clear()

    if tile_choices.is_empty():
        push_warning("No tile choices configured!")
        return

    randomize()

    for x in range(map_width):
        for y in range(map_height):
            var cell := Vector2i(x, y)

            var random_tile: Vector2i = tile_choices[
                randi_range(0, tile_choices.size() - 1)
            ]

            set_cell(cell, source_id, random_tile)

func regenerate_map() -> void:
    generate_map()
