#pragma once

#include "BaseNode.h"
#include "ILeftOutputNode.h"

class GroundNode : public BaseNode, public ILeftOutputNode {
private:
        BaseNode* _leftInput;
        BaseNode* _rightInput;

        BaseNode* _leftOutput;
        BaseNode* _rightOutput;
public:
	GroundNode();

        void setLeftInput(BaseNode* n);
        void setRightInput(BaseNode* n);

        virtual void setLeftOutput(BaseNode* n);
        void setRightOutput(BaseNode* n);

	virtual std::string getType();
	virtual std::string toString();

	virtual int getConnectedPort(BaseNode* n);
};

