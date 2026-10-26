#include "Dungeon.h"
#include <iostream>
#include "RNG.h"
#include "presets.h"

Dungeon::Dungeon(){
    //player
    player = Entity("Player", 100, 15);
    generateDungeon();
}

Dungeon::~Dungeon() {
    //delete all rooms and their contents
    for (Room* r : allRooms) {
        delete r->occupant;
        delete r->item;
        delete r;
    }
}

void Dungeon::generateDungeon(){
    start = createRoom();
    current = start;
    // Ensure starting room has health potion and no enemy
    start -> item = presets::createHealthPotion();
    Room* temp = start;

    int length = RNG::range(6, 10); // guaranteed path length

    //dungeon generation loop, creates a path of rooms with random enemies and items
    for (int i = 0; i < length; i++) {
        Room* next = createRoom();
        placeItem(next);
        placeEntity(next);
        while (true) {
            // 0 = north, 1 = south, 2 = east, 3 = west
            int dir = RNG::range(0, 3);
            // Check if direction is free before connecting
            if (isDirectionFree(temp, dir)) {
                // Connect temp to next in the chosen direction
                connectRooms(temp, next, dir);
                break;
            }
        }
        temp = next;
    }
    // Mark the last room as the boss room
    temp->isBossRoom = true;
    temp->occupant = presets::createBoss();

    // optional branching, make sure we only branch from the original path rooms to avoid increasiing the loop
    int originalSize = allRooms.size();
    for (int i = 0; i < originalSize; i++) {
        Room* r = allRooms[i];

        // 30% chance to create a branch in each direction
        if(!RNG::percent(30))
        continue;
        int dir = RNG::range(0, 3);
        if (isDirectionFree(r, dir)){
        Room* branch = createRoom();
        placeItem(branch);
        placeEntity(branch);
        connectRooms(r, branch, dir);
        }

    }

    std::cout << "Dungeon generated with " << allRooms.size() << " rooms.\n";

}
// Movement functions return true if move successful, false if no exit in that direction
bool Dungeon::moveNorth(){
    if(!current || !current->north){
        return false;
    }
    current = current -> north;
    return true;
}
bool Dungeon::moveSouth(){
    if(!current || !current->south){
        return false;
    }
    current = current -> south;
    return true;
}
bool Dungeon::moveEast(){
    if(!current || !current->east){
        return false;
    }
    current = current -> east;
    return true;
}
bool Dungeon::moveWest(){
    if(!current || !current->west){
        return false;
    }
    current = current -> west;
    return true;
}
// Loop for battle actions until either player or enemy is defeated
void Dungeon::battle(Entity& enemy){
            std::cout << "!!!!!Entity found!!!!!\n";
            std::cout << "A " << getOccupant()->getType() << " is here!\n";
                    std::cout << "!!!WARNING!!!! !!!BATTLE START!!!\n";
    while(player.isAlive() && enemy.isAlive()){
        std::cout << "Choose action:\n0. Attack\n1. Use Item\n";
        int choice;
        std::cin >> choice;
        while(choice != 0 && choice != 1){
            std::cout << "Enter 0 or 1: ";
            std::cin >> choice;
        }
        if(choice == 1){
            if(!(player.hasItems())){
                std::cout << "No items to use!\n";
                continue;
            }
            int inp;
            std::cout << "Choose item to use:\n";
            // Print inventory with indices for user to choose from
            player.printInventory();
            std::cin >> inp;
            while(true){
                if(inp < 0 || inp >= player.getInvSize()){
                    std::cout << "Invalid item index. Try again: ";
                    std::cin >> inp;
                } else {
                    break;
                }

            }
            player.useItem(inp, enemy);

        } else if(choice == 0){
            player.attackEntity(enemy);
        }
        if(enemy.isAlive()){
            enemy.attackEntity(player);
        }
        std::cout << "-----------------------------\n";
    }
    if(player.isAlive()){
        std::cout << "You defeated the " << enemy.getType() << "!\n";
        if(current->isBossRoom){
            std::cout << "Congratulations! You defeated the boss and cleared the dungeon!\n";
            player.takeDamage(100);// kill the player to end the game cuz im lazy and it's lowkey funny
        }
    } else {
        std::cout << "You were defeated by the " << enemy.getType() << "...\n";
    }
    delete current -> occupant;
    current -> occupant = nullptr;
}

Dungeon::Room* Dungeon::createRoom(){
    Room* r = new Room();
    /// Add to list of all rooms for cleanup later
    allRooms.push_back(r);
    return r;
}

Entity* Dungeon::getOccupant() const{
    return current -> occupant;
};

bool Dungeon::hasEntity() const{
    return current -> occupant != nullptr;
}

void Dungeon::printCurrentRoom() const {

    std::cout << "Current room:\n";

    if (current->north)
        std::cout << "North exit\n";

    if (current->south)
        std::cout << "South exit\n";

    if (current->east)
        std::cout << "East exit\n";

    if (current->west)
        std::cout << "West exit\n";

    if (current->isBossRoom)
        std::cout << "Boss room!\n";

    std::cout << "-----------------------------\n";
}

void Dungeon::pickUpItem() {
    // Check if there's an item in the current room
    if (current->item == nullptr){
        std::cout << "No item to pick up!\n";
        return;
    }
    // Add item to player's inventory  
    std::cout << current->item->getType() << " picked up!\n";
    player.addItem(current->item);
    // Remove item from room but don't delete since it's now in player's inventory
    current->item = nullptr;
}
// Check if the specified direction from the room is free by checking whether or not the corresponding pointer is null
bool Dungeon::isDirectionFree(const Room* room, int dir) const{
    if (dir == 0)
        return room->north == nullptr;
    if (dir == 1)
        return room->south == nullptr;
    if (dir == 2)
        return room->east == nullptr;
    return room->west == nullptr;
}
//connects the rooms back and forth in the direction chosen by the RNG
void Dungeon::connectRooms(Room* a, Room* b, int dir) {
    if (dir == 0) {
        a->north = b;
        b->south = a;
    }
    else if (dir == 1) {
        a->south = b;
        b->north = a;
    }
    else if (dir == 2) {
        a->east = b;
        b->west = a;
    }
    else if (dir == 3) {
        a->west = b;
        b->east = a;
    }
}

void Dungeon::placeEntity(Room* r){
    if(RNG::percent(40)){// 40% chance to place an enemy in the room
        int enemyType = RNG::range(0, 2);//33.3% chance for each enemy type (too many skeletons and you lose haha)
        if(enemyType == 0){
            r -> occupant = presets::createGoblin();
        }else if(enemyType == 1){
            r -> occupant = presets::createSkeleton();
        }else{
            r -> occupant = presets::createSlime();
        }
        //guarantee enemy drops cuz game was too hard without it lol
        if(RNG::percent(50)){
            r -> item = presets::createHealthPotion();
        }else{
            r -> item = presets::createBomb();
        }
    }
}

void Dungeon::placeItem(Room* r){
    if(RNG::percent(50)){// 50% chance to place an item in the room when there is no enemy
        if(RNG::percent(50)){
            r -> item = presets::createHealthPotion();
        }else{
            r -> item = presets::createBomb();
        }
    }
}

Entity* Dungeon::getPlayer(){
    return &player;
}