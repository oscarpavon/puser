#include <math.h>
#include <stdlib.h>

#define O_RDONLY	     00
#define O_WRONLY	     01
#define O_RDWR		     02
#define O_CREAT	    0100

//O_APPEND 

# define SEEK_SET	0	/* Seek from beginning of file.  */
# define SEEK_CUR	1	/* Seek from current position.  */
# define SEEK_END	2	/* Seek from end of file.  */

#define STDOUT 1

typedef unsigned int uint;

extern void say_hello();
extern void write(unsigned int,void*,unsigned int);
extern void close(unsigned int);
extern unsigned int sum(unsigned int);
extern unsigned int open(void*, int);
extern unsigned int read(unsigned int, void*, unsigned int);
extern uint lseek(uint, uint, uint);

uint current_line = 0;
uint current_parsed_line_char_counter = 0;

int string_length(const char* string){
	const char* position = string;
	while(*position++)
		;
	return position - string - 1;
}

void print(char*string){
  uint string_count = string_length(string);
  write(STDOUT,string,string_count);
}

void *set_memory(void *pointer, int value, size_t size)
{
	char *to = pointer;

	for (size_t i = 0; i < size; ++i)
		*to++ = value;
	return pointer;
}

void print_char(char character){
  char buff[2];
  buff[0] = '\0';
  buff[1] = '\0';
  buff[0] = character;
  print(buff);
}

void print_uint(uint number){

	char buf[16];
	set_memory(buf, 0, 16);		
	char *pos = buf;

	do {
		const unsigned d = number % 10;

		number = number / 10;
		if (d < 10)
			*pos = d + '0';
		else
			*pos = d - 10 + 'A';
		++pos;
	} while (number);

	for (char *l = buf, *r = pos - 1; l < r; ++l, --r) {
		const char c = *l;

		*l = *r;
		*r = c;
	}

  print(buf);
}


void string_copy(char*destination,char*string,uint count){
  for(uint i = 0;i<count;i++){
    destination[i] = string[i];
  }
}


uint get_file_size(char* string){
  uint file_size = 0;
  uint file_descriptor = open(string, O_RDONLY);
  file_size = lseek(file_descriptor, 0, SEEK_END);
  close(file_descriptor);
  return file_size;
}


void print_in_file(uint file, char* string){
  uint count = string_length(string);
  write(file,string,count);
}

uint data_position = 0;
void print_in_buffer(char*buffer, char*string){
  char* current_position = &buffer[data_position];
  uint count = string_length(string);
  for(uint i = 0;i<count;i++){
    current_position[i] = string[i];
    data_position++;
  }

}

void create_data_section(char*data){
  print_in_buffer(data,"section '.data'\n");

  print_in_buffer(data,"ss db 'asdfas'\n");


  print_in_buffer(data, "\0");
}

uint string_compare(char*string,char*string2){
  uint count = string_length(string);
  uint cout2 = string_length(string2);
  if(count!=cout2){
    return 0;
  }
  for(uint i = 0;i<count;i++){
    if(string[i]!=string2[i]){
      return 0;
    }
  }
  return 1;
}

void parse_char(char*string){
  
}
void init_buffer(char*buffer, uint count){
  for(uint i = 0;i<count+1;i++){
    buffer[i] = '\0';
  }
}

enum error{
  comma = 1,
  equal = 2,
  single_quote = 3
};
void print_character_line_position(){
  print("\n");
  while (current_parsed_line_char_counter > 0) {
    print(" ");
    current_parsed_line_char_counter--;
  }
  print("^");
}

void print_error(char*line, enum error error){
  print("ERROR ");
  print("Line: ");
  print_uint(current_line);
  print("\n");
  print(line);

  switch (error) {
  case comma:
    print("<= Expected ;");
    print("\n");
    break;
  case equal:
    print_character_line_position();
    print("= Expected \"=\"");
    print("\n");
    break;
  case single_quote:
    print_character_line_position();
    print("= Expected \"\'\"");
    print("\n");
    break;
  default:
    print("Undefined error");
    print("\n");
    break;
  }
}

void parse_char_type(char*string){
  uint line_char_counter = 0;
  uint word_counter = 0;
  
  uint count = string_length(string);
  for(uint i = 0;i<count;i++){
    if(string[i]!=' '){
      word_counter++;
      line_char_counter++;
    }else{
      line_char_counter++;
      break;
    }
  }

  char word[word_counter+1];
  init_buffer(word, word_counter);
  
  string_copy(word,string,word_counter);

  word_counter=0;


  if(string_compare(word,"char")==1){
    //print("got char\n"); 
  }

  int found_word = 0;
  for(int i = line_char_counter; i < count; i++){
    if(string[i]==' '){
      if(found_word==1)
        break;
      line_char_counter++;
      continue;
    }else{
      found_word = 1;
      word_counter++;
      line_char_counter++;
    }
  }

  
  char variable[word_counter+1];
  init_buffer(variable, word_counter);
  
  string_copy(variable,&string[line_char_counter-word_counter],word_counter);

  char in_char; 
  line_char_counter++;

  for(int i = line_char_counter; i < count; i++){
    if(string[i]==' ' || string[i] == '\t'){
      line_char_counter++;
      continue;
    }
    if(string[i]!='='){
      current_parsed_line_char_counter = line_char_counter;
      print_error(string, equal);
      return;

    }else{
      line_char_counter++;
      break;
    }
  }

  for (int i = line_char_counter; i < count; i++) {

    if (string[i] == ' ' || string[i] == '\t') {
      line_char_counter++;
      continue;
    }
    if (string[i] != '\'') {
      current_parsed_line_char_counter = line_char_counter;
      print_error(string, single_quote);
      line_char_counter++;
      return;
    } else {
      in_char = string[i+1]; // result
      line_char_counter++;
      if (string[i + 2] != '\'') {//i+2 is the char value plus single quote
        current_parsed_line_char_counter = line_char_counter+1;
        print_error(string, single_quote);
      }
      break;
    }
  }



  print(variable);
  print(" db ");
  print_char(in_char);
  print("\n");


}

void parse_comma(char*string){
  uint count = string_length(string);
 
  if(string[count-1] != ';'){
      print_error(string,comma);
      return;
  }

  
  parse_char_type(string);
}

void parse_line(char*string){
  parse_comma(string);//not parse the line without comma
}

uint get_lines_of_code(char*source_code){
  uint line_of_code = 1;//we assume we have unless one line of code
  int source_char_count = string_length(source_code);
  uint line_char_count = 0;
  uint global_char_count = 0;

  for(uint i = 0; i<source_char_count;i++){
    current_line=line_of_code;
    if(source_code[i] == '\n'){
      if(line_char_count==1){
        line_of_code++;
        global_char_count++;
        continue;
      }
      if(line_of_code!=1)
        line_char_count--;//enter

      char line[line_char_count+1];
      init_buffer(line, line_char_count);
      string_copy(line,&source_code[global_char_count-line_char_count],line_char_count);
      parse_line(line);

      line_char_count=0;
      
      line_of_code++;
    }
    line_char_count++;
    global_char_count++;
  }
  return line_of_code;
}

int main(int argument_count , char* argumets[]){
  char* source = argumets[1];
  int source_char_count = string_length(source);

  uint source_size = get_file_size(source); 

  char source_code[source_size];
  uint file_descriptor = open(source, O_RDONLY);
  read(file_descriptor,source_code,source_size);
  close(file_descriptor);
 
  uint lines_of_code = 0;
  lines_of_code = get_lines_of_code(source_code);

  print("Lines of code parsed: ");
  print_uint(lines_of_code);
  print("\n");

  char* data_section = malloc(256);
  create_data_section(data_section);

  uint out = open("out.s", O_WRONLY | O_CREAT);

  print_in_file(out, "format ELF64\n");
  print_in_file(out, "section '.text' executable\n");
  print_in_file(out, "\tpublic _start\n");

  print_in_file(out, "_start:\n");
  
  print_in_file(out, "\t;;exit\n\tmov rax, \
      60\n\txor rdi,rdi\n\tsyscall\n");

  print_in_file(out, data_section);

  close(out);
  free(data_section);
  
  return 0;

}
