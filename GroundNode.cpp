#include "inc/GroundNode.h"

#include <sstream>

GroundNode::GroundNode() {
	_leftInput = nullptr;
	_rightInput = nullptr;
	_leftOutput = nullptr;
	_rightOutput = nullptr;
}

void GroundNode::setLeftInput(BaseNode* n) {
	_leftInput = n;
}

void GroundNode::setRightInput(BaseNode* n) {
	_rightInput = n;
}

void GroundNode::setLeftOutput(BaseNode* n) {
	_leftOutput = n;
}

void GroundNode::setRightOutput(BaseNode* n) {
	_rightOutput = n;
}

std::string GroundNode::getType() {
	return "G";
}

std::string GroundNode::toString() {
        std::stringstream ss;
        ss<<BaseNode::toString();
	if(_leftOutput) {
		ss<<_leftOutput->getID()<<" "<<_leftOutput->getConnectedPort(this);
	} else {
		ss<<"- -";
	}
	ss<<")\t\t(";
	if(_rightOutput) {
		ss<<_rightOutput->getID()<<" "<<_rightOutput->getConnectedPort(this);
	} else {
		ss<<"- -";
	}
	ss<<")\t\t"<<_rightInput->toString();
        return ss.str();
}


int GroundNode::getConnectedPort(BaseNode* n) {
        if(_leftInput == n) {
                return 0;
        } else if(_rightInput == n) {
                return 1;
        }
        return -1;
}

