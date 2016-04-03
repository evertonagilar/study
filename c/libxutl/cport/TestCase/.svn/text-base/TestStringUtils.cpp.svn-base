#include <cstdlib>
#include <cstring>
#include <cstdio>
#include <ctime>
#include <iostream>

#ifdef WIN32
#include <windows.h>
#include "..\StringUtils.h"
#include "..\libxinit.h"
#include "..\libxutl.h"
#else
#include "../stringutils.h"
#include "../libxinit.h"
#include "../libxutl.h"
#endif

#define GetTickCount clock()

using namespace std;
using namespace libxutl;

extern "C" StringUtils* CALL CreateStringUtils();

 char* rtrim(char* str)
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


int main(int argc, char *argv[])
{
    char* str = (char*) "Everton de vargas agilar";
    double t1, t2;
    char* str_trim;

    StringUtils* StrUtils = CreateStringUtils();


    // Test ltrim
    t1 = clock();
    str_trim = StrUtils->ltrim(str);
    t2 =clock()-t1;
    printf("%s", str_trim);
    printf("\nTempo: %f\n", t2);

    // Test rtrim
    t1 = clock();
    str = (char*) malloc(200);
    strcpy(str, "   everton de vargas agilar        ");
    str_trim = rtrim(str);
    char s1[10] = "agilar  ";
    str_trim = rtrim(s1);
    t2 = clock()-t1;
    printf("%s", str_trim);
    printf("\nTempo: %f\n", t2);


    system("PAUSE");
    return EXIT_SUCCESS;



}
