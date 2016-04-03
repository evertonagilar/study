#ifndef _STRINGUTILS_H_
#define _STRINGUTILS_H_

#include "libxinit.h"

#ifdef __cplusplus
extern "C" {
#endif       
       
namespace libxutl {

    class StringUtils
    {
     public:
          virtual char* ltrim(char* str) = 0;
          virtual char* rtrim(char* str) = 0;
          virtual char* trim(char* str) = 0;
    };
    
}

#ifdef __cplusplus
}
#endif       

#endif // _STRINGUTILS_H_
