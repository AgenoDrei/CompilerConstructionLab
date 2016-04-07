#pragma once

#include "BaseProblem.h"

class SubProblem : public BaseProblem {
private:
	std::list<std::string> _helperVariables;
public:
        std::list<std::string>::const_iterator getHelperVariablesStart();
        std::list<std::string>::const_iterator getHelperVariablesEnd();
        size_t getHelperVariableSize();
};

