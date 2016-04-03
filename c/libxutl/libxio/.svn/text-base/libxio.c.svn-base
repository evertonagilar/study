#include "..\lib\libxinit.h"
#include "libxio.h"
#ifdef __cplusplus
extern "C" {
#endif       

/*
 * Log file utils
 *
*/ 

// global variables
PChar logFileName = NULL;

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

void CALL Zeos_StringToFile(const PChar AFileName, const PChar AStr, BOOL AAppend){
     FILE *arq;
     char opcao[3] = "w";
     if (AFileName != NULL && AStr != NULL){
       if (AAppend == true){
          opcao[0] = 'a';
          opcao[1] = '+';
          opcao[2] = '\0';
       }   
       if ((arq = fopen(AFileName, opcao)) != NULL){
          fputs(AStr, arq);   
          fclose(arq);
       }                
     }         
}     

#ifdef __cplusplus
}
#endif       


