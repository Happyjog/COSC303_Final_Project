#include "Entity.h"
#include "Item.h"
#include "RNG.h"
#include <iostream>
#include <vector>


Entity::Entity(){
    type = "Default Entity";
    health = 100;
    attackPower = 10;

}

Entity::Entity(std::string t, int hp, int atk){
    type = t;
    health = hp;
    attackPower = atk;
}

Entity::Entity(const Entity &other){
    type = other.type;
    health = other.health;
    attackPower = other.attackPower;
    // deep copy inventory. not that we really need it since the player is the only one that uses item in my implementation!
    for (Item* item : other.inventory) {
    inventory.push_back(new Item(*item));
    }

}

Entity::~Entity(){
    for (Item* item : inventory) {
        delete item;
    }
    inventory.clear();
}

Entity& Entity::operator=(const Entity &other){

    if(this != &other){
        // cleanup old inventory
        for(Item* item : inventory){
            delete item;
        }
        inventory.clear();
        type = other.type;
        health = other.health;
        attackPower = other.attackPower;
        // deep copy inventory
        for(Item* item : other.inventory){
            inventory.push_back(new Item(*item));
        }
    }
    return *this;
}

void Entity::takeDamage(int dmg){
    health -= dmg;
    // if health drops to 0 or below, the entity is considered dead and health is set to 0 to avoid negative values
    if(health <= 0){
        health = 0;
    }
}

void Entity::heal(int amount) {
    health += amount;
    // cap health at 100 to prevent overhealing
    if(health > 100){
        health = 100;
    }
}

bool Entity::isAlive() const {
    return health > 0;
}
//getters!
int Entity::getHealth() const{
    return health;
}
std::string Entity::getType() const{
    return type;
}
int Entity::getInvSize() const {
    return inventory.size();
}

bool Entity::hasItems() const {
    return inventory.size() > 0;
}

void Entity::addItem(Item* item) {
    inventory.push_back(item);
}

void Entity::useItem(int index, Entity& target) {
    // Check if index is valid
    if (index < 0 || index >= inventory.size()) {
        return;
    }

    Item* item = inventory[index];

    if (item->getType() == "Health Potion") {
        heal(item->getImpact());
        //report
        std::cout << type << " uses " << item->getType() << " and heals for " << item->getImpact() << " health!\n";
        std::cout << type << " now has " << health << " health.\n";
        std::cout << target.getType() << " still has " << target.getHealth() << " health.\n";
    }
    else if (item->getType() == "Bomb") {
        target.takeDamage(item->getImpact());
        //report
        std::cout << type << " uses " << item->getType() << " and deals " << item->getImpact() << " damage to " << target.getType() << "!\n";
        std::cout << target.getType() << " now has " << target.getHealth() << " health.\n";
    }

    delete item;
    // Remove item from inventory and shift remaining items down(assuming you don't have too much stuff haha)
    inventory.erase(inventory.begin() + index);
}

void Entity::attackEntity(Entity &target) {
    int damage = attackPower;
    if (RNG::percent(10) && type == "Player") { // 10% chance for critical hit if player
    std::cout << "CRITICAL HIT!\n";
    damage *= 2;
    }
    if (RNG::percent(17) && type != "Player") { // enemy has 17% chance to miss to make the game easier lol
    std::cout << "MISS\n";
    damage = 0;
    }
    target.takeDamage(damage);
    //report
    std::cout << type << " attacks " << target.getType() << " for " << damage << " damage!\n";
    std::cout << target.getType() << " has " << target.getHealth() << " health remaining.\n";
}

void Entity::printInventory() const {
    for (size_t i = 0; i < inventory.size(); ++i) {
        std::cout << i << ". " << inventory[i]->getType() << "\n";
    }
}
