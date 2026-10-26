#ifndef ENTITY_H
#define ENTITY_H

#include <string>
#include <vector>

class Item;
class Entity {

public:
    Entity();
    Entity(std::string t, int hp, int atk);
    Entity(const Entity &);
    ~Entity();
    Entity& operator=(const Entity&);

    // int attack();
    void takeDamage(int dmg);
    void heal(int amount);
    bool isAlive() const;
    int getHealth() const;
    std::string getType() const;
    bool hasItems() const;
    int getInvSize() const;
    void addItem(Item* item);
    void useItem(int index, Entity &target);
    void attackEntity(Entity& target);
    void printInventory() const;



private:
    std::string type;
    int health;
    int attackPower;
    std::vector<Item*> inventory;
   // bool isAlive;
};

#endif