#ifndef _LIBXIO_H_
#define _LIBXIO_H_

#include "..\lib\libxinit.h"

#ifdef __cplusplus
extern "C" {
#endif       

void CALL Zeos_SetLogFileName(const PChar ALogFileName);
PChar CALL Zeos_GetLogFileName();
int CALL Zeos_WriteAlert(const PChar AMessage);
void CALL Zeos_StringToFile(const PChar AFileName, const PChar AStr, BOOL AAppend);



BOOL APIENTRY DllMain (HINSTANCE hInst     /* Library instance handle. */ ,
                       DWORD reason        /* Reason this function is being called. */ ,
                       LPVOID reserved     /* Not used. */ )
{
    switch (reason)
    {
      case DLL_PROCESS_ATTACH:
        break;

      case DLL_PROCESS_DETACH:
        break;

      case DLL_THREAD_ATTACH:
        break;

      case DLL_THREAD_DETACH:
        break;
    }

    /* Returns TRUE on success, FALSE on failure */
    return TRUE;
}

#ifdef __cplusplus
}
#endif       

#endif /* _LIBXIO_H_ */
