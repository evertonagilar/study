//
// Created by evertonagilar on 26/02/23.
//

#include "tarefa.h"

Tarefa::Tarefa(int id): id(id) {

}

Tarefa::Tarefa() {

}

Tarefa::~Tarefa() {

}

int Tarefa::getId() {
    return id;
}

ostream &operator<<(ostream &os, const Tarefa &tarefa) {
    os << "id: " << tarefa.id;
    return os;
}
