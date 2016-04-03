#include <cstdlib>
#include <cstdlib>
#include <cstring>
#include <cstdio>

#include "stringutils_imp.h"

#ifdef WIN32
#include "..\libxinit.h"
#else
#include "../libxinit.h"
#endif

namespace libxutl {

 StringUtilsImp::StringUtilsImp()
 {
 }

 StringUtilsImp::~StringUtilsImp()
 {
 }

 char* StringUtilsImp::ltrim(char* str)
 {
   if (str == NULL) return NULL;
   register char* p = str;
   while (*p == ' ') p++;
   char* Result = (char*) malloc(strlen(p));
   strcpy(Result, p);
   return Result;
 }

 char* StringUtilsImp::rtrim(char* str)
 {
   if (str == NULL) return NULL;
   register char* p = str+strlen(str)-1;
   while (p >= str && *p == ' ') {
         *p = '\0';
         p--;
   }
   int str_size = strlen(str);
   char* Result = (char*) malloc(str_size);
   strcpy(Result, str);
   return Result;
 }

 char* StringUtilsImp::trim(char* str)
 {
    return NULL;
 }

} // libxutl





