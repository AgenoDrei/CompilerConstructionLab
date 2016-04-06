#include "inc/BaseProblem.h"

BaseProblem::BaseProblem() {

}

void BaseProblem::addVariable(std::string name) {
        _variables.push_back(name);
}

std::list<std::string>::const_iterator BaseProblem::getVariablesStart() {
	return _variables.begin();
}

std::list<std::string>::const_iterator BaseProblem::getVariablesEnd() {
        return _variables.end();
}

size_t BaseProblem::getVariableSize() {
	return _variables.size();
}

