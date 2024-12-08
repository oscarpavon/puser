
#include <sys/mman.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdint.h>
#include <unistd.h>
#include <sys/stat.h>

int main(){
  
	char binary_to_load[] = "binaryc";
	int my_file = open(binary_to_load, O_RDONLY);

  struct stat my_stat;
  
	stat(binary_to_load, &my_stat);

  uint64_t my_size = my_stat.st_size;

	void* my_binary = mmap(NULL,my_size,PROT_EXEC|PROT_READ,MAP_PRIVATE,my_file,0);

	//( *( ( void (**)(void) )&my_binary) )();
	
	int result = ( *( ( int (**)(void) )&my_binary) )();
	printf("The Result %i\n",result);
}
