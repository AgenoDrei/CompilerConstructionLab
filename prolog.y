%{
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <string>
#include <iostream>
#include <algorithm>
#include <vector>
#include <map>
#include "inc/Node.h"
#include "inc/Problem.h"
#include "inc/SubProblem.h"

void yyerror(const char *message);
int yylex(void);
int error = -1;
extern FILE* yyin;
extern int yylineno;

Problem* currentProblem = new Problem();

std::string getNodeTypeString(NodeType type) {
	switch(type) {
		case ENTRY:
			return "E";
		case UPDATE:
			return "U";
		case COPY:
			return "C";
		case GROUND:
			return "G";
		case INDEPENDENCE:
			return "I";
		case APPLY:
			return "A";
		case RETURN:
			return "R";
		default:
			return "WHAT THE FUCK!!!";
	}
}

bool giIndependence(SubProblem* left, SubProblem* right) {
	// TODO
	return false;
}

bool giIndependence(std::list<SubProblem*> left, SubProblem* right) {
	for(SubProblem* l : left) {
		if(giIndependence(l, right)) {
			return true;
		}
	}
	return false;
}

bool iIndependence(SubProblem* left, SubProblem* right) {
        std::vector<std::string> resultFirstCondition(std::max(left->getVariableSize(), right->getVariableSize()));
	auto it = set_intersection(left->getVariablesStart(), left->getVariablesEnd(), right->getVariablesStart(), right->getVariablesEnd(), resultFirstCondition.begin()); // Mp UNION Mq = 0
	resultFirstCondition.resize(it - resultFirstCondition.begin());

	std::vector<std::string> mqNHp(right->getVariablesStart(), right->getVariablesEnd());
	mqNHp.insert(mqNHp.end(), left->getHelperVariablesStart(), left->getHelperVariablesEnd()); // Mq UNION NHp

	std::vector<std::string> resultSecondCondition(left->getVariableSize());
	it = set_difference(left->getVariablesStart(), left->getVariablesEnd(), mqNHp.begin(), mqNHp.end(), resultSecondCondition.begin());	
	resultSecondCondition.resize(it - resultSecondCondition.begin());

        std::list<std::string> mpNHq(left->getVariablesStart(), left->getVariablesEnd());
        mpNHq.insert(mpNHq.end(), right->getHelperVariablesStart(), right->getHelperVariablesEnd()); // Mq UNION NHp

        std::vector<std::string> resultThirdCondition(right->getVariableSize());
        it = set_difference(right->getVariablesStart(), right->getVariablesEnd(), mpNHq.begin(), mpNHq.end(), resultThirdCondition.begin());
	resultThirdCondition.resize(it - resultThirdCondition.begin());

	if(resultFirstCondition.empty() && !resultSecondCondition.empty() && !resultThirdCondition.empty()) {
		return true;
	}

	return false;
}

bool iIndependence(std::list<SubProblem*> left, SubProblem* right) {
        for(SubProblem* l : left) {
                if(iIndependence(l, right)) {
                        return true;
                }
        }
        return false;
}

bool gIndependence(SubProblem* left, SubProblem* right) {
	std::cerr<<"Doing gIndependence test!!! left:"<<left<<" right:"<<right<<std::endl;
	std::vector<std::string> result(std::max(left->getVariableSize(), right->getVariableSize()));
	auto it = set_intersection(left->getVariablesStart(), left->getVariablesEnd(), right->getVariablesStart(), right->getVariablesEnd(), result.begin());
	result.resize(it - result.begin());

	std::cout<<"Intersection size: "<<result.size()<<" Empty: "<<result.empty()<<std::endl;
	for (auto i: result)
		std::cout<<"Intersection: "<<i<<" ";

	std::cout<<std::endl;

	if(!result.empty()) {
		std::cerr<<"Found gIndependence"<<std::endl;
		return true;
	}
	// TODO: Helper variables

	std::cerr<<"Found gDependence"<<std::endl;
        return false;
}

bool gIndependence(std::list<SubProblem*> left, SubProblem* right) {
        for(SubProblem* l : left) {
                if(gIndependence(l, right)) {
                        return true;
                }
        }
        return false;
}


void createTree() {
	Node* entry = new Node(ENTRY);

	std::map<int, Node*> nodes; // TODO: use smart pointer
	nodes.insert(std::pair<int, Node*>(entry->getID(), entry));

	std::list<SubProblem*> visitedSubproblems;

	int numSubProblem = 0;
	Node* firstSubProblemUpdate = nullptr;
	Node* mainCopyNode = nullptr;
	Node* lastOutputCopyTokenUpdateNode = nullptr;

	for(auto i = currentProblem->getSubProblemStart(); i != currentProblem->getSubProblemEnd(); ++i) {
		Node* updateSubProblem = new Node(UPDATE);
		nodes.insert(std::pair<int, Node*>(updateSubProblem->getID(), updateSubProblem));
                // TODO: updateSubProblem.input.right = subProblem

                if(numSubProblem == 0) {
			firstSubProblemUpdate = updateSubProblem;

                        entry->outputs[1] = updateSubProblem->getID();
                        updateSubProblem->inputs.left = entry->getID();
                } else if(numSubProblem == 1) {
			Node* copy = new Node(COPY);
			nodes.insert(std::pair<int, Node*>(copy->getID(), copy));

			copy->inputs.left = entry->getID();
			entry->outputs[1] = copy->getID();
			
			updateSubProblem->inputs.left = copy->getID();
			copy->outputs[0] = updateSubProblem->getID();

			firstSubProblemUpdate->inputs.left = copy->getID();
			copy->outputs[1] = firstSubProblemUpdate->getID();
		} else {
			Node* copy = mainCopyNode;
			
			updateSubProblem->inputs.left = copy->getID();
                        copy->addOutput(updateSubProblem->getID());
		}

		Node* lastDependenceNode = updateSubProblem; // if there is no dependence the next node is the last U-Node

		if(giIndependence(visitedSubproblems, i->get())) {
			// TODO
		} else if(gIndependence(visitedSubproblems, i->get())) {
			Node* g = new Node(GROUND);
			nodes.insert(std::pair<int, Node*>(g->getID(), g));

			g->inputs.left = updateSubProblem->getID();
			updateSubProblem->outputs[0] = g->getID();

			lastDependenceNode = g;
		} else if(iIndependence(visitedSubproblems, i->get())) {
                        Node* iNode = new Node(INDEPENDENCE);
                        nodes.insert(std::pair<int, Node*>(iNode->getID(), iNode));

                        iNode->inputs.left = updateSubProblem->getID();
                        updateSubProblem->outputs[0] = iNode->getID();

			lastDependenceNode = iNode;
		}

		Node* apply = new Node(APPLY);
		nodes.insert(std::pair<int, Node*>(apply->getID(), apply));

		apply->inputs.left = lastDependenceNode->getID();
		lastDependenceNode->outputs[0] = apply->getID();

		Node* copyOutputToken = new Node(COPY);
		nodes.insert(std::pair<int, Node*>(copyOutputToken->getID(), copyOutputToken));

		copyOutputToken->inputs.left = apply->getID();
		apply->outputs[0] = copyOutputToken->getID();

		Node* outputCopyTokenUpdate = new Node(UPDATE);
		nodes.insert(std::pair<int, Node*>(outputCopyTokenUpdate->getID(), outputCopyTokenUpdate));

		outputCopyTokenUpdate->inputs.left = copyOutputToken->getID();
		copyOutputToken->addOutput(outputCopyTokenUpdate->getID());

		if(numSubProblem == 0) {
			entry->outputs[0] = outputCopyTokenUpdate->getID();
			outputCopyTokenUpdate->inputs.right = entry->getID();
		} else {
			outputCopyTokenUpdate->outputs[0] = lastOutputCopyTokenUpdateNode->getID();
			lastOutputCopyTokenUpdateNode->inputs.right = outputCopyTokenUpdate->getID();
		}

		lastOutputCopyTokenUpdateNode = outputCopyTokenUpdate;		

		visitedSubproblems.push_back(i->get());
                numSubProblem++;
	}

	Node* returnNode = new Node(RETURN);
	nodes.insert(std::pair<int, Node*>(returnNode->getID(), returnNode));
	
	returnNode->inputs.left = lastOutputCopyTokenUpdateNode->getID();
	lastOutputCopyTokenUpdateNode->outputs[0] = returnNode->getID();

	std::cout<<"<Nr>\t"<<"<Typ>\t"<<"(<RNr> <RPort>)\t"<<"(<LNr> <LPort>)\t"<<"Info"<<std::endl;
	for(auto& kv : nodes)  {
		std::cout<<kv.first<<"\t"<<getNodeTypeString(kv.second->getType())<<"\t"<<"(";
		if(kv.second->outputs[0] != -1) {
			std::cout<<kv.second->outputs[0]<<" ";
		} else {
			std::cout<<"- ";
		}
		if(kv.second->outputs[0] != -1) {
			if(nodes[kv.second->outputs[0]]->inputs.left == kv.first) {
				std::cout<<"L";
			} else {
				std::cout<<"R";			
			}
		}else {
			std::cout<<"-";
		}
		std::cout<<")\t\t"<<"(";
		if(kv.second->outputs[1] != -1) {
                        std::cout<<kv.second->outputs[1]<<" ";
                } else {
                        std::cout<<"- ";
                }
		if(kv.second->outputs[1] != -1) {
			if(nodes[kv.second->outputs[1]]->inputs.left == kv.first) {
                                std::cout<<"L";
                        } else {
                                std::cout<<"R";
                        }
		} else {
			std::cout<<"-";
		}
		std::cout<<")\t\t"<<"Info"<<std::endl;
	};

	// TODO: Memory cleanup
}

%}

%error-verbose

%start S

%union {
	float reell;
	int integer;
	char* variable;
	char* name;
}
 
%token END 0 
%token OPEN_BRACKET
%token CLOSE_BRACKET
%token CLOSE_SQUARE_BRACKET
%token OPEN_SQUARE_BRACKET
%token RULE_OPERATOR
%token IS
%token EQUAL
%token UNEQUAL
%token GREATER_EQUAL
%token SMALLER_EQUAL
%token SMALLER
%token GREATER
%token TIMES
%token PLUS
%token MINUS
%token NAME
%token VARIABLE
%token FLOAT INT // NOT USED?!
%token COMMA
%token PIPE 
%token DOT
%token NUMBER

%type <float> NUMBER
%type <variable> VARIABLE 
%type <name> NAME

%left MINUS
%left PLUS
%left TIMES
%left GREATER
%left SMALLER
%left GREATER_EQUAL
%left SMALLER_EQUAL
%left EQUAL
%left UNEQUAL
%left IS

%%

S : HEAD AFTER_HEAD
| END {if(currentProblem) { delete currentProblem; }};

AFTER_HEAD: RULE_FINISHED S
| RULE RULE_FINISHED S;

RULE_FINISHED: DOT {createTree(); delete currentProblem; currentProblem = new Problem();}

RULE: RULE_OPERATOR TAIL;

HEAD : FACT { currentProblem->setHeadCompleted();};

FACT : NAME OPEN_BRACKET PARAMETER_LIST CLOSE_BRACKET {
     printf("Name: %s\n", $1);
};

PARAMETER_LIST : PARAMETER
| PARAMETER COMMA PARAMETER_LIST;

PARAMETER: NAME {printf("Name: %s\n", $1);} 
| VARIABLE {
	printf("Variable: %s\n", $1);
	if(currentProblem->getHeadCompleted()) {
		currentProblem->getCurrentSubProblem()->addVariable($1);
	} else {
		currentProblem->addVariable($1);
	}
} 
| NUMBER
| LIST;

// crazyStuff(simon, true).
// crazyStuff(nils, false).
// crazyStuff(NAME, IS_STUPID) :- otherStuff(NAME) = IS_STUPID. // (otherStuff(NAME) AND IS_STUPID) OR (!otherStuff(NAME) AND !IS_STUPID)
//isStupid(nils).
// crazyStuff(NAME) :- otherStuff(NAME), isStupid(NAME). // otherStuff(NAME) AND isStupid(NAME)

TAIL : CHAIN; // a(X,Y), b(X,Z)

START_FACT : %empty {
	printf("Create Subproblem\n");
	currentProblem->newSubProblem();
};

CHAIN : START_FACT FACT
| EXPRESSION
| START_FACT FACT COMMA CHAIN
| EXPRESSION COMMA CHAIN;

EXPRESSION : NUMBER
| VARIABLE
| EXPRESSION GREATER EXPRESSION
| EXPRESSION SMALLER EXPRESSION
| EXPRESSION GREATER_EQUAL EXPRESSION
| EXPRESSION SMALLER_EQUAL EXPRESSION
| EXPRESSION EQUAL EXPRESSION
| EXPRESSION MINUS EXPRESSION
| EXPRESSION PLUS EXPRESSION
| EXPRESSION TIMES EXPRESSION
| MINUS EXPRESSION
| EXPRESSION UNEQUAL EXPRESSION 
| OPEN_BRACKET EXPRESSION CLOSE_BRACKET
| EXPRESSION IS EXPRESSION; 

// LISTS
LIST : OPEN_SQUARE_BRACKET LIST_BODY CLOSE_SQUARE_BRACKET;

LIST_BODY : LIST_HEAD PIPE LIST_TAIL
| LIST_HEAD
|%empty; //Empty list []

LIST_HEAD : PARAMETER_LIST;

LIST_TAIL : PARAMETER;

%%

int main(int argc, char **argv) {
	try {
		if(argc == 1) {
			yyparse();
		} else {
			yyin = fopen(argv[1], "r");
			yyparse();
		}
	} catch(std::string message) {
		std::cerr<<message<<std::endl;
		return -1;
	}
	return 0;
}

void yyerror(const char *message) {
	printf("%d: %s \n", yylineno, message);
}
