#ifndef _LIBXUTL_H_
#define _LIBXUTL_H_

#include <stdio.h>
#include <time.h>
#include "libxinit.h"
#include "stringutils.h"

// global variables
PChar logFileName = NULL;


#ifdef __cplusplus
extern "C" {
#endif       
       
namespace libxutl {

  StringUtils* CALL CreateStringUtils(); 

};

// Date time utils

PChar CALL Zeos_StrDate(time_t * timeptr);
PChar CALL Zeos_StrDateTime(time_t * timeptr);

// Log file utils

void Zeos_SetLogFileName(const PChar ALogFileName);
PChar Zeos_GetLogFileName();
int CALL Zeos_WriteAlert(const PChar AMessage);

#ifdef __cplusplus
}
#endif       


#endif /* _LIBXUTL_H_ */

