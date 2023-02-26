#include <iostream>
#include "fila_circular.h"

using namespace std;

int main() {
    std::cout << "Web server conceitual!" << std::endl;

    FilaCircular fila(10);

    Tarefa t1(1);
    Tarefa t2(2);
    Tarefa t3(3);
    Tarefa t4(4);
    Tarefa t5(5);
    Tarefa t6(6);

    fila.push(t1);
    fila.push(t2);
    fila.push(t3);
    fila.push(t4);
    fila.push(t5);
    fila.push(t6);

    while (!fila.isEmpty()){
        Tarefa t = fila.pop();
        cout << t << endl;
    }

    return 0;
}
