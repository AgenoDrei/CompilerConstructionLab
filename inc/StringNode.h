#pragma once

#include <string>

#include "BaseNode.h"

class StringNode : public BaseNode {
private:
	std::string _content;
public:
	StringNode(std::string content);

	virtual std::string getType();
	virtual std::string toString();

	virtual int getConnectedPort(BaseNode* n);
};

