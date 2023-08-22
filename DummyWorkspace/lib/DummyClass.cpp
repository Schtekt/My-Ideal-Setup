#include "DummyClass.h"
#include <iostream>

DummyClass::DummyClass()
{
    std::cout << "I am alive, fear me!\n";
}

DummyClass::~DummyClass()
{
    std::cout << "I am dead... or am I?\n";
}