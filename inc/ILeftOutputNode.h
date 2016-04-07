#pragma once

class BaseNode;

class ILeftOutputNode {
public:
	virtual void setLeftOutput(BaseNode* n) = 0;
};

