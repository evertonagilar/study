#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdio.h>

/*
  Extrai os números contidos em str1 e insere em str2.
  Retorna o mesmo parâmetro str2.
*/
char* ExtraiNumero(char * str1, char * str2){
  if (str1 != NULL){
    int str_len = strlen(str1);
    char *result = str2;
    int i;

    for (i = 0; i < str_len; i++){
      if (isdigit(*str1)){
        *str2 = *str1;
	str2++;
      }
      str1++;
    } 	

    *str2 = '\0';
    return result;	
  }		
  else
    return NULL;
}

int main(int argc, char *argv[]){
  char string[100];	
  int i;
  for (i = 0; i <= 1900; i++){
	  puts(ExtraiNumero("everton 4234.00   \n\n", string));
	  puts(ExtraiNumero("everton 1   1   1\n   1 1234\n\n", string));
  }	
  return 0;	
}
