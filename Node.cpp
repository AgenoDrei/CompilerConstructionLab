#include "inc/Node.h"

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

