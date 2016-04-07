#pragma once

#include "BaseNode.h"

class EntryNode : public BaseNode {
private:
	BaseNode* _leftOutput;
	BaseNode* _rightOutput;

	BaseNode* _leftInput;
	BaseNode* _rightInput;
public:
	EntryNode();

	void setLeftInput(BaseNode* id);
	void setRightInput(BaseNode* str);

	void setLeftOutput(BaseNode* id);
	void setRightOutput(BaseNode* id);

	virtual std::string getType();
	virtual std::string toString();

	virtual int getConnectedPort(BaseNode* n);
};

