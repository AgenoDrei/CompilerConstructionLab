#pragma once

#include "BaseNode.h"
#include <vector>

class CopyNode : public BaseNode {
private:
	BaseNode* _input;
	std::vector<BaseNode*> _outputs;
public:
	CopyNode();

	void setInput(BaseNode* n);

	void addOutput(BaseNode* n);

	virtual std::string getType();
	virtual std::string toString();

	virtual int getConnectedPort(BaseNode* n);
};

