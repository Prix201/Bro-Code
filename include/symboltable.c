#include<stdio.h>
#include<stdlib.h>
#include "unordered_map.c"
#include "../src/parser.tab.h"
extern int yylineno;


typedef struct list{
    int val;
    struct list*next;
}list;

typedef struct{
    char name[70];
    list*occurences;
    int type;
    char address_of_symbol[100];
    int func;
    int size;
}var;


typedef struct{
    var*variables;
    UnorderedMap*address;
    int size;
}symbol_table;

// All Symbol-table function declarations:
symbol_table* create_symbol_table(int capacity);
void add_occurence(var*variable);
void add_variable(symbol_table*table,char*name);
int look_up(symbol_table*table,char*name);
void print_symbol_table(symbol_table*table);
void print_occurences(var variable);
void set_type(symbol_table*table,char*var_name,char*type);
void print_type(int n);

// creates a list of vars i.e the data structure symbol_table
symbol_table* create_symbol_table(int capacity){
    
    symbol_table*temp = (symbol_table*)malloc(sizeof(symbol_table));
    
    temp->variables = (var*)malloc(capacity*sizeof(var));
    
    UnorderedMap*address = create_unordered_map(capacity);
    temp->address = address;
    
    temp->size = 0;

    return temp;
}


// add information- lines of occurence in linked list order
void add_occurence(var*variable){
    list*temp = (list*)malloc(sizeof(list));
    temp->val = yylineno;
    temp->next = NULL; 
    list*head = variable->occurences;

    if(!head)head = temp;
    else {
        while(head->next)head = head->next;
        head->next = temp;
    }
}


// adds variable to the symboltable data-structure
void add_variable(symbol_table*table,char*name){
    
    if(get(table->address,name) != -1){
        int i = get(table->address,name);
        add_occurence(table->variables+i);
        return;
    }
    int i = table->size++;

    put(table->address,name,i);
    var*variable = table->variables+i;
    strcpy(variable->name,name);
    variable->func = 0;


    list*head = (list*)malloc(sizeof(list));
    head->val = yylineno-1;
    head->next = NULL;
    variable->occurences = head;

}

// look_up function that returns -1 if name not found in the symbol_table
int look_up(symbol_table*table,char*name){
    return get(table->address,name);
}


void print_symbol_table(symbol_table*table){
    var*variables = table->variables;

    for(int i = 0 ; i < table->size ; i ++){
        printf("%d|",get(table->address,variables[i].name));
        printf("%s|",variables[i].name);
        print_occurences(variables[i]);
        printf("|");
        print_type(variables[i].type);
        printf("|");
        printf("%s",variables[i].address_of_symbol);
        printf("\n");
    }
}

void print_type(int n){
    if(n == 0)printf("void");
    if(n == 2)printf("int");
    if(n == 3)printf("float");
    if(n == 4)printf("string");
    if(n == 5)printf("list_float");
    if(n == 6)printf("list_int");
    if(n == 7)printf("list_string");
    if(n == 8)printf("function");


}

void print_occurences(var variable){
    list*temp = variable.occurences;
    while(temp){
        printf("%d->",temp->val);
        temp = temp->next;
    }

}

void set_type(symbol_table*table,char*var_name,char*type){
    int i = look_up(table,var_name);

    if(!strcmp("int",type)){
        table->variables[i].type = 2;
    }
    if(!strcmp("float",type)){
        table->variables[i].type = 3;
    }
    if(!strcmp("string",type)){
        table->variables[i].type = 4;
    }
    if(!strcmp("list_float",type)){
        table->variables[i].type = 5;
    }
    if(!strcmp("list_int",type)){
        table->variables[i].type = 6;
    }
    if(!strcmp("list_string",type)){
        table->variables[i].type = 7;
    }
    if(!strcmp("func",type)){
        table->variables[i].type = 8;
    }
}

void set_func(symbol_table*table,char*var_name){
    int i = look_up(table,var_name);
    table->variables[i].func = 1;
}
