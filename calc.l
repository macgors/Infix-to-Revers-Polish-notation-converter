%option noyywrap
%option yylineno
%{

#include "calc.y.hpp"

int yylex();
%}

%x COMMENT

%%
^#(.|\\\n)*\n   ;
\\\n            ;
[[:blank:]]+ 	;
[0-9]+	        { yylval = atoi(yytext); return VAL; }
\(              { return LBRACKET; }
\)              { return RBRACKET; }
\n              { return END; }
"+"             { return PLUS; }
"-"             { return MINUS; }
"*"             { return MULT; }
"/"             { return DIV; }
"%"             { return MOD; }
"^"             { return POW; }
.               { return ERROR; }
%%