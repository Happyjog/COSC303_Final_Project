#ifndef DUNGEON_H
#define DUNGEON_H

#include <vector>
#include "Item.h"
#include "Entity.h"

class Dungeon {

public:
    Dungeon();
    ~Dungeon();

    //disable copy and assignment since we have raw pointers in the class and it was too complicated and I didn't want to do it.
    Dungeon(const Dungeon&) = delete;
    Dungeon& operator=(const Dungeon&) = delete;

    // Movement
    bool moveNorth();
    bool moveSouth();
    bool moveEast();
    bool moveWest();

    // Gameplay
    void pickUpItem();
    void useItem(int index);
    // void attackEntity(Entity &attacker, Entity &opponent);
    void battle(Entity& enemy);

    // Dungeon generation
    void generateDungeon();

    //debugging
    void printCurrentRoom() const;
    bool hasEntity() const;
    Entity* getOccupant() const;
    Entity* getPlayer();


private:
    struct Room {
        Room* north = nullptr;
        Room* south = nullptr;
        Room* east  = nullptr;
        Room* west  = nullptr;

        bool isBossRoom = false;

        Item* item = nullptr;
        Entity* occupant = nullptr;
    };

    // Dungeon structure
    Room* start = nullptr;
    Room* current = nullptr;

    // Tracks all rooms for when deleting
    std::vector<Room*> allRooms;

    // Player state
    Entity player;

    // Enemies
    Entity goblin;
    Entity skeleton;
    Entity slime;
    Entity boss;

    // Items
    Item potion;
    Item bomb;


    // Helper functions
    Room* createRoom();
    bool isDirectionFree(const Room* room, int dir) const;
    void connectRooms(Room* a, Room* b, int dir);
    void collapsePath(Room* from, char direction);
    void placeEntity(Dungeon::Room* r);
    void placeItem(Room* r);

    // Utility
    int getExitCount(const Room* room) const;
    
};

#endif