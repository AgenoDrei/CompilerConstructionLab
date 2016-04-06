#pragma once

#include <list>
#include <string>

class BaseProblem {
private:
	std::list<std::string> _variables;
protected:
	BaseProblem();

public:
	void addVariable(std::string name);

	std::list<std::string>::const_iterator getVariablesStart();
	std::list<std::string>::const_iterator getVariablesEnd();
	size_t getVariableSize();
};

