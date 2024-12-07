
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <sys/stat.h>
#include <stdlib.h>
#include "elf.h"

static void elf_get_image_size(
	struct ElfHeader* kernel_header,
	struct ElfProgramHeader* program_headers,
	uint64_t alignment,
	uint64_t *out_begin,
	uint64_t *out_end)
{
	*out_begin = UINT64_MAX;
	*out_end = 0;
	for (size_t i = 0; i < kernel_header->program_header_number_of_entries; ++i) {
		struct ElfProgramHeader *program_header = &program_headers[i];
		printf("Offset %lx\n",program_header->offset);
		uint64_t program_header_begin, program_header_end;
		uint64_t align = alignment;

		if (program_header->type != PT_LOAD){
			continue;
		}

		if (program_header->alignment > align)
			align = program_header->alignment;

		program_header_begin = program_header->virtual_address;
		program_header_begin &= ~(align - 1);
		if (*out_begin > program_header_begin)
			*out_begin = program_header_begin;

		program_header_end = program_header->virtual_address +
      program_header->memory_size + align - 1;
		program_header_end&= ~(align - 1);
		if (*out_end < program_header_end)
			*out_end = program_header_end;
	}
}

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


	uint64_t page_size = 4096;
	uint64_t image_begin;
	uint64_t image_end;
	uint64_t image_size;
	uint64_t image_address;

	struct ElfHeader* header = (struct ElfHeader*)binary;
	uint8_t* programs = binary+64;
	struct ElfProgramHeader* program_headers = (struct ElfProgramHeader*)programs;
	
	printf("Entry point address %lx\n",header->entry);
	printf("Programs count %d\n",header->program_header_number_of_entries);

	printf("program header 1 size %lx\n",program_headers->file_size);
	struct ElfProgramHeader* program_header2 = &program_headers[1];
	printf("program header 2 size %lx\n",program_header2->file_size);


	elf_get_image_size(header,
			program_headers, 
			page_size, &image_begin, &image_end);

	image_size = image_end - image_begin;
	printf("Image size: %ld\n",image_size);


	free(binary);
	fclose(file);


  printf("Read elf\n");
  return 0;
}
