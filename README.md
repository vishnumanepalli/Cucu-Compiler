# Cucu-Compiler

flex cucu.l
bison -d cucu.y
gcc cucu.tab.c lex.yy.c -lfl -o cucu
./cucu sample1.txt
these are 4 lines used for running the 
the output will be in lexer.txt for lexical analysis
the output will be in parser.txt for syntactical analysis
there may be some errors after running .y file
ignore them.
