//
// Created by evertonagilar on 26/02/23.
//

#include <cstdlib>
#include "fila_circular.h"
#include "tarefa.h"
#include <exception>

using namespace std;

FilaCircular::FilaCircular(int capacidade): size(capacidade), primeiro(0), ultimo(0) {
    this->fila = static_cast<Tarefa *>(malloc(sizeof(Tarefa *)));
}

FilaCircular::~FilaCircular() {
    free(this->fila);
}

void FilaCircular::push(const Tarefa &tarefa) {
    if (isFull()){
        throw FilaCircularCheiaException();
    }
    fila[ultimo % size] = tarefa;
    ultimo++;
}

Tarefa &FilaCircular::pop() {
    if (isEmpty()){
        throw FilaCircularEmptyException();
    }
    Tarefa &tarefa = fila[primeiro % size];
    primeiro++;
    return tarefa;
}

bool FilaCircular::isFull() {
    return getCount() == size;
}

bool FilaCircular::isEmpty() {
    return primeiro == ultimo;
}

int FilaCircular::getCount() {
    return ultimo - primeiro;
}
