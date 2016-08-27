#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

int main(int argc, char *argv[]){
	FILE *fp = fopen(argv[1], "r");
	int number = 0;
	while (!feof(fp)){
		int ch = fgetc(fp);
		if (isdigit(ch)){
			number = 0;
			do {
				number = number * 10 + ch - '0';
				ch = fgetc(fp);
			} while (isdigit(ch));
			printf("Number is %i\n", number);
		}
	}
	
	
}


