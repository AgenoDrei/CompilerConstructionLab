#include "inc/CopyNode.h"

#include <sstream>

CopyNode::CopyNode() {

}

void CopyNode::setInput(BaseNode* n) {
	_input = n;
}

void CopyNode::addOutput(BaseNode* n) {
	_outputs.push_back(n);
}

std::string CopyNode::getType() {
	return "C";
}

std::string CopyNode::toString() {
        std::stringstream ss;
        ss<<BaseNode::toString();
	
	if(_outputs.size() > 0) {
		ss<<_outputs[0]->getID()<<" "<<_outputs[0]->getConnectedPort(this);
	} else {
		ss<<"- -";
	}
	ss<<")\t\t(";
	if(_outputs.size() > 1) {
		ss<<_outputs[1]->getID()<<" "<<_outputs[1]->getConnectedPort(this);
	} else {
		ss<<"- -";
	}
	ss<<")\t\t";
	if(_outputs.size() > 2) {
		ss<<"Overflow";
	}
        return ss.str();

}

int CopyNode::getConnectedPort(BaseNode* n) {
        if(_input == n) {
                return 0;
        }
        return -1;
}

