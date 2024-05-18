#include <stdio.h>
#include <string.h>
#include "../src/parser.tab.h"


char * New_label(int i,int type){
    char*index;
    index = (char*)malloc(sizeof(char)*4);
    sprintf(index, "%d", i);
    char*label;
    label = (char*)malloc(sizeof(char)*2);

    if(type == 2)strcpy(label,"i");
    if(type == 3)strcpy(label,"f");
    if(type == 4)strcpy(label,"s");
    strcat(label,index);
    return label;
}


char * make_line(int i){
    char*index;
    index = (char*)malloc(sizeof(char)*4);
    sprintf(index, "%d", i);
    char*label;
    label = (char*)malloc(sizeof(char)*4);

    strcpy(label,"L_");
    strcat(label,index);
    return label;
}

int size_of_test(int type){
    if(type == 2)return 32;
    if(type == 3)return 32;
    if(type == 4)return 100;
    return 0;
}



typedef struct stack_char{
    char**array;
    int r;
}stack_char;


stack_char*create_stack(int capacity){
    stack_char*temp = (stack_char*)malloc(sizeof(stack_char));
    
    char**temp2;
    temp2 = (char**)malloc(100*sizeof(char*));
    
    for(int i = 0 ; i < 100 ; i ++){
        temp2[i] = (char*)malloc(100*sizeof(char));
    }
    temp->array = temp2;
    temp->r = 0;


    return temp;
}

char*top_stack(stack_char*flow){
    return flow->array[flow->r-1];
}

void pop_stack(stack_char*flow){
    flow->r--;
}

void push_stack(stack_char*flow,char*str){
    strcpy(flow->array[flow->r++],str);
}

int size_stack(stack_char*flow){
    return flow->r;
}
