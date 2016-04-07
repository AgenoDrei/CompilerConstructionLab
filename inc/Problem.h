#pragma once

#include "BaseProblem.h"

#include <memory>

class SubProblem;

class Problem : public BaseProblem {
private:
	std::list<std::unique_ptr<SubProblem>> _subProblems;
	bool _headCompleted; // true after :-

	std::string _name;
public:
	Problem();
	~Problem();

	void setName(std::string s);
	void appendName(std::string s);
	std::string getName();

	void setHeadCompleted();
	bool getHeadCompleted();

	SubProblem* newSubProblem();
	SubProblem* getCurrentSubProblem();

	std::list<std::unique_ptr<SubProblem>>::const_iterator getSubProblemStart();
	std::list<std::unique_ptr<SubProblem>>::const_iterator getSubProblemEnd();
};

