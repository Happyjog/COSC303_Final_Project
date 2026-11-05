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
| Date  | Time(hrs) | Description                          | Notes/Link |
|-------|-----------|--------------------------------------|------------|
| 10/15 | 2         | Downloaded and Learned Godot Engine  |            |
| 10/26 | 1         | Set up collaborative environment for creating the project in godot thru github | |

### Jouji
| Date  | Time(hrs) | Description                          | Notes/Link |
|-------|-----------|--------------------------------------|------------|
|       |           |                                      |            |


### Current Progress Reflection
We debated using the c++ engine for godot, as the work done previously was in c++, but ultimatley we decided that  the effort required to run c++ in godot would be greater than the simply transfering the current work into GDScript.

### What we are trying to accomplish
##### (kind of in order of importance)
- Player that can move freely and interact with chests, bosses, and doors
- Make a camera that focuses on the center of the room
    - When the character leaves the room it fades, and the program is given the side of of the room the character should be on(N, E, S, or W) and the next room its in.
    - Camera position depends on the type of room that it is veiwing
- Make "title screen" with a play button and then an option for a seed or randomly generate one
    - This will be a separate scene, as well as the game over/continue screen.
- Make a matrix of room "objects" and each one has the layout of the room and which rooms its connected to on each side.
    - each room can have some kind of puzzle/battle/advantage
        - Battle will be a separate scene pokemon-style (if you die start from the beggining of the maze)
    - each room will generate randomly from 4 preset room layouts(L-shaped, rectangle, U-shaped, hallway)
    - item could show you (vaugely) which direction to go
    - one room is the "exit room" where the game is over
 

Meeting #1 - 11/05/2026
    We met in the library today to talk about specific jobs and what are hard requirements to get 
our project working. We messed around in godot and created a sample room to test out the camera. 
Specific chosen jobs:

Alex — Dungeon and room systems
- Create the room matrix and connections between rooms.
- Implement dungeon generation using a supplied or randomly chosen seed.
- Create and display room layouts.
- Keep the camera centered on the current room.
- Implement fades and transitions between rooms.
- Place the player at the correct entrance after a transition.
- Preserve room state, including completed encounters and opened chests.
- Implement BFS pathfinding.
- Place the exit room and trigger victory.

Jouji — Entities, player, and combat systems
- Implement free player movement and wall collision.
- Implement interactions with doors, chests, and enemies.
- Create player and enemy data: health, attack power, and enemy presets.
- Implement inventory, item collection, and item effects.
- Create the separate turn-based battle scene.
- Implement attacks, enemy turns, critical hits, misses, and battle results.
- Add player/enemy sprites, animations, health displays, and combat buttons.
- Implement the direction-hint item using Alex’s pathfinding results.
- Create the title screen with Play and seed-selection options.
- Create the game-over/continue screen and agreed death-reset behavior.



