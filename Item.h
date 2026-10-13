#ifndef ITEM_H
#define ITEM_H

#include <string>

class Entity;

class Item {

public:
    Item();
    Item(std::string t, int imp);
    std::string getType() const;
    int getImpact() const;

private:
    std::string type;
    int impact;
};

#endif