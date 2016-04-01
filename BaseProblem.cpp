#include "inc/BaseProblem.h"

BaseProblem::BaseProblem() {

}

void BaseProblem::addVariable(std::string name) {
        _variables.push_back(name);
}


