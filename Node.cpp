#include "inc/Node.h"
#include <string>

int Node::auto_id = 0;

Node::Node(NodeType type) : 
	_id(auto_id++),
	_type(type) {

	for(auto i = 0; i < 5; ++i) {
		outputs[i] = -1;
	}
}

int Node::getID() {
	return _id;
}

NodeType Node::getType() {
	return _type;
}

int Node::addOutput(int id) {
	for(auto i = 0; i < 5; ++i) {
		if(outputs[i] == -1) {
			outputs[i] = id;
			return i;
		}
	}
	throw std::string("No more outputs");
}

