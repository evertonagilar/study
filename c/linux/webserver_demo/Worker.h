//
// Created by evertonagilar on 27/02/23.
//

#ifndef WEBSERVER_DEMO_WORKER_H
#define WEBSERVER_DEMO_WORKER_H

#include <pthread.h>

using namespace std;

class Worker {
private:
    pthread_t *thread;

    static void *run(void *args);

public:
    Worker();
    ~Worker();
};


#endif //WEBSERVER_DEMO_WORKER_H
