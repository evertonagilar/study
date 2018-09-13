#include <stdio.h>
#include <stdlib.h>


long get_file_size(FILE *fd);

long get_file_size(FILE *fd) {
    fseek (fd, 0 , SEEK_END);
    long lSize = ftell(fd);
    rewind (fd);
    return lSize;
}
