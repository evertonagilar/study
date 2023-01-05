//
// Created by evertonagilar on 05/01/23.
//

#include <stdio.h>
#include "agl.h"

int main(int argc, char **argv) {
    printf("Agilar Compiler Runtime(%ld bits)\n", sizeof(long) * 8);

    if (argc < 2) {
        printf("Uso: vmproj file\n");
        return -1;
    }

    char *programFileName = argv[1];
    agl_vm_t *vm = agl_vm_create(programFileName, true);
    agl_vm_free(vm);

    return 0;
}
