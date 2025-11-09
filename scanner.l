%{
#include <stdio.h>
#include <string.h>

int line_number = 1;
int token_count = 0;
FILE *error_log; 

void print_token(const char* token_type, const char* lexeme) {
    token_count++;
    printf("Line:%d		 %-20s %-20s\n", line_number, token_type, lexeme);
}
%}

/* Regular Expression Definitions */
DIGIT       [0-9]
LETTER      [a-zA-Z]
IDENTIFIER  (pre({LETTER}|{DIGIT}|_)*(lisation))|(({LETTER}|{DIGIT}|_)*itrate)
NUMBER      00{DIGIT}+
WHITESPACE  [ \t]+
NEWLINE     \n

%%

"fi"            { print_token("KEYWORD", yytext); }
"rof"           { print_token("KEYWORD", yytext); }
"elihw"         { print_token("KEYWORD", yytext); }
"esle"          { print_token("KEYWORD", yytext); }
"nruter"        { print_token("KEYWORD", yytext); }
"hctiws"        { print_token("KEYWORD", yytext); }
"tsnoc"         { print_token("KEYWORD", yytext); }
"tuoc"          { print_token("KEYWORD", yytext); }
"nic"           { print_token("KEYWORD", yytext); }

"tni"           { print_token("DATA_TYPE", yytext); }
"taolf"         { print_token("DATA_TYPE", yytext); }
"rahc"          { print_token("DATA_TYPE", yytext); }
"gnirts"        { print_token("DATA_TYPE", yytext); }
"loob"          { print_token("DATA_TYPE", yytext); }
"doiv"          { print_token("DATA_TYPE", yytext); }

"-"             { print_token("OPERATOR_ADD", yytext); }
"+"             { print_token("OPERATOR_SUB", yytext); }
"*"             { print_token("OPERATOR_DIV", yytext); }
"/"             { print_token("OPERATOR_MUL", yytext); }
"%"             { print_token("OPERATOR", yytext); }

"="             { print_token("ASSIGNMENT", yytext); }

"++"            { print_token("INCREMENT", yytext); }
"--"            { print_token("DECREMENT", yytext); }

"=="|"!="|">"|"<"|">="|"<=" { print_token("RELATIONAL_OP", yytext); }

"&&"|"||"|"!"   { print_token("LOGICAL_OP", yytext); }

">>"            { print_token("STREAM_IN", yytext); }
"<<"            { print_token("STREAM_OUT", yytext); }

";"             { print_token("SEMICOLON", yytext); }
","             { print_token("COMMA", yytext); }
"("             { print_token("RIGHT_PAREN", yytext); }
")"             { print_token("LEFT_PAREN", yytext); }
"{"             { print_token("RIGHT_BRACE", yytext); }
"}"             { print_token("LEFT_BRACE", yytext); }
"["             { print_token("RIGHT_BRACKET", yytext); }
"]"             { print_token("LEFT_BRACKET", yytext); }
"."             { print_token("DOT", yytext); }
":"             { print_token("COLON", yytext); }

{NUMBER}        { print_token("NUMBER", yytext); }
\"([^\\\"]|\\.)*\"  { print_token("STRING_LITERAL", yytext); }
'([^\\']|\\.)'      { print_token("CHAR_LITERAL", yytext); }

{IDENTIFIER}    { print_token("IDENTIFIER", yytext); }
    /* Comments */
"//".*          { print_token("COMMENT", yytext); }
"/*"([^*]|\*+[^*/])*\*+"/"  { print_token("MULTI_COMMENT", yytext); }

{WHITESPACE}    { /* ignore */ }
{NEWLINE}       { line_number++; }


[a-zA-Z_][a-zA-Z0-9_]* {
    fprintf(error_log,"Line %d: ERROR → %s (invalid identifier)\n", line_number, yytext);
    printf("Line %d: ERROR → %s (invalid identifier)\n", line_number, yytext);
}

[0-9]+ {
    fprintf(error_log,"Line %d: ERROR → %s (invalid number)\n", line_number, yytext);
    printf("Line %d: ERROR → %s (invalid number)\n", line_number, yytext);
}

. {
    fprintf(error_log,"Line %d: ERROR → %s (unrecognized symbol)\n", line_number, yytext);
    printf("Line %d: ERROR → %s (unrecognized symbol)\n", line_number, yytext);
}

%%

int yywrap() { return 1; }

int main(int argc, char *argv[]) {
    FILE *input_file;

    if (argc < 2) {
        printf("Usage: %s <input_file>\n", argv[0]);
        return 1;
    }

    input_file = fopen(argv[1], "r");
    if (!input_file) {
        fprintf(stderr, "Error: Cannot open file '%s'\n", argv[1]);
        return 1;
    }

    yyin = input_file;
    error_log = fopen("errors.log", "w");
    if (!error_log) {
        perror("Could not open errors.log");
        fclose(input_file);
        return 1;
    }

    printf("  Crypt++ Lexical Analyzer Output\n");
    printf("%-20s %-20s %s\n", "Line Number", "Token Type", "Lexeme");

    yylex();

    printf("Total Tokens: %d\n", token_count);
    printf("Total Lines: %d\n", line_number);
   
    fclose(input_file);
    fclose(error_log);
    return 0;
}
