%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex();
extern int yyparse();
extern FILE *yyin;
extern int line_number;

void yyerror(const char *s);
int error_count = 0;
%}

%union {
    char *str;
}

%token FI ROF ELIHW ESLE NRUTER HCTIWS TSNOC TUOC NIC NIAM
%token TNI TAOLF RAHC GNIRTS LOOB DOIV
%token OPERATOR_ADD OPERATOR_SUB OPERATOR_DIV OPERATOR_MUL OPERATOR_MOD
%token ASSIGNMENT INCREMENT DECREMENT
%token RELATIONAL_OP LOGICAL_OP
%token STREAM_IN STREAM_OUT
%token SEMICOLON COMMA
%token RIGHT_PAREN LEFT_PAREN  
%token RIGHT_BRACE LEFT_BRACE
%token RIGHT_BRACKET LEFT_BRACKET
%token DOT COLON

%token <str> IDENTIFIER NUMBER STRING_LITERAL CHAR_LITERAL

%start program

%%

program: function_decl
       {
           if (error_count == 0) {
               printf("\n✓ Syntax analysis successful\n");
               printf("✓ Program structure is valid\n");
           }
       }
       ;

function_decl: data_type NIAM RIGHT_PAREN LEFT_PAREN RIGHT_BRACE stmt_list LEFT_BRACE
             {
                 printf("✓ Function declaration parsed: niam\n");
             }
             ;

stmt_list: stmt_list stmt
         | /* empty */
         ;

stmt: decl_stmt
    | assign_stmt
    | cond_stmt
    | loop_stmt
    | io_stmt
    | return_stmt
    | switch_stmt
    | break_stmt
    ;

decl_stmt: data_type IDENTIFIER SEMICOLON
         {
             printf("  Declaration: %s\n", $2);
         }
         | data_type IDENTIFIER ASSIGNMENT expr SEMICOLON
         {
             printf("  Declaration with initialization: %s\n", $2);
         }
         | TSNOC data_type IDENTIFIER ASSIGNMENT expr SEMICOLON
         {
             printf("  Constant declaration: %s\n", $3);
         }
         ;

assign_stmt: IDENTIFIER ASSIGNMENT expr SEMICOLON
           {
               printf("  Assignment: %s\n", $1);
           }
           ;

cond_stmt: FI LEFT_PAREN expr RIGHT_PAREN RIGHT_BRACE stmt_list LEFT_BRACE
         {
             printf("  Conditional statement (fi) parsed\n");
         }
         | FI LEFT_PAREN expr RIGHT_PAREN RIGHT_BRACE stmt_list LEFT_BRACE ESLE RIGHT_BRACE stmt_list LEFT_BRACE
         {
             printf("  Conditional statement (fi-esle) parsed\n");
         }
         ;

loop_stmt: ROF LEFT_PAREN for_init expr SEMICOLON assign_expr RIGHT_PAREN RIGHT_BRACE stmt_list LEFT_BRACE
         {
             printf("  Loop statement (rof) parsed\n");
         }
         | ELIHW LEFT_PAREN expr RIGHT_PAREN RIGHT_BRACE stmt_list LEFT_BRACE
         {
             printf("  Loop statement (elihw) parsed\n");
         }
         ;

for_init: data_type IDENTIFIER ASSIGNMENT expr SEMICOLON
        | IDENTIFIER ASSIGNMENT expr SEMICOLON
        | SEMICOLON
        ;

assign_expr: IDENTIFIER ASSIGNMENT expr
           | IDENTIFIER INCREMENT
           | IDENTIFIER DECREMENT
           ;

switch_stmt: HCTIWS LEFT_PAREN expr RIGHT_PAREN RIGHT_BRACE case_list LEFT_BRACE
           {
               printf("  Switch statement (hctiws) parsed\n");
           }
           ;

case_list: case_list case_stmt
         | case_stmt
         | /* empty */
         ;

case_stmt: FI LEFT_PAREN expr RIGHT_PAREN RIGHT_BRACE stmt_list LEFT_BRACE
         {
             printf("  Case statement parsed\n");
         }
         | ESLE RIGHT_BRACE stmt_list LEFT_BRACE
         {
             printf("  Default case (esle) parsed\n");
         }
         ;

break_stmt: ESLE SEMICOLON
          {
              printf("  Break statement (esle) parsed\n");
          }
          ;

io_stmt: TUOC stream_out_list SEMICOLON
       {
           printf("  Output statement (tuoc) parsed\n");
       }
       | NIC STREAM_IN IDENTIFIER SEMICOLON
       {
           printf("  Input statement (nic) parsed\n");
       }
       ;

stream_out_list: stream_out_list STREAM_OUT expr
               | STREAM_OUT expr
               ;

return_stmt: NRUTER expr SEMICOLON
           {
               printf("  Return statement (nruter) parsed\n");
           }
           ;

expr: IDENTIFIER
    | NUMBER
    | STRING_LITERAL
    | CHAR_LITERAL
    | expr arith_op expr
    | expr RELATIONAL_OP expr
    | expr LOGICAL_OP expr
    | LEFT_PAREN expr RIGHT_PAREN
    | IDENTIFIER INCREMENT
    | IDENTIFIER DECREMENT
    ;

arith_op: OPERATOR_ADD
        | OPERATOR_SUB
        | OPERATOR_MUL
        | OPERATOR_DIV
        | OPERATOR_MOD
        ;

data_type: TNI
         | TAOLF
         | RAHC
         | GNIRTS
         | LOOB
         | DOIV
         ;

%%

void yyerror(const char *s) {
    error_count++;
    fprintf(stderr, "\n✗ Line %d: Syntax Error - %s\n", line_number, s);
}

int main(int argc, char *argv[]) {
    if (argc < 2) {
        printf("Usage: %s <input_file>\n", argv[0]);
        return 1;
    }

    FILE *input = fopen(argv[1], "r");
    if (!input) {
        fprintf(stderr, "Error: Cannot open file '%s'\n", argv[1]);
        return 1;
    }

    printf("\n========================================\n");
    printf("  Crypt++ Parser - Phase 2\n");
    printf("========================================\n");
    printf("Parsing file: %s\n\n", argv[1]);

    yyin = input;
    int parse_result = yyparse();
    
    if (parse_result != 0 || error_count > 0) {
        printf("\n✗ Syntax analysis failed\n");
        printf("✗ Total errors: %d\n", error_count);
    }
    
    printf("========================================\n\n");
    
    fclose(input);
    return (parse_result == 0 && error_count == 0) ? 0 : 1;
}
