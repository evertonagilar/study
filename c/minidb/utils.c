//
// Created by agilar on 26/02/2020.
//

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

bool bx_filesize(FILE *fd){
    size_t curr_pos = ftell(fd);
    fseek(fd, 0, SEEK_END);
    size_t result = ftell(fd);
    fseek(fd, curr_pos, SEEK_SET);
    return result;
}

void *bx_malloc(size_t size){
    void* ptr = malloc(size);
    if (!ptr){
        perror("Não foi possível alocar memória.");
    }
    return ptr;
}