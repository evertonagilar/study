//
// Created by evertonagilar on 26/02/23.
//

#ifndef WEBSERVER_DEMO_TLISTACIRCULAR_H
#define WEBSERVER_DEMO_TLISTACIRCULAR_H


#include "tarefa.h"
#include "WebServerException.h"

class FilaCircularException : WebServerException{

};

class FilaCircularCheiaException : FilaCircularException{

};

class FilaCircularEmptyException : FilaCircularException{

};

class FilaCircular {
private:
    int size;
    int primeiro;
    int ultimo;
    Tarefa *fila;
public:
    FilaCircular(int capacidade);
    ~FilaCircular();

    void push(const Tarefa &tarefa);
    Tarefa & pop();
    bool isFull();
    bool isEmpty();
    int getCount();
};


#endif //WEBSERVER_DEMO_TLISTACIRCULAR_H
