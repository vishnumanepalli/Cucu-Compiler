%{
#include<stdio.h>
void yyerror(const char* msg);int yylex();
#define YYSTYPE char*
extern FILE* output;
extern FILE* parse;
extern FILE* yyin;

%}

%token num op semi assign type id whilel ifl elsel opbpar clbpar opfpar clfpar opspar clspar string comp printl ret comma forl pp

%%
Es : E Es | E;
E : fundef|vardec| fundec;
vardec :  type id{fprintf(parse,"id = %s\n",$2);} assign expt semi| type id semi{fprintf(parse,"id %s\n",$2);};
K : type id {fprintf(parse,"id %s\n",yylval);} opbpar args clbpar ;
fundef : K semi;
fundec : K{fprintf(parse,"\nfun_body \n");}opfpar Ts clfpar |K {fprintf(parse,"fun_body \n");}opfpar clfpar ;

args : type id {fprintf(parse,"fun_arg %s\n",yylval);}comma args | type id{fprintf(parse,"fun_arg %s\n",yylval);}|;
Ts : T semi Ts |X Ts|;
X :  I  | W | A ;
A : forl {fprintf(parse,"\nfor open\n");}opbpar na semi nao semi B clbpar opfpar Ts clfpar{fprintf(parse,"for close\n\n");};
na : F | ;
nao : expt |;
B : id {fprintf(parse,"local_var: %s",$1);} pp {fprintf(parse,"postinc: %s\n",yylval);} | pp {fprintf(parse,"\npreinc: %s",$1);} id {fprintf(parse,"local_var: %s\n",$2);} |expt;
call : id {fprintf(parse,"var-%s\n",yylval);}opbpar par clbpar;
par : {fprintf(parse,"fun_par");} pa J | ;
J : comma {fprintf(parse,"fun_par\n");} pa J | ;
pa : expt | id{fprintf(parse,"var %s\n",$1);} | num{fprintf(parse,"const %s\n",$1);};
T : F |ph|  call {fprintf(parse,"fun_call\n");}| re{fprintf(parse,"ret\n");};
ph : printl {fprintf(parse,"print stmt open\n");}opbpar string J clbpar {fprintf(parse,"print stmt close\n");};
I : ifl {fprintf(parse,"\nif begins\n");}opbpar {fprintf(parse,"\nbineexpr begins\n");}binexpr {fprintf(parse,"\nbineexpr ends\n\n");}clbpar opfpar Ts clfpar {fprintf(parse,"if ends \nelse begin\n");}elsel opfpar Ts clfpar {fprintf(parse,"else ends\n\n");}| ifl{fprintf(parse,"if begins\n");} opbpar {fprintf(parse,"\nbineexpr begins\n");}binexpr {fprintf(parse,"\nbineexpr ends\n");} clbpar opfpar Ts clfpar{fprintf(parse,"if ends\n\n");} ;
W : whilel {fprintf(parse,"\nwhile begins\n");}opbpar binexpr clbpar opfpar Ts clfpar {fprintf(parse,"while ends\n\n");};
binexpr : expt comp {fprintf(parse,"comp-%s ",$2);}expt {fprintf(parse,"\n");};
F : type  id {fprintf(parse,"local_var: %s\n",$2);} N ajk|type  id {fprintf(parse,"local_var: %s\n",$2);}assign expt  N ajk|id {fprintf(parse,"local_var: %s",$1);} assign{fprintf(parse," op:= ");} expt;
ajk: comma id {fprintf(parse,"var %s\n",$2);}assign{fprintf(parse,"op =");} expt ajk | comma id {fprintf(parse,"var %s\n",$2);}ajk |;
N: assign expt  {fprintf(parse,"assign\n");}| ;
expt : id {fprintf(parse,"var: %s ",$1);} | num{fprintf(parse,"const: %s ",yylval);} |opbpar expt clbpar | git|call;
git: expt op {fprintf(parse,"op %s",yylval);}expt | get;
get:expt comp {fprintf(parse,"op %s",yylval);}expt |got;
got:id assign {fprintf(parse,"op = ");} expt |  id {fprintf(parse,"var: %s []",yylval);} opspar expt clspar  ;
re : ret expt;
%%

int main(int argc , char**argv)
{
    output = fopen("lexer.txt", "w");
    yyin = fopen(argv[1], "r");
    parse = fopen("parser.txt", "w");
	yyparse();
}

void yyerror(const char* msg)
{
	fprintf(parse,"Wrong\n");
}
int yywrap()
{
    return(1);
}
