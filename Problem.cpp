#include "inc/Problem.h"
#include "inc/SubProblem.h"

#include <string>
#include <iostream>

using namespace std;

Problem::Problem() {
	_headCompleted = false;
}

Problem::~Problem() {
}

void Problem::setHeadCompleted() {
	if(_headCompleted) {
		throw std::string("Head should only be completed once.");
	}
	_headCompleted = true;
	_name = _name.substr(0, _name.size() - 1); // remove last , from parameter
	_name.append(")");
}

bool Problem::getHeadCompleted() {
	return _headCompleted;
}

SubProblem* Problem::newSubProblem() {
	_subProblems.push_back(unique_ptr<SubProblem>(new SubProblem()));
	return getCurrentSubProblem();
}

SubProblem* Problem::getCurrentSubProblem() {
	if(_subProblems.empty()) {
		return nullptr;
	}
	return _subProblems.back().get();
}

std::list<std::unique_ptr<SubProblem>>::const_iterator Problem::getSubProblemStart() {
	return _subProblems.begin();
}

std::list<std::unique_ptr<SubProblem>>::const_iterator Problem::getSubProblemEnd() {
	return _subProblems.end();
}

string Problem::getName() {
	return _name;
}

void Problem::setName(string name) {
	_name.insert(0, "(");
	_name.insert(0, name);
}

void Problem::appendName(string name) {
	_name.append(name);
}

