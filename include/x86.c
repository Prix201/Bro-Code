#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../src/parser.tab.h"
extern symbol_table*global;
extern symbol_table*local[1000];
extern int table_index;
extern int int_index;
extern char * New_label();
extern node*tree;
extern int global_variable[];


int line_index = 0;
char func_x86[50000];
int func_open = 0;
int param_no = 1;
int func_count = 0;
int return_no = 0;
char temp[210];
char func_name[200];


void add_strings(node*tree,char*sol);
char* readUntilNewline(const char* input);
char* read_tac_lines();
void perform(char*task,char*sol);
char*create_mips(char*tac);
void perform_if(char * task,char*sol);
void assign(char * arg1, char * arg2, char * arg3,char*sol);
void op(char * arg1, char * arg2, char * arg3, char * arg4, char * arg5,char*sol);
void print_krte_he(char* arg,char*sol);
void goto_next_line(char * task,char*sol);
void make_func(char * task,char*sol);
void make_next_line(char * task,char*sol);
void empty_stack(char * sol);
void add_to_stack(char * sol);
void array_traverse(char*arg1,char*arg2,char*arg4,char*sol);

void array_traverse(char*arg1,char*arg2,char*arg4,char*sol){
    // char temp[2000];
    arg4[strlen(arg4)-1] = '\0';
    sprintf(temp,"\taccess_list %s,%s,%s\n",arg1,arg2,arg4+1);
    strcat(sol,temp);
}


void empty_stack(char * sol){

    strcat(sol,"\tcall popping_algo\n");

}

void add_to_stack(char * sol){

    strcat(sol,"\tcall pushing_algo\n");

}



void goto_next_line(char * task,char*sol){
    // char temp[2000];
    sprintf(temp,"\tjmp %s\n",task);
    strcat(sol,temp);
}

void make_func(char * task,char*sol){
    // char temp[200];
    sprintf(temp,"%s:\n",task);
    strcpy(func_name,task);
    strcat(func_x86,temp);
    func_open = 1;
}

void make_next_line(char * task,char*sol){
    // char temp[200];
    sprintf(temp,"%s:\n",task);
    strcat(sol,temp);
}




void assign(char * arg1, char * arg2, char * arg3,char*sol){

    if(arg3[0] == '['){
        // char temp[200];
        arg3[strlen(arg3)-1] = '\0';
        sprintf(temp,"\tset_pointer %s,%s\n",arg1,arg3+1);
        strcat(sol,temp);
        return;
    }




    if(!strcmp(arg3,"popparam")){
        // char temp[200];
        sprintf(temp,"\tmov [%s],r8\n",arg1);
        strcat(sol,temp);
        return;
    }
    
    if(arg2[0]!='=')return;
    if(arg1[0] == 's')return;
    // char temp[200];

    if(arg3[0] == '-'){
        if('0' <= arg3[1] && arg3[1] <= '9')sprintf(temp,"\tset_int %s,-%d\n",arg1,atoi(arg3+1));
        else {
            sprintf(temp,"\tnegate %s\n",arg3+1);
            strcat(sol,temp);
            sprintf(temp,"\tset_int_from_register %s,%s\n",arg1,arg3+1);

        }
        
    }
    else if('0' <= arg3[0] && arg3[0] <= '9')sprintf(temp,"\tset_int %s,%d\n",arg1,atoi(arg3));
    else sprintf(temp,"\tset_int_from_register %s,%s\n",arg1,arg3);
    strcat(sol,temp);
}

void print_krte_he(char* arg,char*sol){
    int i = 0;
    while(arg[i] == ' ')i++;
    arg[strlen(arg)] = '\0';

    char temp[200];
    if(arg[i] == 's')sprintf(temp,"\tprint_string %s\n",arg + i);
    else if(arg[i] == 'i')sprintf(temp,"\tprint_int [%s]\n",arg + i);
    strcat(sol,temp);

}


void op(char arg1[], char arg2[], char arg3[], char arg4[], char arg5[],char*sol){
    if(arg2[0] != '=')return;
    // char temp[200];
    if(arg4[0] == '+')sprintf(temp,"\tadd_int %s,%s,%s\n",arg1,arg3,arg5);
    else if(!strcmp(arg4,"-"))sprintf(temp,"\tsub_int %s,%s,%s\n",arg1,arg3,arg5);
    else if(!strcmp(arg4,"*"))sprintf(temp,"\tmul_int %s,%s,%s\n",arg1,arg3,arg5);
    else if(!strcmp(arg4,"/"))sprintf(temp,"\tdiv_int %s,%s,%s\n",arg1,arg3,arg5);
    else if(!strcmp(arg4,"%%"))sprintf(temp,"\tmod_int %s,%s,%s\n",arg1,arg3,arg5);
    else if(!strcmp(arg4,"&"))sprintf(temp,"\tand_bitwise_int %s,%s,%s\n",arg1,arg3,arg5);
    else if(!strcmp(arg4,"^"))sprintf(temp,"\txor_bitwise_int %s,%s,%s\n",arg1,arg3,arg5);
    else if(!strcmp(arg4,"|"))sprintf(temp,"\tor_bitwise_int %s,%s,%s\n",arg1,arg3,arg5);
    else if(!strcmp(arg4,"<"))sprintf(temp,"\tless_than %s,%s,%s\n",arg1,arg3,arg5);
    else if(!strcmp(arg4,">"))sprintf(temp,"\tgreater_than %s,%s,%s\n",arg1,arg3,arg5);
    else if(!strcmp(arg4,"<="))sprintf(temp,"\tless_than_equal %s,%s,%s\n",arg1,arg3,arg5);
    else if(!strcmp(arg4,">="))sprintf(temp,"\tgreater_than_equal %s,%s,%s\n",arg1,arg3,arg5);
    else if(!strcmp(arg4,"=="))sprintf(temp,"\tequal_comp %s,%s,%s\n",arg1,arg3,arg5);

    
    strcat(sol,temp);

}

void perform_if(char * task,char*sol){
    char arg1[30];
    int k = 0;
    int j = 0;

    while(task[k] == ' ')k++;
    while(task[k] != ' '){
        arg1[j++] = task[k++];
    }
    arg1[j] = '\0';

    while(task[k] != 'L')k++;

    char arg2[30];
    int i = 0;
    while(task[k])arg2[i++] = task[k++];
    arg2[i] = '\0';

    // char temp[200];
    sprintf(temp,"\tmov rax,[%s]\n",arg1);
    strcat(sol,temp);

    sprintf(temp,"\tmov rbx,0\n");
    strcat(sol,temp);

    sprintf(temp,"\tcmp rax,rbx\n");
    strcat(sol,temp);

    sprintf(temp,"\tje %s\n",arg2);
    strcat(sol,temp);
}







void add_strings(node*tree,char*sol){
    if(!tree)return;
    if(!strcmp(tree->name,"STRING")){
        // char temp[1000];
        sprintf(temp,"\t%s db %s,10,0\n",tree->value_address,tree->value);
        strcat(sol,temp);
    }

    for(int i = 0 ; i < tree->no_of_childs ; i ++){
        add_strings(tree->child_nodes[i],sol);
    }
}
char* readUntilNewline(const char* input) {
    int length = strlen(input);
    char* result = (char*)malloc((length + 1) * sizeof(char)); 
    if (result == NULL) {
        fprintf(stderr, "Memory allocation failed.\n");
        exit(1);
    }

    int i;
    for (i = 0; i < length; i++) {
        if (input[i] == '\n') {
            break;
        }
        result[i] = input[i];
    }
    result[i] = '\0'; // Null-terminate the string

    return result;
}
char* read_tac_lines(){
    if(tree->_3AC_Code[line_index] == '\n'){line_index++;return "";}
    char*sub;
    sub = readUntilNewline(tree->_3AC_Code+line_index);
    line_index += strlen(sub);
    return sub;
}


void perform(char*task,char*sol){
    char arg1[30];
    int i = 0;
    int k = 0;
    while(task[i] && task[i] != ' '){
        arg1[k++] = task[i++]; 
    }
    arg1[k] = '\0';

    if(!strcmp(arg1,"if")){
        perform_if(task + i,sol);
        return;
    }

    if(!strcmp(arg1,"endfunc")){
        if(return_no == 0){
            // char temp[200];
            sprintf(temp,"\tpop rbp\n");
            strcat(sol,temp);
            sprintf(temp,"\tret\n");
            strcat(sol,temp);            
        }
        return_no = 0;
        func_open = 0;
        func_count++;
        return;
    }

    if(!strcmp(arg1,"print")){
        print_krte_he(task + i,sol);
        return;
    }

    if(!strcmp(arg1,"goto")){
        goto_next_line(task + i + 1,sol);
        return;
    }

    if(!strcmp(arg1,"return")){
        return_no++;
        // char temp[200];
        sprintf(temp,"\tpop rbp\n");
        strcat(sol,temp);
        sprintf(temp,"\tret\n");
        strcat(sol,temp);
    }

    if(arg1[k-1] == ':'){
        task[k-1] = '\0';
        if(look_up(global,task)!=-1){make_func(task,func_x86);}
        else make_next_line(task,sol);
        return;
    }
    char arg2[30];
    char arg3[30];
    char arg4[30];
    char arg5[30];

    k = 0;
    while(task[i]&& task[i] == ' ')i++;
    while(task[i] && task[i] != ' '){
        arg2[k++] = task[i++]; 
    }
    arg2[k] = '\0';
    if(!strcmp("beginfunc",arg1)){
        // char temp[200];
        sprintf(temp,"\tpush rbp\n");
        strcat(sol,temp);
        sprintf(temp,"\tmov rbp,rsp\n");
        strcat(sol,temp);
        param_no = 0;
    }

    if(!strcmp("pop",arg1)){
        // char temp[200];
        sprintf(temp,"\tpop_stack stack,stack_pointer,%s\n",arg2);
        strcat(sol,temp);
    }

    if(!strcmp("param",arg1)){
        // char temp[200];
        sprintf(temp,"\tpush_stack stack,stack_pointer,%s\n",arg2);
        strcat(sol,temp);
        
    }
    if(!strcmp("push",arg1)){
        // char temp[200];
        sprintf(temp,"\tmov r8,[%s]\n",arg2);
        strcat(sol,temp);
    }

    if(!strcmp(arg1,"call")){
        // char temp[2000];
        sprintf(temp,"\tcall %s\n",arg2);
        strcat(sol,temp);
        return;
    }

    if(!strcmp(arg1,"stackpointer")){
        if(func_open == 0)return;
        if(arg2[0] == '-')empty_stack(sol);
        if(arg2[0] == '+')add_to_stack(sol);

        return;
    }

    k = 0;
    while(task[i]&& task[i] == ' ')i++;
    while(task[i] && task[i] != ' '){
        arg3[k++] = task[i++]; 
    }
    arg3[k] = '\0';
    
    k = 0;
    while(task[i]&& task[i] == ' ')i++;
    while(task[i] && task[i] != ' '){
        arg4[k++] = task[i++]; 
    }
    arg4[k] = '\0';

    if(arg2[0] == '['){
        // char temp[2000];
        arg2[strlen(arg2)-1] = '\0';
        sprintf(temp,"\tset_val_at_pointer %s,%s,%s\n",arg1,arg2+1,arg4);
        strcat(sol,temp);
        return;
    }
    
    k = 0;
    while(task[i]&& task[i] == ' ')i++;
    while(task[i] && task[i] != ' '){
        arg5[k++] = task[i++]; 
    }
    arg5[k] = '\0';

    if(!strlen(arg4)){
        assign(arg1,arg2,arg3,sol);
    }else if(!strlen(arg5)){
        array_traverse(arg1,arg3,arg4,sol);
    }else{
        op(arg1,arg2,arg3,arg4,arg5,sol);
    }
}

char*create_mips(char*tac){
    char*ans=(char*)malloc(sizeof(char)*50000);

    // char temp[1000];
    strcpy(ans,"%include \"../include/helper_func.asm\"\n");
    strcat(ans,"\n");
    
    
    strcat(ans,"section .data\n");
    for(int i = 1 ; i <= int_index ; i ++){
        sprintf(temp,"\t%s dd 0,0\n",New_label(i,2));
        strcat(ans,temp);
    }

    sprintf(temp,"\tstack_pointer dd 0,0\n");
    strcat(ans,temp);

    add_strings(tree,ans);
    strcat(ans,"\n");


    strcat(ans,"section .bss\n\tdigitSpace resb 100\n\tdigitSpacePos resb 8\n\tstack resb 1000000\n");
    strcat(ans,"\n");
    
    
    strcat(ans,"section .text\n\tglobal _start\n");
    strcat(ans,"\n");

    strcat(ans,"_start:\n");

    while(line_index<strlen(tree->_3AC_Code)){
        char*next_line = read_tac_lines();
        if(next_line[0] == '\n')continue;
        if(func_open)perform(next_line,func_x86);
        else perform(next_line,ans);
    }



    strcat(ans,"\tmov rax,60\n\tmov rdi,0\n\tsyscall\n");

    strcat(ans,func_x86);


    char something[2000];
    strcpy(something,"\npopping_algo:\n");
    char local_address[200];
    for(int i = 1 ; i <= int_index ; i ++){
        if (global_variable[i])continue;
        sprintf(local_address,"\tpop_stack stack,stack_pointer,%s\n",New_label(i,2));
        strcat(something,local_address);
    }
    strcat(something,"\tret\n");
    strcat(ans,something);
    strcpy(something,"\npushing_algo:\n");
    local_address[200];
    for(int i = int_index ; i > 0 ; i --){
        if (global_variable[i])continue;
        sprintf(local_address,"\tpush_stack stack,stack_pointer,%s\n",New_label(i,2));
        strcat(something,local_address);
    }
    strcat(something,"\tret\n");
    strcat(ans,something);



    return ans;
}





