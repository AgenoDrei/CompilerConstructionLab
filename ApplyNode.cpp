#include "inc/ApplyNode.h"

#include <sstream>
#include <iostream>

ApplyNode::ApplyNode() {
	_input = nullptr;
	_output = nullptr;
}

void ApplyNode::setInput(BaseNode* n) {
        _input = n;
}

void ApplyNode::setOutput(BaseNode* n) {
	_output = n;
}

std::string ApplyNode::getType() {
        return "A";
}

std::string ApplyNode::toString() {
	std::stringstream ss;
	ss<<BaseNode::toString();
	if(_output)
		ss<<_output->getID()<<" "<<_output->getConnectedPort(this);
	ss<<")\t\t(- -)\t\t";
	return ss.str();
}

BaseNode* ApplyNode::getInput() {
	return _input;
}

int ApplyNode::getConnectedPort(BaseNode* n) {
        if(_input == n) {
                return 0;
        }
        return -1;
}

