#ifndef __ELF_H__
#define __ELF_H__

#include <stddef.h>
#include <stdint.h>

// Basic ELF file types (e_type)
static const uint16_t ET_NONE = 0;
static const uint16_t ET_REL = 1;
static const uint16_t ET_EXEC = 2;
static const uint16_t ET_DYN = 3;
static const uint16_t ET_CORE = 4;

// Indexes of various parts inside e_ident
static const size_t EI_MAG0 = 0;
static const size_t EI_MAG1 = 1;
static const size_t EI_MAG2 = 2;
static const size_t EI_MAG3 = 3;
static const size_t EI_CLASS = 4;
static const size_t EI_DATA = 5;
static const size_t EI_VERSION = 6;
static const size_t EI_OSABI = 7;
static const size_t EI_ABIVERSION = 8;
static const size_t EI_PAD = 9;

// A few of the defined machine types (e_machine)
static const uint16_t EM_X86_64 = 62;
static const uint16_t EM_AARCH64 = 183;

// Possible values of e_ident[EI_CLASS]
static const unsigned char ELFCLASSNONE = 0;
static const unsigned char ELFCLASS32 = 1;
static const unsigned char ELFCLASS64 = 2;

// Possible values of e_ident[EI_DATA]
static const unsigned char ELFDATANONE = 0;
static const unsigned char ELFDATA2LSB = 1;
static const unsigned char ELFDATA2MSB = 2;

struct ElfHeader {
    unsigned char e_ident[16];
    uint16_t type;
    uint16_t machine;
    uint32_t version;
    uint64_t entry;
    uint64_t program_header_offset;//e_phoff;
    uint64_t e_shoff;
    uint32_t flags;
    uint16_t header_size;
    uint16_t program_header_entry_size;//e_phentsize;
    uint16_t program_header_number_of_entries;//e_phnum;
    uint16_t e_shentsize;
    uint16_t e_shnum;
    uint16_t e_shstrndx;
};

// A few of the defined program header types (e_type)
static const uint32_t PT_NULL = 0;
static const uint32_t PT_LOAD = 1;
static const uint32_t PT_DYNAMIC = 2;
static const uint32_t PT_INTERP = 3;
static const uint32_t PT_NOTE = 4;
static const uint32_t PT_SHLIB = 5;
static const uint32_t PT_PHDR = 6;
static const uint32_t PT_TLS = 7;

// Segment premissions (e_flags)
static const uint32_t PF_X = 1;
static const uint32_t PF_W = 2;
static const uint32_t PF_R = 4;

struct ElfProgramHeader {
    uint32_t type;
    uint32_t flags;
    uint64_t offset;
    uint64_t virtual_address;
    uint64_t program_address;
    uint64_t file_size;
    uint64_t memory_size;
    uint64_t alignment;
};

#endif  // __ELF_H__
