#ifndef SPOOPY_QUENE_FAMILY_INDICES_HPP
#define SPOOPY_QUENE_FAMILY_INDICES_HPP

#include <iostream>

struct QueueFamilyIndices {
    uint32_t graphicsFamily;
    uint32_t presentFamily;
    bool graphicsFamilyHasValue = false;
    bool presentFamilyHasValue = false;
    bool isComplete() { return graphicsFamilyHasValue && presentFamilyHasValue; }
};
#endif