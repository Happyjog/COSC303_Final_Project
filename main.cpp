// Main file for the Dungeon game. This file contains the main game loop and handles user input for moving around the dungeon and interacting with entities and items.
#include <cstdlib>
#include <iostream>
#include "Dungeon.h"
#include "Entity.h"
#include "Item.h"

int main(){
    Dungeon d;
    char input;
    while(1){
        d.printCurrentRoom();
        if(d.hasEntity()){
            d.battle(*d.getOccupant());
                if(!(d.getPlayer()->isAlive())){
                    std::cout << "Game Over!\n";
                    break;
            }
            d.printCurrentRoom();
        }
        d.pickUpItem();
        std::cout << "Enter direction (wasd) or q to quit: ";
        std::cin >> input;

        if(input == 'q'){
            break;
        }

        bool moved = false;

        switch(input){
            case 'w':
                moved = d.moveNorth();
                break;
            case 'a':
                moved = d.moveWest();
                break;
            case 's':
                moved = d.moveSouth();
                break;
            case 'd':
                moved = d.moveEast();
                break;
        }

        if(!moved){
            std::cout << "!!!!!!!!Cannot move that way.!!!!!!!!\n";
        }
       
        std::cout << "\n";

    }
    

    return 0;
}
