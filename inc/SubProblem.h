#pragma once

#include "BaseProblem.h"

class SubProblem : public BaseProblem {
private:
	std::list<std::string> _helperVariables;

	std::string _name;
public:
        std::list<std::string>::const_iterator getHelperVariablesStart();
        std::list<std::string>::const_iterator getHelperVariablesEnd();
        size_t getHelperVariableSize();

	void completeSubProblem();

	void setName(std::string n);
	void appendName(std::string n);
	std::string getName();
};

