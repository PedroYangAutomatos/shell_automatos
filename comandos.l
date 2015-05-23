%{
    #include <cstdio>
    #include <iostream>
    using namespace std;
    #define YY_DECL extern "C" int yylex()
    
    #include "comandos.tab.h"  // to get the token types that we return
%}

%%
[\t]    ;
"ls"    return LS_DIR;
"dir"   return LS_DIR;
"-"     return INICIO_PARAMS;
"l"     return LS_DIR_LISTA;
"a"     return LS_DIR_LISTA;
[\n]    return FIM;
.       ;
%%