#pragma once

#include <list>

enum NodeType {
	ENTRY,
	UPDATE,
	COPY,
	APPLY,
	RETURN,
	GROUND,
	INDEPENDENCE
};

class Node {
private:
	int _id;
	NodeType _type;
	static int auto_id;
public:
	Node(NodeType type);

	int getID();
	NodeType getType();

	struct {
		int left = -1, right = -1;
	} inputs;

	int outputs[5];
	int addOutput(int id);

};

