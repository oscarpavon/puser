
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <sys/stat.h>
#include <stdlib.h>

int main() {
  FILE *file = fopen("hellofasm", "r");
  if (!file) {
    printf("File not found\n");
		_exit(-1);
  }
  struct stat st;
  stat("hellofasm", &st);
  uint64_t size = st.st_size;
	printf("File size %ld\n",size);

	uint8_t* binary = malloc(size);

	memset(binary, 0, size);

	fread(binary, size, 1, file);





	free(binary);
	fclose(file);


  printf("Read elf\n");
  return 0;
}
