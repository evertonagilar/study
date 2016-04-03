#include "libxinit.h"

#ifdef __cpluplus
using std;
#endif

/*
 * String utils
 *
*/ 

PChar Zeos_ltrim(PChar str)
{
    if (str == NULL) return NULL;
    register PChar p = str;
    while (*p == ' ') p++;
    PChar Result = (PChar) malloc(strlen(p));
    strcpy(Result, p);
    return Result;
}

/*
 * Date time utils
 *
*/ 

PChar Zeos_StrDate(time_t * timeptr){
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

PChar Zeos_StrDateTime(time_t * timeptr){
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

