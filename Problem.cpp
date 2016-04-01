#include "inc/Problem.h"
#include "inc/SubProblem.h"

#include <string>
#include <iostream>

using namespace std;

Problem::Problem() {
	_headCompleted = false;
}

Problem::~Problem() {
	cout<<"Problem destroyed"<<endl;
}

void Problem::setHeadCompleted() {
	if(_headCompleted) {
		throw std::string("Head should only be completed once.");
	}
	_headCompleted = true;
}

bool Problem::getHeadCompleted() {
	return _headCompleted;
}

SubProblem* Problem::newSubProblem() {
	_subProblems.push_back(unique_ptr<SubProblem>(new SubProblem()));
	return getCurrentSubProblem();
}

SubProblem* Problem::getCurrentSubProblem() {
	return _subProblems.back().get();
}

