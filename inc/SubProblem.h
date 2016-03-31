#pragma once

#include <set>
#include <string>

class SubProblem {
private:
	std::set<std::string> _variables;
	std::set<std::string> _helperVariables;
};

