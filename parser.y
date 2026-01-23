%{
#include <stdio.h>
#include <string.h>

extern int yylex();
extern int yyparse();
extern FILE *yyin;
extern int line_number;
extern char *yytext;

void yyerror(const char *s);
int error_count = 0;
%}

%union {
    char *str;
}

/* Keywords */
%token FI ROF ELIHW ESLE NRUTER TSNOC TUOC NIC NIAM

/* Data types */
%token TNI TAOLF RAHC GNIRTS LOOB DOIV

/* Operators */
%token OPERATOR_ADD OPERATOR_SUB OPERATOR_DIV OPERATOR_MUL OPERATOR_MOD
%token ASSIGNMENT INCREMENT DECREMENT
%token RELATIONAL_OP LOGICAL_OP

/* Streams */
%token STREAM_IN STREAM_OUT

/* Symbols */
%token SEMICOLON COMMA
%token RIGHT_PAREN LEFT_PAREN
%token RIGHT_BRACE LEFT_BRACE
%token RIGHT_BRACKET LEFT_BRACKET
%token DOT COLON

/* Literals */
%token <str> IDENTIFIER NUMBER STRING_LITERAL CHAR_LITERAL

/* Operator precedence */
%left LOGICAL_OP
%left RELATIONAL_OP
%left OPERATOR_ADD OPERATOR_SUB
%left OPERATOR_MUL OPERATOR_DIV OPERATOR_MOD

%start program

%%

program
    : function_decl
      {
          if (error_count == 0) {
              printf("\n========================================\n");
              printf("✓ SYNTAX ANALYSIS SUCCESSFUL\n");
              printf("✓ Program structure is valid\n");
              printf("========================================\n");
          }
      }
    ;

function_decl
    : data_type NIAM LEFT_PAREN RIGHT_PAREN
      LEFT_BRACE stmt_list RIGHT_BRACE
      {
          printf("✓ Function declaration parsed: niam\n");
      }
    ;

stmt_list
    : stmt_list stmt
    | stmt_list error RIGHT_BRACE
      {
          yyerror("Invalid statement block");
          yyerrok;
      }
    | /* empty */
    ;

stmt
    : decl_stmt
    | assign_stmt
    | cond_stmt
    | loop_stmt
    | io_stmt
    | return_stmt
    | error SEMICOLON
      {
          yyerror("Malformed statement");
          yyerrok;
      }
    ;

decl_stmt
    : data_type IDENTIFIER SEMICOLON
      { printf("  Declaration: %s\n", $2); }
    | data_type IDENTIFIER ASSIGNMENT expr SEMICOLON
      { printf("  Declaration with initialization: %s\n", $2); }
    | TSNOC data_type IDENTIFIER ASSIGNMENT expr SEMICOLON
      { printf("  Constant declaration: %s\n", $3); }
    ;

assign_stmt
    : IDENTIFIER ASSIGNMENT expr SEMICOLON
      { printf("  Assignment: %s\n", $1); }
    ;

cond_stmt
    : FI LEFT_PAREN expr RIGHT_PAREN
      LEFT_BRACE stmt_list RIGHT_BRACE
      { printf("  Conditional (fi) parsed\n"); }
    | FI LEFT_PAREN expr RIGHT_PAREN
      LEFT_BRACE stmt_list RIGHT_BRACE
      ESLE LEFT_BRACE stmt_list RIGHT_BRACE
      { printf("  Conditional (fi-esle) parsed\n"); }
    ;

loop_stmt
    : ROF LEFT_PAREN for_init expr SEMICOLON assign_expr RIGHT_PAREN
      LEFT_BRACE stmt_list RIGHT_BRACE
      { printf("  Loop (rof) parsed\n"); }
    | ELIHW LEFT_PAREN expr RIGHT_PAREN
      LEFT_BRACE stmt_list RIGHT_BRACE
      { printf("  Loop (elihw) parsed\n"); }
    ;

for_init
    : data_type IDENTIFIER ASSIGNMENT expr SEMICOLON
    | IDENTIFIER ASSIGNMENT expr SEMICOLON
    | SEMICOLON
    ;

assign_expr
    : IDENTIFIER ASSIGNMENT expr
    | IDENTIFIER INCREMENT
    | IDENTIFIER DECREMENT
    ;

io_stmt
    : TUOC stream_out_list SEMICOLON
      { printf("  Output statement parsed\n"); }
    | NIC STREAM_IN IDENTIFIER SEMICOLON
      { printf("  Input statement parsed\n"); }
    ;

stream_out_list
    : stream_out_list STREAM_OUT expr
    | STREAM_OUT expr
    ;

return_stmt
    : NRUTER expr SEMICOLON
      { printf("  Return statement parsed\n"); }
    ;

expr
    : IDENTIFIER
    | NUMBER
    | STRING_LITERAL
    | CHAR_LITERAL
    | expr OPERATOR_ADD expr
    | expr OPERATOR_SUB expr
    | expr OPERATOR_MUL expr
    | expr OPERATOR_DIV expr
    | expr OPERATOR_MOD expr
    | expr RELATIONAL_OP expr
    | expr LOGICAL_OP expr
    | LEFT_PAREN expr RIGHT_PAREN
    | IDENTIFIER INCREMENT
    | IDENTIFIER DECREMENT
    ;

data_type
    : TNI
    | TAOLF
    | RAHC
    | GNIRTS
    | LOOB
    | DOIV
    ;

%%

void yyerror(const char *s) {
    error_count++;

    fprintf(stderr,
        "\n----------------------------------------\n"
        "✗ SYNTAX ERROR\n"
        "  Line   : %d\n"
        "  Token  : '%s'\n"
        "  Message: %s\n",
        line_number,
        yytext ? yytext : "unknown",
        s
    );

    if (yytext) {
        if (strcmp(yytext, ";") == 0) {
            fprintf(stderr, "  Hint   : Possible empty or malformed statement\n");
        } else if (strcmp(yytext, "}") == 0) {
            fprintf(stderr, "  Hint   : Possible extra '}' or missing statement\n");
        } else if (strcmp(yytext, "(") == 0) {
            fprintf(stderr, "  Hint   : Check expression inside parentheses\n");
        }
    }

    fprintf(stderr,
        "----------------------------------------\n"
    );
}

int main(int argc, char *argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s <input_file>\n", argv[0]);
        return 1;
    }

    yyin = fopen(argv[1], "r");
    if (!yyin) {
        fprintf(stderr, "Error: Cannot open file '%s'\n", argv[1]);
        return 1;
    }

    printf("\n========================================\n");
    printf("  Crypt++ Parser - Phase 2\n");
    printf("========================================\n");
    printf("Parsing file: %s\n\n", argv[1]);

    int result = yyparse();

    printf("\n========================================\n");
    if (error_count == 0 && result == 0) {
        printf("✓ Parsing completed successfully\n");
    } else {
        printf("✗ Parsing failed\n");
        printf("✗ Total syntax errors: %d\n", error_count);
    }
    printf("========================================\n");

    fclose(yyin);
    return (error_count == 0 && result == 0) ? 0 : 1;
}

