#include <stdio.h>
#include "../include/symboltable.c"
#include "../include/3ac.c"
#include "parser.tab.h"
#include "lex.yy.c"
#include "../include/x86.c"

extern node*tree;
symbol_table*global;
symbol_table*local[1000];
int table_index = 0;
int class_open = 0;
int suite_type = 0;
char class_name[30];
int Basic_Block = 1;

int int_index = 1;
int float_index = 1;
int string_index = 1;
int bool_index = 1;
int INT_[1000];
float FLOAT_[1000];
char STRING_[100][1000];
int BOOL_[1000];
int index_type = 0;
int size_of_list = 0;
stack_char*flow_start;
stack_char*flow_end;
int global_variable[1000];


int main(void){

    flow_start = create_stack(100);
    flow_end = create_stack(100);

    global = create_symbol_table(1000);
    for(int i = 0 ; i <1000 ; i ++){
        local[i] = create_symbol_table(1000);
        global_variable[i] = 0;
    }

    FILE* parser= freopen("../outputs/Parsing_details.txt","w",stdout);
    yyparse();
    fclose(parser);
    print_it(tree);


    FILE* symbols= freopen("../outputs/Symbol_table.txt","w",stdout);
    printf("GLOBAL_SYMBOL_TABLE:\n\n");
    print_symbol_table(global);
    var*variables = global->variables;

    int j = 0;
    for(int i = 0 ; i < table_index ; i ++){
        while(variables[j].func != 1)j++;
        printf("\n%s:\n",variables[j].name);
        print_symbol_table(local[i]);
        j++;
    }
    fclose(symbols);


    FILE* code= freopen("../outputs/3AC_table.txt","w",stdout);
    printf("%s",tree->_3AC_Code);
    fclose(code);

    FILE* code2= freopen("../outputs/x86_Code.asm","w",stdout);
    printf("%s",create_mips(tree->_3AC_Code));
    fclose(code2);


    return 0;
}
