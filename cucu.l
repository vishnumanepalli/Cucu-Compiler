%{
#include <stdio.h>
#define YYSTYPE char*
#include "cucu.tab.h"
FILE *output;
FILE* parse;
void yyerror(const char* msg);
%}
%%
\/\*(.)*\*\/   {fprintf(output,"comm :%s\n",yytext);}
\/\/(.)*\n     {fprintf(output,"comm :%s",yytext);}
[\,]           {fprintf(output,"comma: %s\n",yytext);return (comma);}
(if)           {fprintf(output,"key: %s\n",yytext);return (ifl);}
(return)       {fprintf(output,"return : %s\n",yytext);return (ret);}
(else)         {fprintf(output,"key: %s\n",yytext);return (elsel);}
(while)        {fprintf(output,"key: %s\n",yytext);return (whilel);}
(printf)        {fprintf(output,"print: %s\n",yytext);return (printl);}
(for)          {fprintf(output,"forkey: %s\n",yytext);return (forl);}
[0-9]+       {yylval=strdup(yytext);fprintf(output, "NUM : %s\n",yylval);return (num);}
(\+\+|\-\-)           {yylval=strdup(yytext);fprintf(output, "PLUS : ++\n");return (pp);}
[\+]           {yylval=strdup(yytext);fprintf(output, "PLUS : +\n");return (op);}
"=="|"<="|">="|">"|"<"|"&&"|"||"|"!=" {yylval=strdup(yytext);fprintf(output, " comp : %s\n",yytext);return (comp);}
(\-|\-+=)           {yylval=strdup(yytext); fprintf(output, "MINUS : -\n");return (op);}
[;]            {fprintf(output, "SEMI : ;\n");return (semi);}
[\*\/\%]            {yylval=strdup(yytext); fprintf(output, "ASTRIK : *\n");return (op);}
(=|\+=|\-=|\*=|\/=)            {yylval=strdup(yytext); fprintf(output, "ASSIGN : %s\n",yytext);return (assign);}
[&|^]           {yylval=strdup(yytext); fprintf(output,"bit : %s\n",yytext);return (op);}
(int|"char *"|"char")          {fprintf(output, "TYPE : %s\n",yytext);return (type);}
[a-zA-Z][a-zA-Z0-9_]*      {yylval=strdup(yytext); fprintf(output, "ID : %s\n",yytext);return (id);}
[\(]         {fprintf(output,"PAREN : %s\n",yytext);return (opbpar);}
[\)]         {fprintf(output,"PAREN : %s\n",yytext);return (clbpar);}
[\{]         {fprintf(output,"PAREN : %s\n",yytext);return (opfpar);}
[\}]         {fprintf(output,"PAREN : %s\n",yytext);return (clfpar);}
(\"(.*)\")         {fprintf(output,"string : %s\n",yytext);return (string);} 
[\[]               {fprintf(output,"sbop : %s\n",yytext);return (opspar);}
[\]]               {fprintf(output,"sbcl : %s\n",yytext);return (clspar);}
.|\n 
%%
