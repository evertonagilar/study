/** 
 *  lixinit.h
 *
 *  Arquivo de inicialização para projetos C/C++
 *
 *  Finalidade: Inclua este arquivo de inicialização nos projetos. Este
 *  arquivo contém configurações para compilação em C/C++, funções e tipos
 *  utilizados nos projetos.
 */

#ifndef _LIBXINIT_H_
#define _LIBXINIT_H_

#define BUILDING_DLL    1
#define ANSI_CHAR       1

#ifdef WIN32
    #ifdef BUILDING_DLL
        #define CALL  __stdcall __declspec (dllexport) 
    #else
        #define CALL  __stdcall __declspec (dllimport)
    #endif
#else
    #define CALL
#endif

#ifdef __cplusplus
    #include <cstdlib>
    #include <cstring>
    #include <ctime>
    #include <cstdio>
    #include <windows.h>    
#else
    #include <stdlib.h>
    #include <string.h>
    #include <time.h>
    #include <stdio.h>
    #include <windows.h>

    #undef true
    #undef false
    #define true -1
    #define false 0
#endif 

#ifdef __cplusplus
using namespace std;
#endif

#ifdef ANSI_CHAR
typedef char Char;
typedef char* PChar;
#else
typedef wchar_t Char;
typedef wchar_t* PChar;
#endif

/* Utils */
PChar Zeos_ltrim(PChar str);
PChar Zeos_StrDate(time_t * timeptr);
PChar Zeos_StrDateTime(time_t * timeptr);

#endif // _LIBXINIT_H_
