#ifdef WIN32  /* Windows Plataform */
#include <windows.h>
#include "libxutl.h"
#include "imp\stringutils_imp.h"
#else         /* Linux Plataform */
#include "libxutl.h"
#include "imp/stringutils_imp.h"
#endif

#include <stdio.h>
#include <time.h>
#include <stdlib.h>

#ifdef __cplusplus
extern "C" {
#endif       

//////////// ZEOS FRAMEWORK ////////////////////

namespace libxutl {

 StringUtils* CreateStringUtils()
 {
   return new StringUtilsImp();
 }
 
};

//////////// ZEOS FUNCTIONS ////////////////////

/*
 *
 * String utils
 *
 *
*/ 

PChar CALL Zeos_ltrim(PChar str)
{
    if (str == NULL) return NULL;
    register PChar p = str;
    while (*p == ' ') p++;
    PChar Result = (PChar) malloc(strlen(p));
    strcpy(Result, p);
    return Result;
}

/*
 *
 * Date time utils
 *
 *
*/ 

PChar CALL Zeos_StrDate(time_t * timeptr){
    if (timeptr == NULL)
    {
       timeptr = (time_t*) malloc(sizeof(time_t*));
       time(timeptr);
    }
    struct tm * timeinfo = localtime(timeptr);              
    PChar result = (PChar) malloc(sizeof(PChar)*9);
    sprintf(result, "%02d/%02d/%04d\0", timeinfo->tm_mday, timeinfo->tm_mon, timeinfo->tm_year+1900);
    return result;    
}      

PChar CALL Zeos_StrDateTime(time_t * timeptr){
    if (timeptr == NULL)
    {
       timeptr = (time_t*) malloc(sizeof(time_t*));
       time(timeptr);
    }
    struct tm * timeinfo = localtime(timeptr);              
    PChar result = (PChar) malloc(sizeof(PChar)*20);
    sprintf(result, "%02d/%02d/%04d %02d:%02d:%02d\0", timeinfo->tm_mday, 
      timeinfo->tm_mon, timeinfo->tm_year+1900, timeinfo->tm_hour, 
      timeinfo->tm_min, timeinfo->tm_sec);
    return result;    
}      

/*
 *
 * Log file utils
 *
 *
*/ 

void CALL Zeos_SetLogFileName(const PChar ALogFileName){
     logFileName = ALogFileName;
}     

PChar CALL Zeos_GetLogFileName(){
      return logFileName;      
}

int CALL Zeos_WriteAlert(const PChar AMessage){
     FILE *arq;
     if (logFileName != NULL && (arq = fopen(logFileName, "a+")) != NULL) {
        PChar datestr = Zeos_StrDateTime(NULL);
        fprintf(arq, "%s %s\n", datestr, AMessage); 
        fclose(arq);
        return 1;  
     }
     else 
     {
        return 0;
     }               
}     


#ifdef WIN32

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

#endif

#ifdef __cplusplus
}
#endif       

