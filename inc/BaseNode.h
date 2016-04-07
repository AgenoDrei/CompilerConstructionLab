#pragma once

#include <string>

class BaseNode {
private:
	int _id;
	static int auto_id;

protected:
	BaseNode();
public:
	int getID();
	virtual std::string getType() = 0;
	virtual std::string toString();
	virtual int getConnectedPort(BaseNode* n) = 0;
};

