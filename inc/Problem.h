#pragma once

#include <list>

class SubProblem;

class Problem {
private:
	std::list<SubProblem*> _subProblems;
};

