#include "inc/IndependenceNode.h"

#include <sstream>

IndependenceNode::IndependenceNode() {
	 _leftInput = nullptr;
        _rightInput = nullptr;
        _leftOutput = nullptr;
        _rightOutput = nullptr;

}

void IndependenceNode::setLeftInput(BaseNode* n) {
        _leftInput = n;
}

void IndependenceNode::setRightInput(BaseNode* n) {
        _rightInput = n;
}

void IndependenceNode::setLeftOutput(BaseNode* n) {
        _leftOutput = n;
}

void IndependenceNode::setRightOutput(BaseNode* n) {
        _rightOutput = n;
}

std::string IndependenceNode::getType() {
        return "I";
}

std::string IndependenceNode::toString() {
	std::stringstream ss;
        ss<<BaseNode::toString();
        if(_leftOutput)
                ss<<_leftOutput->getID()<<" "<<_leftOutput->getConnectedPort(this);
        if(_rightOutput)
                ss<<")\t\t("<<_rightOutput->getID()<<" "<<_rightOutput->getConnectedPort(this);
        ss<<")\t\t INFO";
        return ss.str();

}

int IndependenceNode::getConnectedPort(BaseNode* n) {
        if(_leftInput == n) {
                return 0;
        } else if(_rightInput == n) {
                return 1;
        }
        return -1;
}

