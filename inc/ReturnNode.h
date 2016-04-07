#pragma once


#include "BaseNode.h"

class ReturnNode : public BaseNode {
private:
	BaseNode*_input;
public:
	ReturnNode();

	void setInput(BaseNode* id);

	virtual std::string getType();
	virtual std::string toString();

	virtual int getConnectedPort(BaseNode* n);
};

