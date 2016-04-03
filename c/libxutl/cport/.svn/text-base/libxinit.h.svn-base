#ifndef _LIBXINIT_H_
#define _LIBXINIT_H_

#define BUILDING_DLL    1
#define ANSI_CHAR       1

#ifdef WIN32
    #ifdef BUILDING_DLL
        #define CALL  __stdcall __declspec (dllexport) 
    #else
        #define CALL __stdcall __declspec (dllimport)
    #endif
#else
    #define CALL
#endif

#ifdef ANSI_CHAR
typedef char Char;
typedef char* PChar;
#else
typedef wchar_t Char;
typedef wchar_t* PChar;
#endif

#endif // _LIBXINIT_H_
