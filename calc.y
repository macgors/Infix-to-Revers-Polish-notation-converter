%{
#define YYSTYPE int

#include<string>
#include<iostream>
#include<cmath>
#include <ctype.h>

using namespace std;

int yylex();
int yyerror(string);
extern int yylineno;


int power(int a, int b) {
    if (b < 0) {
        return 0;
    }
    int res = 1;
    for (int i=0; i<b; i++) {
        res *= a;
    }
    return res;
}

bool error = false;
string resoult_string = "";

%}

%token VAL
%token LBRACKET
%token RBRACKET

%left PLUS MINUS
%left MULT DIV MOD
%right POW
%left NEG

%token END
%token ERROR

%%
input:
    %empty
    | input line
;
line: expr END 	{
                    if (!error) 
                        cout <<"POLISH REVERSE NOTATION: " << resoult_string << endl 
                            << "RESULT = " << $$ << endl;
                    error = false;
                    resoult_string = "";
                }
    | error END	{ 
                    error = false;
                    resoult_string = "";
                }
;
expr: VAL                       { resoult_string += to_string($1) + " "; $$ = $1; }
    | expr PLUS expr            { resoult_string += "+ "; $$ = $1 + $3; }
    | expr MINUS expr           { resoult_string += "- "; $$ = $1 - $3; }
    | expr MULT expr            { resoult_string += "* "; $$ = $1 * $3; }
    | expr DIV expr             { 
                                    resoult_string += "/ ";
                                    if ($3 == 0) {
                                       cout<< "REVERSE POLISH NOTATION:" <<resoult_string<<endl;
                                        yyerror("Division by 0!");
                                        error = true;
                                    } 
                                    else {
                                        $$ = floor((double)$1 / (double)$3); 
                                    }
                                }
    | expr MOD expr             {
                                    resoult_string += "% ";
                                    if ($3 == 0) { 
                                       cout<<"REVERSE POLISH NOTATION:" <<resoult_string<<endl;
                                        yyerror("Division by 0!");
                                        error = true;
                                    } else {
                                        $$ = ($1 % $3 +$3 ) % $3; 
                                    }
                                }
     | MINUS expr %prec NEG      { char temp = resoult_string[resoult_string.length()-2];
                                    if(isdigit(temp)){
                                        resoult_string.pop_back();
                                        resoult_string.pop_back();
                                        resoult_string += "-";
                                        resoult_string.push_back(temp);
                                        resoult_string+=" ";
                                   $$ = -$2;
                                   }
                                   else{
                                       resoult_string+="~ ";
                                       $$ = -$2;
                                   }
                                    }
    | expr POW expr             { resoult_string += "^ "; $$ = power($1, $3); }
    | LBRACKET expr RBRACKET    { $$ = $2; }
%%

int yyerror(string s)
{
    error = true;
    cout<<s<<endl;
    return 0;
}

int main()
{
    yyparse();
    return 0;
}