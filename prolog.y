%{
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <string>
#include <iostream>
#include <algorithm>
#include <vector>
#include "inc/Node.h"
#include "inc/Problem.h"
#include "inc/SubProblem.h"

void yyerror(const char *message);
int yylex(void);
int error = -1;
extern FILE* yyin;
extern int yylineno;

Problem* currentProblem = new Problem();

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
	std::vector<std::string> result(std::max(left->getVariableSize(), right->getVariableSize()));
	auto it = set_intersection(left->getVariablesStart(), left->getVariablesEnd(), right->getVariablesStart(), right->getVariablesEnd(), result.begin());
	result.resize(it - result.begin());

	if(!result.empty()) {
		return true;
	}
	// TODO: Helper variables

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
	NodeStorage storage;

	auto entry = CreateAndRegisterNode<EntryNode>(storage);
	entry->setRightInput(new StringNode(currentProblem->getName()));

	std::list<SubProblem*> visitedSubproblems;

	int numSubProblem = 0;
	UpdateNode* firstSubProblemUpdate = nullptr;
	CopyNode* mainCopyNode = nullptr;
	UpdateNode* lastOutputCopyTokenUpdateNode = nullptr;

	for(auto q = currentProblem->getSubProblemStart(); q != currentProblem->getSubProblemEnd(); ++q) {
		auto updateSubProblem = CreateAndRegisterNode<UpdateNode>(storage);
		updateSubProblem->setRightInput(new StringNode(q->get()->getName()));

                switch(numSubProblem) {
		case 0: {
			firstSubProblemUpdate = updateSubProblem;

			entry->setRightOutput(updateSubProblem);
			updateSubProblem->setLeftInput(entry);
			break;
			}
                case 1: {
			auto copy = CreateAndRegisterNode<CopyNode>(storage);

			copy->setInput(entry);
			entry->setRightOutput(copy);
			
			updateSubProblem->setLeftInput(copy);
			copy->addOutput(updateSubProblem);

			firstSubProblemUpdate->setLeftInput(copy);
			copy->addOutput(firstSubProblemUpdate);

			mainCopyNode = copy;
			break;
			}
		default: {
			CopyNode* copy = mainCopyNode;
		
			updateSubProblem->setLeftInput(copy);
			copy->addOutput(updateSubProblem);	
			}
			break;
		}

		//------------ 2.2
		BaseNode* lastDependenceNode = updateSubProblem; // if there is no dependence the next node is the last U-Node
		
		if(giIndependence(visitedSubproblems, q->get())) {
			// TODO
		} else if(gIndependence(visitedSubproblems, q->get())) {
			auto g = CreateAndRegisterNode<GroundNode>(storage);

			g->setLeftInput(updateSubProblem);
			updateSubProblem->setOutput(g);

			lastDependenceNode = g;
		} else if(iIndependence(visitedSubproblems, q->get())) {
			auto i = CreateAndRegisterNode<IndependenceNode>(storage);

			i->setLeftInput(updateSubProblem);
			updateSubProblem->setOutput(i);

			lastDependenceNode = i;
		}

		//---------2.3

		auto apply = CreateAndRegisterNode<ApplyNode>(storage);

		apply->setInput(lastDependenceNode);
		dynamic_cast<ILeftOutputNode*>(lastDependenceNode)->setLeftOutput(apply);

		//--------2.4

		auto copyOutputToken = CreateAndRegisterNode<CopyNode>(storage);

		copyOutputToken->setInput(apply);
		apply->setOutput(copyOutputToken);

		//-------2.5

		auto outputCopyTokenUpdate = CreateAndRegisterNode<UpdateNode>(storage);
		
		outputCopyTokenUpdate->setLeftInput(copyOutputToken);
		copyOutputToken->addOutput(outputCopyTokenUpdate);

		if(numSubProblem == 0) {
			outputCopyTokenUpdate->setRightInput(entry);
			entry->setLeftOutput(outputCopyTokenUpdate);
		} else {
			outputCopyTokenUpdate->setRightInput(lastOutputCopyTokenUpdateNode);
			lastOutputCopyTokenUpdateNode->setOutput(outputCopyTokenUpdate);
		}

		lastOutputCopyTokenUpdateNode = outputCopyTokenUpdate;		

		visitedSubproblems.push_back(q->get());
                numSubProblem++;
	}

	auto returnNode = CreateAndRegisterNode<ReturnNode>(storage);;
	
	if(lastOutputCopyTokenUpdateNode) { // a(X, Y, Y).
		returnNode->setInput(lastOutputCopyTokenUpdateNode);
		lastOutputCopyTokenUpdateNode->setLeftOutput(returnNode);
	}

	std::cout<<"<Nr>\t"<<"<Typ>\t"<<"(<LNr> <LPort>)\t"<<"(<RNr> <RPort>)\t"<<"Info"<<std::endl;
	for(auto& kv : storage)  {
		std::cout<<kv.second->toString()<<std::endl;
	};

	// TODO: Memory cleanup => storage.destoryEverything();
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
| END {
	if(currentProblem) { 
		delete currentProblem; 
	}
};

AFTER_HEAD: RULE_FINISHED S
| RULE RULE_FINISHED S;

RULE_FINISHED: DOT {
	if(currentProblem->getCurrentSubProblem()) {
		currentProblem->getCurrentSubProblem()->completeSubProblem();     
	}
	createTree(); 
	delete currentProblem; 
	currentProblem = new Problem();
}

RULE: RULE_OPERATOR TAIL;

HEAD : FACT {
	currentProblem->setHeadCompleted();
};

FACT : NAME OPEN_BRACKET PARAMETER_LIST CLOSE_BRACKET {
#ifdef DEBUG_BISON
	printf("Name: %s\n", $1);
#endif
	if(currentProblem->getHeadCompleted()) {
		currentProblem->getCurrentSubProblem()->setName($1);
	} else {
		currentProblem->setName($1);
	}
};

PARAMETER_LIST : PARAMETER
| PARAMETER COMMA PARAMETER_LIST;

PARAMETER: NAME {
#ifdef DEBUG_BISON
	 printf("Name: %s\n", $1);
#endif

} 
| VARIABLE {
#ifdef DEBUG_BISON
	printf("Variable: %s\n", $1);
#endif
	if(currentProblem->getHeadCompleted()) {
		currentProblem->getCurrentSubProblem()->addVariable($1);
		currentProblem->getCurrentSubProblem()->appendName($1);
		currentProblem->getCurrentSubProblem()->appendName(",");
	} else {
		currentProblem->addVariable($1);
                currentProblem->appendName($1);
                currentProblem->appendName(",");
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
	if(currentProblem->getCurrentSubProblem()) {
		currentProblem->getCurrentSubProblem()->completeSubProblem();
	}
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
