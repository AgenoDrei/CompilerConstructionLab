#pragma once

#include "BaseNode.h"
#include "ILeftOutputNode.h"

class UpdateNode : public BaseNode, public ILeftOutputNode {
private:
	BaseNode* _leftInput;
	BaseNode* _rightInput;
	BaseNode* _output;
public:
	UpdateNode();

	void setLeftInput(BaseNode* n);
	void setRightInput(BaseNode* n);

	void setOutput(BaseNode* n);

	virtual void setLeftOutput(BaseNode* n);

	virtual std::string getType();
	virtual std::string toString();

	virtual int getConnectedPort(BaseNode* n);
};

