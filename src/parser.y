%{  
    #include<stdio.h>
    #include<stdlib.h>


    extern char* yytext;
    extern int yylineno;
    extern symbol_table*global;
    extern symbol_table*local[];
    
    extern int table_index;
    extern int class_open;
    extern int suite_type;
    extern int Basic_Block;
    extern char class_name[];


    extern int int_index;
    extern int float_index;
    extern int string_index;
    extern int bool_index;
    extern int INT_[];
    extern float FLOAT_[];
    extern char STRING_[][1000];
    extern int BOOL_[];
    extern int index_type;
    extern int size_of_list;
    extern stack_char*flow_start;
    extern stack_char*flow_end;
    extern int global_variable[];





    int yylex ();
    void yyerror(const char *s);

%}

%code requires{
    #include "../include/node.c"
    node*tree;
}
%union{
    char*lexeme;
    node*head;

}

%token <head> STRING INT FLOAT
%token <head> PLUS MINUS MULTIPLY DIVIDE MODULO POW
%token <head> eq_rel neq_rel gt_rel lt_rel geq_rel leq_rel and_token or_token not_token and_op or_op xor_op nor_op lshift_op rshift_op
%token <head> equal add_eq minus_eq mult_eq div_eq mod_eq pow_eq and_eq random_eq xor_eq lshift_eq rshift_eq
%token <head> IF ELIF ELSE FOR WHILE BREAK CONTINUE DEF CLASS
%token <head> INDENT DEDENT
%token <head>  NAME
%token <head>  RANGE

%token <head> COLON OPEN_BRACKET CLOSE_BRACKET COMMA OPEN_SQUARE_BRACKET CLOSE_SQUARE_BRACKET
%token <head> NEWLINE
%token <head> concat 
%token <head> IN 
%token <head> AT_THE_RATE
%token <head> RETURN
%token <head> FULLSTOP
%token <head> GOTO
%token <head> concat_eq
%token <head> INT_NAME FLOAT_NAME STRING_NAME
%token <head> SEMI_COLON COLON_EQ


%token <head> TRUE_T NONE FALSE_T
%token <head> list_float list_int list_string
%token <head> PRINT
%token <head> __name__
%token <head> LEN




%left POW  AT_THE_RATE  DIVIDE  concat  MODULO PLUS MINUS lshift_eq rshift_op and_token xor_op or_op
%right not_token IF ELSE ELIF

%type<head>file  
%type<head>stmts 
%type<head>stmt  
%type<head>compound_stmt  
%type<head>simple_stmt  
%type<head>if_stmt 
%type<head>elif_stmts  
%type<head>else_stmt  
%type<head>while_stmt  
%type<head>for_stmt  
%type<head>rangelist
%type<head>funcdef 
%type<head>parameters
%type<head>typedarglist
%type<head>tfpdef
%type<head>classdef 
%type<head>expr_stmt 
%type<head>annassign
%type<head>augassign
%type<head>suite 
%type<head>flow_stmt 
%type<head>test
%type<head>or_test
%type<head>and_test 
%type<head>not_test
%type<head>comparison
%type<head>comp_op
%type<head>expr
%type<head>xor_expr
%type<head>and_expr
%type<head>shift_expr
%type<head>shift_op
%type<head>arith_expr
%type<head>add_minus 
%type<head>term
%type<head>ops 
%type<head>factor
%type<head>ops2 
%type<head>power
%type<head>atom_expr
%type<head>atom
%type<head>trailer
%type<head>testlist
%type<head>OR
%type<head>AND
%type<head>var_type
%type<head>if_block
%type<head>print_stmt
%type<head>len









%start file

%%


file :          stmts                               {
                                                        node*temp = create_new_node("BLOCK","");
                                                        add_new_child(temp,$1);
                                                        $$ = temp;
                                                        tree = $$;
                                                        strcat($$->_3AC_Code,$1->_3AC_Code);
                                                    }

|               %empty                              {tree = NULL;}

stmts :         stmts stmt                          {   

                                                        $$ = $1;
                                                        add_new_child($$,$2);
                                                        strcat($$->_3AC_Code,$2->_3AC_Code);
                                                        // printf("%s",$$->_3AC_Code);
                                                    }
|               stmt                                {
                                                        node*temp = create_new_node("SUITE","");
                                                        add_new_child(temp,$1);$$ = temp;
                                                        strcat($$->_3AC_Code,$1->_3AC_Code);
                                                    }
|               NEWLINE                             {$$ = NULL;}

stmt :          compound_stmt                       {$$ = $1;}
|               simple_stmt                         {$$ = $1;}

compound_stmt : if_stmt {printf("IF_STMT FORMED in line : %d\n",yylineno);$$ = $1;}
|               while_stmt {printf("WHILE_STMT FORMED in line : %d\n",yylineno);$$ = $1;}
|               for_stmt {printf("FOR_STMT FORMED in line : %d\n",yylineno);$$ = $1;}
|               funcdef {printf("FUNC FORMED in line : %d\n",yylineno);$$ = $1;}
|               classdef {printf("CLASSS FORMED in line : %d\n",yylineno);$$ = $1;}

simple_stmt :   expr_stmt NEWLINE                           {
                                                                printf("EXPR_STMT FORMED in line : %d\n",yylineno);
                                                                $$ = $1;
                                                            }

|               flow_stmt                                   {
                                                                printf("FLOW_STMT FORMED in line : %d\n",yylineno);
                                                                $$ = $1;
                                                            }
|               print_stmt NEWLINE                          {
                                                                printf("PRINT_STMT FORMED in line : %d\n",yylineno);
                                                                $$ = $1;                                                                
                                                            }



if_block:       IF test COLON suite                         {
                                                                $$ = create_new_node("IF_STMT","");
                                                                add_new_child($$,$2);
                                                                add_new_child($$,$4);

                                                                if(!strcmp($2->child_nodes[0]->name,"__name__")){
                                                                    strcpy($$->_3AC_Code,$4->_3AC_Code);
                                                                    $$->no_of_childs = 0;
                                                                }else{
                                                                    char end[30];
                                                                    strcpy(end,make_line(Basic_Block++));
                                                                    strcpy($$->value_address,end);
                                                                    strcat($$->_3AC_Code,$2->_3AC_Code);
                                                                    char temp[1000];
                                                                    sprintf(temp,"if %s == False goto %s\n",$2->value_address,end);
                                                                    strcat($$->_3AC_Code,temp);
                                                                    strcat($$->_3AC_Code,$4->_3AC_Code);
                                                                }
                                                            }    


if_stmt :       if_block elif_stmts else_stmt               {
                                                                $$ = $1;
                                                                add_new_child($$,$2);
                                                                add_new_child($$,$3);

                                                                char end[30];
                                                                strcpy(end,make_line(Basic_Block++));
                                                                
                                                                char temp[1000];
                                                                sprintf(temp,"goto %s\n",end);
                                                                strcat($$->_3AC_Code,temp);

                                                                sprintf(temp,"%s:\n",$$->value_address);
                                                                strcat($$->_3AC_Code,temp);
                                                                


                                                                int i = 0;
                                                                node*elifs = $2;
                                                                char temp_end[30];
                                                                
                                                                while(i < elifs->no_of_childs){
                                                                    strcpy(temp_end,make_line(Basic_Block++));
                                                                    node*elif = elifs->child_nodes[i];
                                                                    strcat($$->_3AC_Code,elif->child_nodes[0]->_3AC_Code);
                                                                    sprintf(temp,"if %s == False goto %s\n",elif->child_nodes[0]->value_address,temp_end);
                                                                    strcat($$->_3AC_Code,temp);
                                                                    strcat($$->_3AC_Code,elif->child_nodes[1]->_3AC_Code);
                                                                    sprintf(temp,"goto %s\n",end);
                                                                    strcat($$->_3AC_Code,temp);
                                                                    sprintf(temp,"%s:\n",temp_end);
                                                                    strcat($$->_3AC_Code,temp);
                                                                    i++;
                                                                }

                                                                strcat($$->_3AC_Code,$3->_3AC_Code);
                                                                sprintf(temp,"goto %s\n",end);
                                                                strcat($$->_3AC_Code,temp);
                                                                sprintf(temp,"%s:\n",end);
                                                                strcat($$->_3AC_Code,temp);

                                                            }

|               if_block else_stmt                          {
                                                                $$ = $1;
                                                                add_new_child($$,$2);

                                                                char end[30];
                                                                strcpy(end,make_line(Basic_Block++));
                                                                char temp[1000];
                                                                sprintf(temp,"goto %s\n",end);
                                                                strcat($$->_3AC_Code,temp);

                                                                sprintf(temp,"%s:\n",$$->value_address);
                                                                strcat($$->_3AC_Code,temp);  
                                                                strcat($$->_3AC_Code,$2->_3AC_Code);  

                                                                sprintf(temp,"goto %s\n",end);
                                                                strcat($$->_3AC_Code,temp);

                                                                sprintf(temp,"%s:\n",end);
                                                                strcat($$->_3AC_Code,temp);
                                                            }

|               if_block elif_stmts                         {
                                                                $$ = $1;
                                                                add_new_child($$,$2);


                                                                char end[30];
                                                                strcpy(end,make_line(Basic_Block++));
                                                                
                                                                char temp[1000];
                                                                sprintf(temp,"goto %s\n",end);
                                                                strcat($$->_3AC_Code,temp);

                                                                sprintf(temp,"%s:\n",$$->value_address);
                                                                strcat($$->_3AC_Code,temp);
                                                                


                                                                int i = 0;
                                                                node*elifs = $2;
                                                                char temp_end[30];
                                                                
                                                                while(i < elifs->no_of_childs-1){
                                                                    strcpy(temp_end,make_line(Basic_Block++));
                                                                    node*elif = elifs->child_nodes[i];
                                                                    strcat($$->_3AC_Code,elif->child_nodes[0]->_3AC_Code);
                                                                    sprintf(temp,"if %s == False goto %s\n",elif->child_nodes[0]->value_address,temp_end);
                                                                    strcat($$->_3AC_Code,temp);
                                                                    strcat($$->_3AC_Code,elif->child_nodes[1]->_3AC_Code);
                                                                    sprintf(temp,"goto %s\n",end);
                                                                    strcat($$->_3AC_Code,temp);
                                                                    sprintf(temp,"%s:\n",temp_end);
                                                                    strcat($$->_3AC_Code,temp);
                                                                    i++;
                                                                }

                                                                node*elif = elifs->child_nodes[elifs->no_of_childs-1];

                                                                strcat($$->_3AC_Code,elif->child_nodes[0]->_3AC_Code);
                                                                sprintf(temp,"if %s == False goto %s\n",elif->child_nodes[0]->value_address,end);
                                                                strcat($$->_3AC_Code,temp);
                                                                strcat($$->_3AC_Code,elif->child_nodes[1]->_3AC_Code);
                                                                sprintf(temp,"goto %s\n",end);
                                                                strcat($$->_3AC_Code,temp);
                                                                sprintf(temp,"%s:\n",end);
                                                                strcat($$->_3AC_Code,temp);
                                                            }

|               if_block                                    {
                                                                $$ = $1;
                                                                if($$->no_of_childs == 0){
                                                                    $$ = $1;
                                                                }else{
                                                                    char temp[1000];
                                                                    sprintf(temp,"goto %s\n",$1->value_address);
                                                                    strcat($$->_3AC_Code,temp);
                                                                    sprintf(temp,"%s:\n",$1->value_address);
                                                                    strcat($$->_3AC_Code,temp);
                                                                }
                                                            }

elif_stmts :    ELIF test COLON suite                       {
                                                                $$ = create_new_node("ELIF_STMTS","");
                                                                node*temp2 = create_new_node("ELIF_STMT","");
                                                                add_new_child(temp2,$2);
                                                                add_new_child(temp2,$4);
                                                                add_new_child($$,temp2);
                                                            }

|               elif_stmts ELIF test COLON suite            {
                                                                $$ = $1;node*temp1 = create_new_node("ELIF_STMT","");
                                                                add_new_child(temp1,$3);
                                                                add_new_child(temp1,$5);
                                                                add_new_child($$,temp1);
                                                                
                                                            }

else_stmt :     ELSE COLON suite                            {
                                                                $$ = create_new_node("ELSE_STMT","");
                                                                add_new_child($$,$3);
                                                                strcat($$->_3AC_Code,$3->_3AC_Code);
                                                            }


while_stmt :    WHILE                                       {
                                                                char start[30];
                                                                char end[30];
                                                                strcpy(start,make_line(Basic_Block++));
                                                                strcpy(end,make_line(Basic_Block++));
                                                                push_stack(flow_start,start);
                                                                push_stack(flow_end,end);

                                                            }


                        test COLON suite                    {
                                                                $$ = create_new_node("WHILE_STMT","");
                                                                add_new_child($$,$3);
                                                                add_new_child($$,$5);

                                                                char start[30];
                                                                char end[30];
                                                                strcpy(start,top_stack(flow_start));
                                                                strcpy(end,top_stack(flow_end));
                                                                pop_stack(flow_start);
                                                                pop_stack(flow_end);


                                                                char temp[1000];
                                                                sprintf(temp,"goto %s\n",start);
                                                                strcat($$->_3AC_Code,temp);

                                                                sprintf(temp,"%s:\n",start);
                                                                strcat($$->_3AC_Code,temp);
                                                                
                                                                strcat($$->_3AC_Code,$3->_3AC_Code);

                     
                                                                sprintf(temp,"if %s == False goto %s\n",$3->value_address,end);
                                                                strcat($$->_3AC_Code,temp);

                                                                node*temp_node = $5;
                                                                strcat($$->_3AC_Code,temp_node->_3AC_Code);


                                                                sprintf(temp,"goto %s\n",start);
                                                                strcat($$->_3AC_Code,temp);

                                                                sprintf(temp,"%s:\n",end);
                                                                strcat($$->_3AC_Code,temp);
                                                            }

for_stmt :      FOR                                         {
                                                                char start[30];
                                                                char end[30];
                                                                strcpy(start,make_line(Basic_Block++));
                                                                strcpy(end,make_line(Basic_Block++));
                                                                push_stack(flow_start,start);
                                                                push_stack(flow_end,end);
                                                            }


                    NAME IN RANGE rangelist COLON           {
                                                                strcpy($3->value_address,$6->value_address);
                                                                if(suite_type == 1){
                                                                    add_variable(local[table_index],$3->value);
                                                                    set_type(local[table_index],$3->value,"int");
                                                                    strcpy(local[table_index]->variables[look_up(local[table_index],$3->value)].address_of_symbol,$3->value_address);
                                                                }else{
                                                                    global_variable[atoi($3->value_address+1)]++;
                                                                    add_variable(global,$3->value);
                                                                    set_type(global,$3->value,"int"); 
                                                                    strcpy(global->variables[look_up(global,$3->value)].address_of_symbol,$3->value_address);
                                                                }

                                                            }
                    
                    
                    
                    
                    
                    
                                                    suite   {
                                                                $$ = create_new_node("FOR_STMT","");
                                                                add_new_child($$,$3);
                                                                add_new_child($$,$6);
                                                                add_new_child($$,$9);


                                                                char start[30];
                                                                char end[30];



                                                                strcpy(start,top_stack(flow_start));
                                                                strcpy(end,top_stack(flow_end));
                                                                pop_stack(flow_start);
                                                                pop_stack(flow_end);
                                                                
                                                                char temp[1000];
                                                                
                                                                if($6->no_of_childs == 1){
                                                                    sprintf(temp,"%s = 0\n",$3->value_address);
                                                                    strcat($$->_3AC_Code,temp);
                                                                }else{
                                                                    strcat($$->_3AC_Code,$6->child_nodes[0]->_3AC_Code);
                                                                    sprintf(temp,"%s = %s\n",$3->value_address,$6->child_nodes[0]->value_address);
                                                                    strcat($$->_3AC_Code,temp);
                                                                }

                                                                if($6->no_of_childs == 3){
                                                                    strcat($$->_3AC_Code,$5->child_nodes[2]->_3AC_Code);
                                                                }

                                                                //sprintf(temp,"%s = %s\n",$3->value,$3->value_address);
                                                                //strcat($$->_3AC_Code,temp);

                                                                sprintf(temp,"goto %s\n",start);
                                                                strcat($$->_3AC_Code,temp);


                                                                sprintf(temp,"%s:\n",start);
                                                                strcat($$->_3AC_Code,temp);
                                                                
                                                                strcat($$->_3AC_Code,$6->_3AC_Code);

                                                                //sprintf(temp,"%s = %s\n",$3->value,$3->value_address);
                                                                //strcat($$->_3AC_Code,temp);


                                                                sprintf(temp,"if %s == False goto %s\n",$6->value,end);
                                                                strcat($$->_3AC_Code,temp);

                                                                node*temp_node = $9;
                                                                strcat($$->_3AC_Code,temp_node->_3AC_Code);

                                                                sprintf(temp,"goto %s\n",start);
                                                                strcat($$->_3AC_Code,temp);
                                                                
                                                                sprintf(temp,"%s:\n",end);
                                                                strcat($$->_3AC_Code,temp);
                                                            }


rangelist :     OPEN_BRACKET expr CLOSE_BRACKET                         {
                                                                            $$ = create_new_node("RANGE_STMT","");
                                                                            add_new_child($$,$2);
                                                                            strcpy($$->value_address,New_label(int_index++,2));

                                                                            char temp[1000];
                                                                            sprintf(temp,"%s = %s + 1\n",$$->value_address,$$->value_address);
                                                                            strcat($$->_3AC_Code,temp);
                                                                            strcat($$->_3AC_Code,$2->_3AC_Code);
                                                                            strcpy($$->value,New_label(int_index++,2));
                                                                            sprintf(temp,"%s = %s < %s\n",$$->value,$$->value_address,$2->value_address);
                                                                            strcat($$->_3AC_Code,temp);
                                                                            
                                                                        }

|               OPEN_BRACKET expr COMMA expr CLOSE_BRACKET              {
                                                                            $$ = create_new_node("RANGE_STMT","");
                                                                            add_new_child($$,$2);
                                                                            add_new_child($$,$4);
                                                                            strcpy($$->value_address,New_label(int_index++,2));

                                                                            char temp[1000];
                                                                            sprintf(temp,"%s = %s + 1\n",$$->value_address,$$->value_address);
                                                                            strcat($$->_3AC_Code,temp);
                                                                            strcat($$->_3AC_Code,$2->_3AC_Code);
                                                                            strcpy($$->value,New_label(int_index++,2));
                                                                            sprintf(temp,"%s = %s < %s\n",$$->value,$$->value_address,$2->value_address);
                                                                            strcat($$->_3AC_Code,temp);
                                                                        }

|               OPEN_BRACKET expr COMMA expr COMMA expr CLOSE_BRACKET   {
                                                                            $$ = create_new_node("RANGE_STMT","");
                                                                            add_new_child($$,$2);
                                                                            add_new_child($$,$4);
                                                                            add_new_child($$,$6);
                                                                        }



funcdef :  DEF NAME parameters GOTO var_type COLON          {   
                                                                char*func_name;
                                                                func_name = (char*)malloc(sizeof(char)*30);
                                                                
                                                                if(class_open){
                                                                    strcpy(func_name,class_name);
                                                                    strcat(func_name,".");
                                                                    strcat(func_name,$2->name);
                                                                }
                                                                else strcpy(func_name,$2->name);
                                                                
                                                                
                                                                add_variable(global,func_name);
                                                                set_type(global,func_name,$5->name);
                                                                set_func(global,func_name);
                                                                strcpy($2->value,func_name);
                                                                suite_type = 1;
                                                            }
                                                    suite   {
                                                                $$ = create_new_node("FUNCTION","");
                                                                node*temp = create_new_node("->","");
                                                                add_new_child($$,$2);
                                                                add_new_child($$,$3);
                                                                add_new_child($$,temp);
                                                                add_new_child($$,$5);
                                                                add_new_child($$,$8);
                                                                suite_type = 0;
                                                                table_index++;

                                                                char temp1[1000];
                                                                sprintf(temp1,"%s:\n",$2->value);
                                                                strcat($$->_3AC_Code,temp1);

                                                                sprintf(temp1,"beginfunc\n");
                                                                strcat($$->_3AC_Code,temp1);

                                                                strcat($$->_3AC_Code,$3->_3AC_Code);

                                                                strcat($$->_3AC_Code,$8->_3AC_Code);


                                                                sprintf(temp1,"endfunc\n");
                                                                strcat($$->_3AC_Code,temp1);

                                                            }

|               DEF NAME parameters COLON                   {
                                                                char*func_name;
                                                                func_name = (char*)malloc(sizeof(char)*30);
                                                                
                                                                if(class_open){
                                                                    strcpy(func_name,class_name);
                                                                    strcat(func_name,".");
                                                                    strcat(func_name,$2->name);
                                                                }
                                                                else strcpy(func_name,$2->name);
                                                                
                                                                add_variable(global,func_name);
                                                                set_func(global,func_name);
                                                                strcpy($2->value,func_name);
                                                                suite_type = 1;
                                                            }
                                                            
                                            suite           {
                                                                $$ = create_new_node("FUNCTION","");
                                                                add_new_child($$,$2);
                                                                add_new_child($$,$3);
                                                                add_new_child($$,$6);
                                                                suite_type = 0;
                                                                table_index++;

                                                                char temp1[1000];
                                                                sprintf(temp1,"%s:\n",$2->value);
                                                                strcat($$->_3AC_Code,temp1);

                                                                sprintf(temp1,"beginfunc\n");
                                                                strcat($$->_3AC_Code,temp1);

                                                                if($3)strcat($$->_3AC_Code,$3->_3AC_Code);

                                                                strcat($$->_3AC_Code,$6->_3AC_Code);


                                                                sprintf(temp1,"endfunc\n");
                                                                strcat($$->_3AC_Code,temp1);

                                                            }

parameters:     OPEN_BRACKET typedarglist CLOSE_BRACKET     {
                                                                $$ = $2;
                                                            }  
|               OPEN_BRACKET CLOSE_BRACKET                  {
                                                                $$ = NULL;
                                                            }

typedarglist:   tfpdef                                      {
                                                                $$ = create_new_node("PARAMETERS","");
                                                                add_new_child($$,$1);
                                                                strcpy($$->_3AC_Code,$1->_3AC_Code);
                                                            }

|               typedarglist COMMA tfpdef                   {
                                                                $$ = $1;
                                                                add_new_child($$,$3);
                                                                strcat($$->_3AC_Code,$3->_3AC_Code);

                                                            }

tfpdef:         NAME                                        {
                                                                $$ = $1;
                                                                add_variable(local[table_index],$1->name);
                                                            } 

|               NAME COLON var_type                         {
                                                                $$ = create_new_node(":","");
                                                                add_new_child($$,$1);
                                                                add_new_child($$,$3);


                                                                $1->type = $3->type;
                                                                if($1->type == 2 || $1->type == 5){
                                                                    strcpy($1->value_address,New_label(int_index++,2));
                                                                }else if($1->type == 3){
                                                                    strcpy($1->value_address,New_label(float_index++,3));
                                                                }else if($1->type == 4){
                                                                    strcpy($1->value_address,New_label(string_index++,4));
                                                                }
                                                                char temp1[1000];
                                                                sprintf(temp1,"pop %s\n",$1->value_address);
                                                                strcat($$->_3AC_Code,temp1);
                                                                // sprintf($1->_3AC_Code,"%s = %s\n",$1->value,$1->value_address);
                                                                // strcat($$->_3AC_Code,$1->_3AC_Code);


                                                                add_variable(local[table_index],$1->name);
                                                                set_type(local[table_index],$1->name,$3->name);
                                                                strcpy(local[table_index]->variables[look_up(local[table_index],$1->value)].address_of_symbol,$1->value_address);
                                                            
                                                            }



classdef :      CLASS NAME parameters COLON                 {
                                                                add_variable(global,$2->name);
                                                                table_index++;
                                                                class_open = 1;
                                                                strcpy(class_name,$2->name);
                                                            }

                                            suite           {
                                                                node*temp = create_new_node("CLASS","");
                                                                add_new_child(temp,$2);
                                                                add_new_child(temp,$3);
                                                                add_new_child(temp,$6);
                                                                $$ = temp;
                                                                class_open = 0;
                                                            }

|               CLASS NAME COLON                            {
                                                                add_variable(global,$2->name);
                                                                table_index++;
                                                                strcpy(class_name,$2->name);
                                                                class_open = 1;
                                                            }
                                suite                       {
                                                                node*temp = create_new_node("CLASS","");
                                                                add_new_child(temp,$2);
                                                                add_new_child(temp,$5);
                                                                $$ = temp;
                                                                class_open = 0;
                                                            }

expr_stmt :     test                                        {
                                                                $$ = $1;
                                                            }

|               annassign                                   {
                                                                $$ = $1;
                                                            }

|               NAME augassign test                         {
                                                                $$ = $2;
                                                                add_new_child($$,$1);
                                                                add_new_child($$,$3);
                                                                
                                                                if(look_up(local[table_index],$1->value) != -1){
                                                                    add_variable(local[table_index],$1->name);
                                                                    strcpy($1->value_address,local[table_index]->variables[look_up(local[table_index],$1->value)].address_of_symbol);
                                                                }else if(look_up(global,$1->value) != -1){
                                                                    add_variable(global,$1->name);
                                                                    strcpy($1->value_address,global->variables[look_up(global,$1->value)].address_of_symbol);
                                                                }

                                                                strcat($$->_3AC_Code,$3->_3AC_Code);
                                                                char temp[1000];
                                                                sprintf(temp,"%s = %s %s %s\n",$1->value_address,$1->value_address,$2->value,$3->value_address);
                                                                strcat($$->_3AC_Code,temp); 
                                                                // sprintf(temp,"%s = %s\n",$1->value,$1->value_address); 
                                                                // strcat($$->_3AC_Code,temp);
                                                            }

|               NAME equal test                             {
                                                                $$ = create_new_node("=","");
                                                                add_new_child($$,$1);
                                                                add_new_child($$,$3);
                                                                
                                                                if(look_up(local[table_index],$1->value) != -1){
                                                                    add_variable(local[table_index],$1->name);
                                                                    strcpy($1->value_address,local[table_index]->variables[look_up(local[table_index],$1->value)].address_of_symbol);
                                                                }else if(look_up(global,$1->value) != -1){
                                                                    add_variable(global,$1->name);
                                                                    strcpy($1->value_address,global->variables[look_up(global,$1->value)].address_of_symbol);
                                                                }
                                                                strcat($$->_3AC_Code,$3->_3AC_Code);
                                                                if($3->type == 5){
                                                                    char temp[1000];
                                                                    sprintf(temp,"%s = [%s]\n",$1->value_address,$3->value_address);
                                                                    strcat($$->_3AC_Code,temp);
                                                                }
                                                                strcat($$->_3AC_Code,$1->_3AC_Code);
                                                                char temp[1000];
                                                                printf($1->_3AC_Code,"%s = %s\n",$1->value,$1->value_address);
                                                                sprintf(temp,"%s = %s\n",$1->value_address,$3->value_address);
                                                                strcat($$->_3AC_Code,temp);

                                                            }

|               NAME OPEN_SQUARE_BRACKET test CLOSE_SQUARE_BRACKET equal test    
                                                            {
                                                                $$ = create_new_node("=","");
                                                                add_new_child($$,$1);
                                                                add_new_child($$,$3);
                                                                add_new_child($$,$3);

                                                                
                                                                if(look_up(local[table_index],$1->value) != -1){
                                                                    add_variable(local[table_index],$1->name);
                                                                    strcpy($1->value_address,local[table_index]->variables[look_up(local[table_index],$1->value)].address_of_symbol);
                                                                }else if(look_up(global,$1->value) != -1){
                                                                    add_variable(global,$1->name);
                                                                    strcpy($1->value_address,global->variables[look_up(global,$1->value)].address_of_symbol);
                                                                }
                                                                strcat($$->_3AC_Code,$3->_3AC_Code);
                                                                strcat($$->_3AC_Code,$6->_3AC_Code);

                                                                char temp[1000];
                                                                sprintf(temp,"%s [%s] = %s\n",$1->value_address,$3->value_address,$6->value_address);
                                                                strcat($$->_3AC_Code,temp);
                                                            }

annassign:      NAME COLON var_type                         {
                                                                $$ = create_new_node(":","");
                                                                add_new_child($$,$1);
                                                                add_new_child($$,$3);


                                                                $1->type = $3->type;
                                                                if($1->type == 2 || $1->type == 5){
                                                                    strcpy($1->value_address,New_label(int_index++,2));
                                                                }else if($1->type == 3){
                                                                    strcpy($1->value_address,New_label(float_index++,3));
                                                                }else if($1->type == 4){
                                                                    strcpy($1->value_address,New_label(string_index++,4));
                                                                }
                                                                sprintf($1->_3AC_Code,"%s = %s\n",$1->value,$1->value_address);
                                                                // strcpy($$->_3AC_Code,$1->_3AC_Code);


                                                                if(suite_type == 1){
                                                                    add_variable(local[table_index],$1->name);
                                                                    set_type(local[table_index],$1->name,$3->name);
                                                                    strcpy(local[table_index]->variables[look_up(local[table_index],$1->value)].address_of_symbol,$1->value_address);
                                                                }else{
                                                                    global_variable[atoi($1->value_address+1)]++;
                                                                    add_variable(global,$1->name);
                                                                    set_type(global,$1->name,$3->name); 
                                                                    strcpy(global->variables[look_up(global,$1->value)].address_of_symbol,$1->value_address);
                                                                }
                                                            }

|               NAME COLON var_type equal test              {
                                                                $$ = create_new_node("=","");
                                                                node*temp = create_new_node(":","");
                                                                add_new_child(temp,$1);
                                                                add_new_child(temp,$3);
                                                                add_new_child($$,temp);
                                                                add_new_child($$,$5);

                                                                
                                                                
                                                                
                                                                strcpy($1->value_address,$5->value_address);
                                                                $1->type = $3->type;

                                                                if($1->type == 5){
                                                                    strcpy($1->value_address,New_label(int_index++,2));
                                                                }
                                                                if($1->type != $5->type){
                                                                    printf("Wrong Type Assignment in line : %d \n",yylineno);
                                                                    exit(1);
                                                                }
                                                                strcat($$->_3AC_Code,$5->_3AC_Code);
                                                                if($1->type == 5){
                                                                    char temp[1000];
                                                                    sprintf(temp,"%s = [%s]\n",$1->value_address,$5->value_address);
                                                                    strcat($$->_3AC_Code,temp);
                                                                }else{
                                                                    char temp[1000];
                                                                    sprintf(temp,"%s = %s\n",$1->value_address,$5->value_address);
                                                                    strcat($$->_3AC_Code,temp);
                                                                }
                                                                if(suite_type == 1){
                                                                    add_variable(local[table_index],$1->name);
                                                                    set_type(local[table_index],$1->name,$3->name);
                                                                    strcpy(local[table_index]->variables[look_up(local[table_index],$1->value)].address_of_symbol,$1->value_address);
                                                                    if($1->type == 5)local[table_index]->variables[look_up(local[table_index],$1->value)].size = $5->len;
                                                                }else{
                                                                    global_variable[atoi($1->value_address+1)]++;
                                                                    add_variable(global,$1->name);
                                                                    set_type(global,$1->name,$3->name); 
                                                                    strcpy(global->variables[look_up(global,$1->value)].address_of_symbol,$1->value_address);
                                                                    if($1->type == 5)global->variables[look_up(global,$1->value)].size = $5->len;
                                                                }
                                                            }

var_type:       INT_NAME                                    {
                                                                $$ = create_new_node("int","");
                                                                $$->type = 2;
                                                            }

|               FLOAT_NAME                                  {
                                                                $$ = create_new_node("float","");
                                                                $$->type = 3;
                                                            }  

|               STRING_NAME                                 {
                                                                $$ = create_new_node("string","");
                                                                $$->type = 4;
                                                            }

|               list_float                                  {
                                                                $$ = create_new_node("list_float","");
                                                                $$->type = 4;
                                                            }

|               list_int                                    {
                                                                $$ = create_new_node("list_int","");
                                                                $$->type = 5;
                                                            }

|               list_string                                 {
                                                                $$ = create_new_node("list_string","");
                                                                $$->type = 7;
                                                            }
|               NONE                                        {
                                                                $$ = create_new_node("NONE","");
                                                                $$->type = 0;
                                                            }

augassign:      add_eq                                      {$$ = create_new_node("+=","+");}
|               minus_eq                                    {$$ = create_new_node("-=","-");}
|               mult_eq                                     {$$ = create_new_node("*=","*");}
|               div_eq                                      {$$ = create_new_node("/=","/");}
|               mod_eq                                      {$$ = create_new_node("%%=","%%");}
|               and_eq                                      {$$ = create_new_node("&=","&");}
|               xor_eq                                      {$$ = create_new_node("^=","^");}
|               lshift_eq                                   {$$ = create_new_node("<<=","<<");}
|               rshift_eq                                   {$$ = create_new_node(">>=",">>");}
|               pow_eq                                      {$$ = create_new_node("**=","**");}      
|               concat_eq                                   {$$ = create_new_node("//=","//");} 
|               random_eq                                   {$$ = create_new_node("|=","|");} 

suite :         NEWLINE INDENT stmts DEDENT                 {$$ = $3;}
|               simple_stmt                                 {$$ = $1;}

flow_stmt :     BREAK NEWLINE                               {$$ = create_new_node("BREAK_STMT","");sprintf($$->_3AC_Code,"goto %s\n",top_stack(flow_end));}    
|               CONTINUE NEWLINE                            {$$ = create_new_node("CONTINUE","");sprintf($$->_3AC_Code,"goto %s\n",top_stack(flow_start));}
|               RETURN NEWLINE                              {$$ = create_new_node("RETURN","");strcpy($$->_3AC_Code,"return\n");}
|               RETURN test NEWLINE                     {$$ = create_new_node("RETURN","");add_new_child($$,$2);char temp[10000];sprintf(temp,"%spush %s\nreturn\n",$2->_3AC_Code,$2->value_address);strcpy($$->_3AC_Code,temp);}

print_stmt :    PRINT OPEN_BRACKET testlist CLOSE_BRACKET    {
                                                                $$ = create_new_node("PRINT_STMT","");
                                                                add_new_child($$,$3);
                                                                for(int i = 0 ; i < $3->no_of_childs ; i ++){
                                                                    node*temp = $3->child_nodes[i];
                                                                    strcat($$->_3AC_Code,temp->_3AC_Code);

                                                                    char temp1[1000];
                                                                    sprintf(temp1,"print %s\n",temp->value_address);
                                                                    strcat($$->_3AC_Code,temp1);
                                                                }
                                                            } 

test:           or_test                                     {
                                                                $$ = $1;
                                                            }

or_test:        and_test                                    {
                                                                $$ = $1;
                                                            }

|               or_test OR and_test                         {
                                                                $$ = $2;
                                                                add_new_child($$,$1);
                                                                add_new_child($$,$3);

                                                                if($1->type != $3->type){
                                                                    printf("Wrong Type Assignment in line : %d \n",yylineno);
                                                                    exit(1);
                                                                }

                                                                $$->type = $1->type;
                                                                if($$->type == 2){
                                                                    strcpy($$->value_address,New_label(int_index++,2));
                                                                }else if($$->type == 3){
                                                                    strcpy($$->value_address,New_label(float_index++,3));
                                                                }else if($$->type == 4){
                                                                    strcpy($$->value_address,New_label(string_index++,4));
                                                                }

                                                                strcpy($$->_3AC_Code,$1->_3AC_Code);
                                                                strcat($$->_3AC_Code,$3->_3AC_Code);
                                                                char temp[1000];
                                                                sprintf(temp,"%s = %s || %s\n",$$->value_address,$1->value_address,$3->value_address);
                                                                strcat($$->_3AC_Code,temp);
                                                            }

OR :            or_token                                    {$$ = create_new_node("or","");}
AND:            and_token                                   {$$ = create_new_node("and","");}

and_test:       not_test                                    {$$ = $1;}
|               and_test AND not_test                       {
                                                                $$ = $2;
                                                                add_new_child($$,$1);
                                                                add_new_child($$,$3);

                                                                if($1->type != $3->type){
                                                                    printf("Wrong Type Assignment in line : %d \n",yylineno);
                                                                    exit(1);
                                                                }

                                                                $$->type = $1->type;
                                                                if($$->type == 2){
                                                                    strcpy($$->value_address,New_label(int_index++,2));
                                                                }else if($$->type == 3){
                                                                    strcpy($$->value_address,New_label(float_index++,3));
                                                                }else if($$->type == 4){
                                                                    strcpy($$->value_address,New_label(string_index++,4));
                                                                }

                                                                strcpy($$->_3AC_Code,$1->_3AC_Code);
                                                                strcat($$->_3AC_Code,$3->_3AC_Code);
                                                                char temp[1000];
                                                                sprintf(temp,"%s = %s && %s\n",$$->value_address,$1->value_address,$3->value_address);
                                                                strcat($$->_3AC_Code,temp);
                                                            }

not_test :      not_token not_test                          {
                                                                $$ = create_new_node("not","");
                                                                add_new_child($$,$2);
                                                                $$->type = $2->type;
                                                                strcpy($$->value_address,$2->value_address);
                                                                char temp[1000];
                                                                sprintf(temp,"%s = not %s\n",$$->value_address,$2->value_address);
                                                                strcat($$->_3AC_Code,$2->_3AC_Code);
                                                                strcat($$->_3AC_Code,temp);
                                                            }
|               comparison                                  {$$ = $1;}


comparison :    expr                                        {$$ = $1;}
|               comparison comp_op expr                     {
                                                                $$ = $2;
                                                                add_new_child($$,$1);
                                                                add_new_child($$,$3);
                                                                
                                                                if($1->type != $3->type){
                                                                    printf("Wrong Type Assignment in line : %d \n",yylineno);
                                                                    exit(1);
                                                                }

                                                                $$->type = $1->type;
                                                                if($$->type == 2){
                                                                    strcpy($$->value_address,New_label(int_index++,2));
                                                                }else if($$->type == 3){
                                                                    strcpy($$->value_address,New_label(float_index++,3));
                                                                }else if($$->type == 4){
                                                                    strcpy($$->value_address,New_label(string_index++,4));
                                                                }

                                                                strcpy($$->_3AC_Code,$1->_3AC_Code);
                                                                strcat($$->_3AC_Code,$3->_3AC_Code);
                                                                char temp[1000];
                                                                sprintf(temp,"%s = %s %s %s\n",$$->value_address,$1->value_address,$$->name,$3->value_address);
                                                                strcat($$->_3AC_Code,temp);
                                                            }

comp_op:        lt_rel                                      {node*temp = create_new_node("<","");$$ = temp;}
|               gt_rel                                      {node*temp = create_new_node(">","");$$ = temp;}
|               geq_rel                                     {node*temp = create_new_node(">=","");$$ = temp;}
|               leq_rel                                     {node*temp = create_new_node("<=","");$$ = temp;}    
|               eq_rel                                      {node*temp = create_new_node("==","");$$ = temp;}
|               neq_rel                                     {node*temp = create_new_node("!=","");$$ = temp;}
|               IN                                          {node*temp = create_new_node("in","");$$ = temp;}

expr:           xor_expr                                    {$$ = $1;}
|               expr or_op xor_expr                         {
                                                                $$ = $2;
                                                                add_new_child($$,$1);
                                                                add_new_child($$,$3);

                                                                if($1->type != $3->type){
                                                                    printf("Wrong Type Assignment in line : %d \n",yylineno);
                                                                    exit(1);
                                                                }

                                                                $$->type = $1->type;
                                                                if($$->type == 2){
                                                                    strcpy($$->value_address,New_label(int_index++,2));
                                                                }else if($$->type == 3){
                                                                    strcpy($$->value_address,New_label(float_index++,3));
                                                                }else if($$->type == 4){
                                                                    strcpy($$->value_address,New_label(string_index++,4));
                                                                }

                                                                strcpy($$->_3AC_Code,$1->_3AC_Code);
                                                                strcat($$->_3AC_Code,$3->_3AC_Code);
                                                                char temp[1000];
                                                                sprintf(temp,"%s = %s %s %s\n",$$->value_address,$1->value_address,$$->name,$3->value_address);
                                                                strcat($$->_3AC_Code,temp);                                                               
                                                            }

xor_expr:       and_expr                                    {$$ = $1;}
|               xor_expr xor_op and_expr                    {
                                                                $$ = $2;
                                                                add_new_child($$,$1);
                                                                add_new_child($$,$3);

                                                                if($1->type != $3->type){
                                                                    printf("Wrong Type Assignment in line : %d \n",yylineno);
                                                                    exit(1);
                                                                }

                                                                $$->type = $1->type;
                                                                if($$->type == 2){
                                                                    strcpy($$->value_address,New_label(int_index++,2));
                                                                }else if($$->type == 3){
                                                                    strcpy($$->value_address,New_label(float_index++,3));
                                                                }else if($$->type == 4){
                                                                    strcpy($$->value_address,New_label(string_index++,4));
                                                                }

                                                                strcpy($$->_3AC_Code,$1->_3AC_Code);
                                                                strcat($$->_3AC_Code,$3->_3AC_Code);
                                                                char temp[1000];
                                                                sprintf(temp,"%s = %s %s %s\n",$$->value_address,$1->value_address,$$->name,$3->value_address);
                                                                strcat($$->_3AC_Code,temp);
                                                            }

and_expr:       shift_expr                                  {$$ = $1;}         
|               and_expr and_op shift_expr                  {
                                                                $$ = $2;
                                                                add_new_child($$,$1);
                                                                add_new_child($$,$3);

                                                                if($1->type != $3->type){
                                                                    printf("Wrong Type Assignment in line : %d \n",yylineno);
                                                                    exit(1);
                                                                }

                                                                $$->type = $1->type;
                                                                if($$->type == 2){
                                                                    strcpy($$->value_address,New_label(int_index++,2));
                                                                }else if($$->type == 3){
                                                                    strcpy($$->value_address,New_label(float_index++,3));
                                                                }else if($$->type == 4){
                                                                    strcpy($$->value_address,New_label(string_index++,4));
                                                                }

                                                                strcpy($$->_3AC_Code,$1->_3AC_Code);
                                                                strcat($$->_3AC_Code,$3->_3AC_Code);
                                                                char temp[1000];
                                                                sprintf(temp,"%s = %s %s %s\n",$$->value_address,$1->value_address,$$->name,$3->value_address);
                                                                strcat($$->_3AC_Code,temp);                                                              
                                                            }


shift_expr:     arith_expr                                  {$$ = $1;}
|               shift_expr shift_op arith_expr              {
                                                                $$ = $2;
                                                                add_new_child($$,$1);
                                                                add_new_child($$,$3);

                                                                if($1->type != $3->type){
                                                                    printf("Wrong Type Assignment in line : %d \n",yylineno);
                                                                    exit(1);
                                                                }

                                                                $$->type = $1->type;
                                                                if($$->type == 2){
                                                                    strcpy($$->value_address,New_label(int_index++,2));
                                                                }else if($$->type == 3){
                                                                    strcpy($$->value_address,New_label(float_index++,3));
                                                                }else if($$->type == 4){
                                                                    strcpy($$->value_address,New_label(string_index++,4));
                                                                }

                                                                strcpy($$->_3AC_Code,$1->_3AC_Code);
                                                                strcat($$->_3AC_Code,$3->_3AC_Code);
                                                                char temp[1000];
                                                                sprintf(temp,"%s = %s %s %s\n",$$->value_address,$1->value_address,$$->name,$3->value_address);
                                                                strcat($$->_3AC_Code,temp);
                                                            }


shift_op :      lshift_op                                   {node*temp = create_new_node("<<","");$$=temp;}
|               rshift_op                                   {node*temp = create_new_node(">>","");$$=temp;}


arith_expr:     term                                        {$$ = $1;}
|               arith_expr add_minus term                   {
                                                                $$ = $2;
                                                                add_new_child($$,$1);
                                                                add_new_child($$,$3);

                                                                if($1->type != $3->type){
                                                                    printf("Wrong Type Assignment in line : %d \n",yylineno);
                                                                    exit(1);
                                                                }

                                                                $$->type = $1->type;
                                                                if($$->type == 2){
                                                                    strcpy($$->value_address,New_label(int_index++,2));
                                                                }else if($$->type == 3){
                                                                    strcpy($$->value_address,New_label(float_index++,3));
                                                                }else if($$->type == 4){
                                                                    strcpy($$->value_address,New_label(string_index++,4));
                                                                }

                                                                strcpy($$->_3AC_Code,$1->_3AC_Code);
                                                                strcat($$->_3AC_Code,$3->_3AC_Code);
                                                                char temp[1000];
                                                                sprintf(temp,"%s = %s %s %s\n",$$->value_address,$1->value_address,$$->name,$3->value_address);
                                                                strcat($$->_3AC_Code,temp);
                                                            }

add_minus :     PLUS                                        {node*temp = create_new_node("+","");$$=temp;}    
|               MINUS                                       {node*temp = create_new_node("-","");$$=temp;}

term:           factor                                      {$$ = $1;} 
|               term ops factor                             {
                                                                $$ = $2;
                                                                add_new_child($$,$1);
                                                                add_new_child($$,$3);
                                                            
                                                                if($1->type != $3->type){
                                                                    printf("Wrong Type Assignment in line : %d \n",yylineno);
                                                                    exit(1);
                                                                }

                                                                $$->type = $1->type;
                                                                if($$->type == 2){
                                                                    strcpy($$->value_address,New_label(int_index++,2));
                                                                }else if($$->type == 3){
                                                                    strcpy($$->value_address,New_label(float_index++,3));
                                                                }else if($$->type == 4){
                                                                    strcpy($$->value_address,New_label(string_index++,4));
                                                                }

                                                                strcpy($$->_3AC_Code,$1->_3AC_Code);
                                                                strcat($$->_3AC_Code,$3->_3AC_Code);
                                                                char temp[1000];
                                                                sprintf(temp,"%s = %s %s %s\n",$$->value_address,$1->value_address,$$->name,$3->value_address);
                                                                strcat($$->_3AC_Code,temp);
                                                            }

ops :           MULTIPLY                                    {node*temp = create_new_node("*","");$$=temp;}
|               POW                                         {node*temp = create_new_node("**","");$$=temp;}
|               DIVIDE                                      {node*temp = create_new_node("/","");$$=temp;}
|               MODULO                                      {node*temp = create_new_node("%","");$$=temp;}
|               concat                                      {node*temp = create_new_node("//","");$$=temp;}

factor:         ops2 factor                                 {   
                                                                $$ = $1;
                                                                add_new_child($$,$2);
                                                                $$->type = $2->type;
                                                                strcpy($$->value_address,$2->value_address);
                                                                char temp[1000];
                                                                sprintf(temp,"%s = %c%s\n",$$->value_address,$1->name[0],$2->value_address);
                                                                strcat($$->_3AC_Code,$2->_3AC_Code);
                                                                strcat($$->_3AC_Code,temp);
                                                            }                                 
|               power                                       {$$ = $1;}
ops2 :          PLUS                                        {node*temp = create_new_node("+","");$$ = temp;}
|               MINUS                                       {node*temp = create_new_node("-","");$$ = temp;}
|               nor_op                                      {node*temp = create_new_node("~","");$$ = temp;}

power:          atom_expr                                   {$$ = $1;}

atom_expr:      NAME trailer                                {
                                                                $$ = create_new_node("ATOM_EXPR","");
                                                                add_new_child($$,$1);
                                                                add_new_child($$,$2);
                                                                
                                                                
                                                                if($2->type == 11){
                                                                    $$->type = 2;
                                                                    if(look_up(local[table_index],$1->name) != -1){
                                                                        $1->type = local[table_index]->variables[look_up(local[table_index],$1->value)].type;
                                                                        add_variable(local[table_index],$1->name);
                                                                        strcpy($1->value_address,local[table_index]->variables[look_up(local[table_index],$1->value)].address_of_symbol);
                                                                    }
                                                                    else if(look_up(global,$1->name) != -1){
                                                                        global_variable[atoi($1->value_address+1)]++;
                                                                        $1->type = global->variables[look_up(global,$1->value)].type;
                                                                        add_variable(global,$1->name);
                                                                        strcpy($1->value_address,global->variables[look_up(global,$1->value)].address_of_symbol);

                                                                    }
                                                                    strcpy($$->value_address,New_label(int_index++,2));
                                                                    char temp[400];
                                                                    strcat($$->_3AC_Code,$2->_3AC_Code);

                                                                    sprintf(temp,"%s = %s [%s]\n",$$->value_address,$1->value_address,$2->value_address);
                                                                    strcat($$->_3AC_Code,temp);
                                                                }else{    
                                                                    $$->type = global->variables[look_up(global,$1->value)].type;
                                                                    add_variable(global,$1->name);
                                                                    


                                                                    if($$->type == 2){
                                                                        strcpy($$->value_address,New_label(int_index++,2));
                                                                    }else if($$->type == 3){
                                                                        strcpy($$->value_address,New_label(float_index++,3));
                                                                    }else if($$->type == 4){
                                                                        strcpy($$->value_address,New_label(string_index++,4));
                                                                    }
                                                                    char temp[1000];
                                                                    sprintf(temp,"stackpointer +\n");
                                                                    strcat($$->_3AC_Code,temp);

                                                                    strcat($$->_3AC_Code,$2->_3AC_Code);

                                
                                                                    sprintf(temp,"call %s\n",$1->value);
                                                                    strcat($$->_3AC_Code,temp);

                                                                    sprintf(temp,"stackpointer -\n");
                                                                    strcat($$->_3AC_Code,temp);

                                                                    
                                                                    if($$->type != 0){                    
                                                                        sprintf(temp,"%s = popparam\n",$$->value_address);
                                                                        strcat($$->_3AC_Code,temp);
                                                                    }
                                                                }
                                                            }
|               atom                                        {$$ = $1;}

atom:           OPEN_SQUARE_BRACKET testlist CLOSE_SQUARE_BRACKET   {
                                                                        $$ = create_new_node("ATOM","");
                                                                        node*temp1 = create_new_node("[","");
                                                                        node*temp2 = create_new_node("]","");
                                                                        add_new_child($$,temp1);
                                                                        add_new_child($$,$2);
                                                                        add_new_child($$,temp2);


                                                                        $$->type = $2->child_nodes[0]->type + 3;
                                                                        $$->len = $2->no_of_childs;
                                                                        strcpy($$->value_address,$2->child_nodes[0]->value_address);
                                                                        for(int i = 0 ; i < $2->no_of_childs ; i ++){
                                                                            strcat($$->_3AC_Code,$2->child_nodes[i]->_3AC_Code);
                                                                        }
                                                                        

                                                                    }
|               OPEN_SQUARE_BRACKET CLOSE_SQUARE_BRACKET            {$$ = create_new_node("ATOM","");node*temp1 = create_new_node("[","");node*temp2 = create_new_node("]","");add_new_child($$,temp1);add_new_child($$,temp2);}
|               NAME                                                {
                                                                        $$ = $1;
                                                                        if(look_up(local[table_index],$$->name) != -1){
                                                                            $$->type = local[table_index]->variables[look_up(local[table_index],$1->value)].type;
                                                                            add_variable(local[table_index],$1->name);
                                                                            strcpy($$->value_address,local[table_index]->variables[look_up(local[table_index],$1->value)].address_of_symbol);
                                                                        }
                                                                        else if(look_up(global,$$->name) != -1){
                                                                            global_variable[atoi($1->value_address+1)]++;
                                                                            $$->type = global->variables[look_up(global,$1->value)].type;
                                                                            add_variable(global,$1->name);
                                                                            strcpy($$->value_address,global->variables[look_up(global,$1->value)].address_of_symbol);

                                                                        }
                                                                    }

|               INT                                                 {
                                                                        $1->type = 2;
                                                                        INT_[int_index] = atoi(yytext);
                                                                        strcpy($1->value_address,New_label(int_index++,2));
                                                                        sprintf($1->_3AC_Code,"%s = %s\n",$1->value_address,yytext);
                                                                        $$ = $1;
                                                                    }

|               FLOAT                                               {
                                                                        $1->type = 3;
                                                                        FLOAT_[float_index] = atof(yytext);
                                                                        strcpy($1->value_address,New_label(float_index++,3));
                                                                        sprintf($1->_3AC_Code,"%s = %s\n",$1->value_address,yytext);
                                                                        $$ = $1;
                                                                    }

|               STRING                                              {
                                                                        $1->type = 4;
                                                                        strcpy(STRING_[string_index],yytext);
                                                                        strcpy($1->value_address,New_label(string_index++,4));
                                                                        sprintf($1->_3AC_Code,"%s = %s\n",$1->value_address,yytext);
                                                                        $$ = $1;
                                                                    }

|               OPEN_BRACKET test CLOSE_BRACKET                     {$$  = $2;}
|               NONE                                                {node*temp = create_new_node("NONE","");$$ = temp;}
|               TRUE_T                                              {node*temp = create_new_node("TRUE","");$$ = temp;$$->type = 2;strcpy($$->value_address,New_label(int_index++,2));sprintf($$->_3AC_Code,"%s = 1\n",$$->value_address);}
|               FALSE_T                                             {node*temp = create_new_node("FALSE","");$$ = temp;$$->type = 2;strcpy($$->value_address,New_label(int_index++,2));sprintf($$->_3AC_Code,"%s = 0\n",$$->value_address);}
|               INT_NAME                                            {node*temp = create_new_node("int","");$$ = temp;}
|               FLOAT_NAME                                          {node*temp = create_new_node("float","");$$ = temp;}
|               STRING_NAME                                         {node*temp = create_new_node("string","");$$ = temp;}
|               __name__                                            {$$ = create_new_node("__name__","__name__");$$->type = 4;strcpy($$->value_address,"__name__");}
|               len                                                 {$$ = $1;}

len:       LEN OPEN_BRACKET NAME CLOSE_BRACKET              {
                                                                $$ = create_new_node("LEN","");
                                                                add_new_child($$,$3);

                                                                strcpy($$->value_address,New_label(int_index++,2));

                                                                if(look_up(global,$3->value)!=-1){
                                                                    $$->len = global->variables[look_up(global,$3->value)].size;
                                                                    
                                                                }else if(look_up(local[table_index],$3->value)!=-1){
                                                                    $$->len = local[table_index]->variables[look_up(local[table_index],$3->value)].size;
                                                                }

                                                                // printf("%d\n",$$->len);

                                                                char temp[200];
                                                                sprintf(temp,"%s = %d\n",$$->value_address,$$->len);
                                                                strcat($$->_3AC_Code,temp);

                                                                $$->type = 2;
                                                            }
trailer:        FULLSTOP NAME                                                       {$$ = create_new_node("TRAILER","");node*temp1 = create_new_node(".","");add_new_child($$,temp1);add_new_child($$,$2);}
|               OPEN_SQUARE_BRACKET test CLOSE_SQUARE_BRACKET                       {
                                                                                        $$  = $2;
                                                                                        $$->type = 11;
                                                                                    }
|               OPEN_BRACKET testlist CLOSE_BRACKET                                 {
                                                                                        $$  = $2;


                                                                                        for(int i = $$->no_of_childs-1 ; i >= 0 ; i --){
                                                                                            node*temp = $$->child_nodes[i];
                                                                                            if(strlen(temp->_3AC_Code) == 0)continue;
                                                                                            strcat($$->_3AC_Code,temp->_3AC_Code);
                                                                                        }
                                                                                        for(int i = $$->no_of_childs-1 ; i >= 0 ; i --){
                                                                                            node*temp = $$->child_nodes[i];
                                                                                            char temp1[1000];
                                                                                            sprintf(temp1,"param %s\n",temp->value_address);
                                                                                            strcat($$->_3AC_Code,temp1);
                                                                                        }
                                                                                    }

|               OPEN_BRACKET CLOSE_BRACKET                                          {
                                                                                        $$ = create_new_node("TRAILER","");
                                                                                        size_of_list = 0;
                                                                                    }



testlist :      testlist COMMA test {$$ = $1;add_new_child($$,$3);$$->type = 1;size_of_list += size_of_test($3->type);}
|               test                {node*temp = create_new_node("LIST","");add_new_child(temp,$1);$$ = temp;size_of_list = size_of_test($1->type);}


%%



void yyerror(const char *s) {
  fprintf(stderr,"INVALID INPUT in line:%d and pattern : %s \n",yylineno,yytext); 
}

