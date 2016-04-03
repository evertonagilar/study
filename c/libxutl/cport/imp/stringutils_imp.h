#ifndef _STRINGUTILS_IMP_
#define _STRINGUTILS_IMP_

#ifdef WIN32
#include "..\libxinit.h"
#include "..\stringutils.h"
#else
#include "../libxinit.h"
#include "../stringutils.h"
#endif

namespace libxutl {

 class StringUtilsImp: public StringUtils
 {
     public:
         StringUtilsImp();
         virtual ~StringUtilsImp();

         char* ltrim(char* str);
         char* rtrim(char* str);
         char* trim(char* str);

 };

}

#endif
