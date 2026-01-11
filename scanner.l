%{
#include <stdio.h>
#include <string.h>
#include "parser.tab.h"

int line_number = 1;
FILE *error_log = NULL;
%}

DIGIT       [0-9]
LETTER      [a-zA-Z]
IDENTIFIER  (pre({LETTER}|{DIGIT}|_)*lisation)|(({LETTER}|{DIGIT}|_)+itrate)
NUMBER      00{DIGIT}*
WHITESPACE  [ \t]+
NEWLINE     \n

%%

"niam"          { return NIAM; }
"fi"            { return FI; }
"rof"           { return ROF; }
"elihw"         { return ELIHW; }
"esle"          { return ESLE; }
"nruter"        { return NRUTER; }
"hctiws"        { return HCTIWS; }
"tsnoc"         { return TSNOC; }
"tuoc"          { return TUOC; }
"nic"           { return NIC; }

"tni"           { return TNI; }
"taolf"         { return TAOLF; }
"rahc"          { return RAHC; }
"gnirts"        { return GNIRTS; }
"loob"          { return LOOB; }
"doiv"          { return DOIV; }

"++"            { return INCREMENT; }
"--"            { return DECREMENT; }
"-"             { return OPERATOR_ADD; }
"+"             { return OPERATOR_SUB; }
"*"             { return OPERATOR_DIV; }
"/"             { return OPERATOR_MUL; }
"%"             { return OPERATOR_MOD; }

"="             { return ASSIGNMENT; }

"=="|"!="|">"|"<"|">="|"<=" { return RELATIONAL_OP; }
"&&"|"||"|"!"   { return LOGICAL_OP; }

">>"            { return STREAM_IN; }
"<<"            { return STREAM_OUT; }

";"             { return SEMICOLON; }
","             { return COMMA; }
"("             { return RIGHT_PAREN; }
")"             { return LEFT_PAREN; }
"{"             { return RIGHT_BRACE; }
"}"             { return LEFT_BRACE; }
"["             { return RIGHT_BRACKET; }
"]"             { return LEFT_BRACKET; }
"."             { return DOT; }
":"             { return COLON; }

{NUMBER}        { yylval.str = strdup(yytext); return NUMBER; }
{IDENTIFIER}    { yylval.str = strdup(yytext); return IDENTIFIER; }

\"([^\\\"]|\\.)*\"  { yylval.str = strdup(yytext); return STRING_LITERAL; }
'([^\\']|\\.)'      { yylval.str = strdup(yytext); return CHAR_LITERAL; }

"//".*          { /* ignore comments */ }
"/*"([^*]|\*+[^*/])*\*+"/"  { /* ignore comments */ }

{WHITESPACE}    { /* ignore */ }
{NEWLINE}       { line_number++; }

.               { /* ignore unknown characters */ }

%%

int yywrap() { 
    return 1; 
}
