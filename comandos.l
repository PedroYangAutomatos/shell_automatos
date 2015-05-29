%{
    #include <cstdio>
    #include <iostream>
    #include <string>
    using namespace std;
    #define YY_DECL extern "C" int yylex()
    
    #include "comandos.tab.h"  // to get the token types that we return
%}

%%
[\t]    ;
"-"     { yylval.cval = strdup(yytext); return INICIO_PARAMS_LINUX; }
^ls      { yylval.cval = strdup(yytext); return LS; }
l     { yylval.cval = strdup(yytext); return LS_LISTA; }
a     { yylval.cval = strdup(yytext); return LS_OCULTOS; }
s     { yylval.cval = strdup(yytext); return LS_DIR_TAMANHO; }

^"dir"   { yylval.cval = strdup(yytext); return DIR; }
"/w"    { yylval.cval = strdup(yytext); return DIR_LISTA; }
"h"     { yylval.cval = strdup(yytext); return DIR_OCULTOS; }
"/a"    { yylval.cval = strdup(yytext); return DIR_INI_ATTR; }
"/o"    { yylval.cval = strdup(yytext); return DIR_INI_ORD; }
[\n]    return FIM; //{ yylval.cval = strdup(yytext); return FIM; }

^"cd"    { yylval.cval = strdup(yytext); return MUDA_DIR; }
"/"[a-zA-Z]+ { yylval.cval = strdup(yytext); return ID_DIRETORIOS; }

^"pwd"   { yylval.cval = strdup(yytext); return LOCAL_ATUAL; }

.       ;
%%