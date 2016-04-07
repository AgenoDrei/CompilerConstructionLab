#include "inc/StringNode.h"

StringNode::StringNode(std::string content) : 
	_content(content) {

}

std::string StringNode::getType() {
        return "S";
}

std::string StringNode::toString() {
        return _content;
}

int StringNode::getConnectedPort(BaseNode* n) {
        return -1;
}


