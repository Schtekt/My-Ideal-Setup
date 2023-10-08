#include <iostream>
#include "DummyClass.h"
int main()
{
    DummyClass object;

#if __GNUC__
#if __x86_64__ || __ppc64__
std::cout << "Running x64!\n";
#else
std::cout << "Running x32!\n";
#endif
#endif
}