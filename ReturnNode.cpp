#include "inc/ReturnNode.h"

#include <sstream>

ReturnNode::ReturnNode() {
	_input = nullptr;
}

void ReturnNode::setInput(BaseNode* id) {
	_input = id;
}

std::string ReturnNode::getType() {
	return "R";
}

std::string ReturnNode::toString() {
        std::stringstream ss;
        ss<<BaseNode::toString()<<"- -)\t\t(- -)\t\t";
        return ss.str();
}

int ReturnNode::getConnectedPort(BaseNode* n) {
        if(_input == n) {
                return 0;
        }
        return -1;
}

