//
// Created by evertonagilar on 26/02/23.
//

#ifndef WEBSERVER_DEMO_TAREFA_H
#define WEBSERVER_DEMO_TAREFA_H

#include <ostream>

using namespace std;

class Tarefa {
private:
    int id;
public:
    Tarefa(int id);
    Tarefa();
    ~Tarefa();
    int getId();

    friend ostream &operator<<(ostream &os, const Tarefa &tarefa);
};


#endif //WEBSERVER_DEMO_TAREFA_H
