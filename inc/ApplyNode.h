#pragma once

#include "BaseNode.h"


class ApplyNode : public BaseNode {
private:
	BaseNode* _input;
	BaseNode* _output;
public:
	ApplyNode();

	void setInput(BaseNode* n);
	BaseNode* getInput();

	void setOutput(BaseNode* n);

	virtual std::string getType();
	virtual std::string toString();

	virtual int getConnectedPort(BaseNode* n);
};

