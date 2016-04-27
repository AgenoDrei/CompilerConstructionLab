#include "inc/BaseNode.h"

#include <sstream>

int BaseNode::auto_id = 0;

BaseNode::BaseNode(bool incrementID) : 
	_id(auto_id) {
	if(incrementID) {
		auto_id++;
	}
}

int BaseNode::getID() {
	return _id;
}

std::string BaseNode::toString() {
	std::stringstream ss;
	ss<<getID()<<"\t"<<getType()<<"\t"<<"(";
	return ss.str();
}

