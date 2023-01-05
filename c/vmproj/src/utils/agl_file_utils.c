//
// Created by evertonagilar on 29/05/22.
//

#include <stdio.h>
#include <fcntl.h>
#include <errno.h>
#include <stdlib.h>

FILE *agl_openFileName(const char *filename, const char *modes){
    FILE *fd = fopen(filename, modes);
    if (!fd) {
        printf("Não foi possível abrir arquivo %s. Code: %d", filename, errno);
        exit(-1);
    }
    return fd;
}

size_t agl_getFileSize(FILE *fd){
    size_t current = ftell(fd);
    fseek(fd, 0, SEEK_END);
    size_t result =  ftell(fd);
    fseek(fd, current, SEEK_SET);
    return result;
}

size_t agl_getFileSizeByFileName(const char *filename) {
    FILE *fd = agl_openFileName(filename, "r");
    size_t result = agl_getFileSize(fd);
    fclose(fd);
    return result;
}

void agl_writeFileAll(const char *filename, void *buf, size_t size){
    FILE *fd = agl_openFileName(filename, "w");
    fwrite(buf, size, 1, fd);
    fclose(fd);
}

size_t agl_readFileAll(const char *filename, void *buf, size_t size){
    FILE *fd = agl_openFileName(filename, "r");
    size_t bytesRead = fread(buf, 1, size, fd);
    fclose(fd);
    return bytesRead;
}
