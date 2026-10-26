// Presets for creating entities and items in the game

#include "presets.h"

Entity* presets::createGoblin() {
    return new Entity("Goblin", 50, 10);
}

Entity* presets::createSkeleton() {
    return new Entity("Skeleton", 75, 15);
}

Entity* presets::createSlime() {
    return new Entity("Slime", 30, 5);
}

Entity* presets::createBoss() {
    return new Entity("Boss", 150, 25);
}

Item* presets::createHealthPotion() {
    return new Item("Health Potion", 35);
}

Item* presets::createBomb() {
    return new Item("Bomb", 50);
}