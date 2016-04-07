#include "inc/SubProblem.h"

std::list<std::string>::const_iterator SubProblem::getHelperVariablesStart() {
        return _helperVariables.begin();
}

std::list<std::string>::const_iterator SubProblem::getHelperVariablesEnd() {
        return _helperVariables.end();
}

size_t SubProblem::getHelperVariableSize() {
        return _helperVariables.size();
}

void SubProblem::completeSubProblem() {
	if(_name.back() == ',') {
		_name = _name.substr(0, _name.size() - 1); // remove last , from parameter
	}
       	_name.append(")");
}

void SubProblem::setName(std::string name) {
	_name.insert(0, "(");
	_name.insert(0, name);
}

void SubProblem::appendName(std::string name) {
	_name.append(name);
}

std::string SubProblem::getName() {
	return _name;
}

