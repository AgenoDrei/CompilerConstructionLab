#include "inc/EntryNode.h"

#include <sstream>

EntryNode::EntryNode() {
	_leftInput = nullptr;
	_rightInput = nullptr;
	_leftOutput = nullptr;
	_rightOutput = nullptr;
}

void EntryNode::setLeftInput(BaseNode* id) {
	_leftInput = id;
}

void EntryNode::setRightInput(BaseNode* str) {
	_rightInput = str;
}

void EntryNode::setLeftOutput(BaseNode* id) {
	_leftOutput = id;
}

void EntryNode::setRightOutput(BaseNode* id) {
	_rightOutput = id;
}

std::string EntryNode::getType() {
	return "E";
}

std::string EntryNode::toString() {
	std::stringstream ss;
        ss<<BaseNode::toString();
	if(_leftOutput) {
		ss<<_leftOutput->getID()<<" "<<_leftOutput->getConnectedPort(this);
	}
	ss<<")\t\t(";
	if(_rightOutput) {
		ss<<_rightOutput->getID()<<" "<<_rightOutput->getConnectedPort(this);
	}
	ss<<")\t\t"<<_rightInput->toString();
	return ss.str();
}

int EntryNode::getConnectedPort(BaseNode* n) {
        if(_leftInput == n) {
                return 0;
        } else if(_rightInput == n) {
                return 1;
        }
        return -1;
}

