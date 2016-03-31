#include "inc/Problem.h"

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

