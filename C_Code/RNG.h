#ifndef RNG_H
#define RNG_H

#include <random>

class RNG {
public:
    // Returns a shared random engine
    static std::mt19937& engine() {
        static std::random_device rd;
        static std::mt19937 gen(rd());
        return gen;
    }

    // Returns integer in [min, max]
    static int range(int min, int max) {
        std::uniform_int_distribution<int> dist(min, max);
        return dist(engine());
    }

    // Percentage chance (0–100)
    static bool percent(int chance) {
        return range(1, 100) <= chance;
    }
};

#endif