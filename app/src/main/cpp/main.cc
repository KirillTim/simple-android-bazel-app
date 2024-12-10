#include <iostream>
#include "jni_dep.h"

int main() {
  std::cout << "hello!" << std::endl;
  std::cout << sayHi("Kirill") << std::endl;
}