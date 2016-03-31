#pragma once

#include <list>

class SubProblem;

class Problem {
private:
	std::list<SubProblem*> _subProblems;
	bool _headCompleted; // true after :-

public:
	Problem();
	~Problem();

	void setHeadCompleted();
	bool getHeadCompleted();
};

