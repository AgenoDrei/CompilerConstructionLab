#pragma once

#include "NodeStorage.h"

#include "BaseNode.h"
#include "ApplyNode.h"
#include "ReturnNode.h"
#include "UpdateNode.h"
#include "GroundNode.h"
#include "IndependenceNode.h"
#include "EntryNode.h"
#include "CopyNode.h"
#include "StringNode.h"

template<typename T>
T* CreateAndRegisterNode(NodeStorage& storage) {
        T* result = new T();
        storage.insert(std::pair<int, BaseNode*>(result->getID(), result));
        return result;
}


