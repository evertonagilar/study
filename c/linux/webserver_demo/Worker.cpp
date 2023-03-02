//
// Created by evertonagilar on 27/02/23.
//

#include <cstdlib>
#include <error.h>
#include <cstdio>
#include "Worker.h"

Worker::Worker() {
    int ret = pthread_create(thread, nullptr, run, nullptr);
    if (ret != 0){
        perror("Não foi possível criar worker");
    }

}

void *Worker::run(void *args) {
    return nullptr;
}
