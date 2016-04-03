#include <stdio.h>
#include <string.h>
#include <ctype.h>

int next_letra(char* str, int pos_inicial){
  int len_str = strlen(str);
  if (pos_inicial >= 0 && pos_inicial < len_str){
     register int i;
     for (i = pos_inicial; i < len_str; i++){
	register char ch = toupper(str[i]);
	if (ch >= 'A' && ch <= 'Z'){
	  return i;	
        } 
     }	
  }
  return 0;
}

int main(int argc, char *argv[]){
	printf("next_letra: %d\n", next_letra("    !!!+++everton de vargas+++", 6));
	printf("next_letra: %d\n", next_letra("    JOAO da Silva", 0111));

	return 0;
}
