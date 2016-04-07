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

