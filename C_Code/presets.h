// Presets for creating entities and items in the game. This allows for easy creation of common enemies and items without having to specify their attributes every time.
#ifndef PRESESTS_H
#define PRESESTS_H
#include "Entity.h"
#include "Item.h"

namespace presets{

    Entity* createGoblin();
    Entity* createSkeleton();
    Entity* createSlime();
    Entity* createBoss();

    Item* createHealthPotion();
    Item* createBomb();
        

}

#endif