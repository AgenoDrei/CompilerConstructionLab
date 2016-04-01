#pragma once

#include "BaseProblem.h"

#include <memory>

class SubProblem;

class Problem : public BaseProblem {
private:
	std::list<std::unique_ptr<SubProblem>> _subProblems;
	bool _headCompleted; // true after :-
public:
	Problem();
	~Problem();

	void setHeadCompleted();
	bool getHeadCompleted();

	SubProblem* newSubProblem();
	SubProblem* getCurrentSubProblem();
};

