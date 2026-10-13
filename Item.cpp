// Implementation of the Item class. This class represents items that can be found in the dungeon and used by the player to impact their stats or the stats of enemies.

#include "Item.h"
#include "Entity.h"
#include <cstdlib>


Item::Item(){
    type = "Default Item";
}

Item::Item(std::string t, int imp){
    type = t;
    impact = imp;
}

//get the numebrs that the item will impact by
int Item::getImpact() const{
    return impact;
}

// get the name of the item so that useItem in entity knows who to target with the item
std::string Item::getType() const{
    return type;
}