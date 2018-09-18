#include <stdio.h>
#include <stdlib.h>
#include "ci_utils.h"


long ci_get_file_size(FILE *fd) {
    fseek (fd, 0 , SEEK_END);
    long lSize = ftell(fd);
    rewind (fd);
    return lSize;
}
