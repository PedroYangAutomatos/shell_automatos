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
"-"     { yylval.ccval = strdup(yytext); return INICIO_PARAMS_LINUX; }
"/"     { yylval.ccval = strdup(yytext); return INICIO_PARAMS_WINDOWS; }
"ls"    { yylval.ccval = strdup(yytext); return LS; }
"l"     { yylval.ccval = strdup(yytext); return LS_LISTA; }
"a"     { yylval.ccval = strdup(yytext); return LS_OCULTOS; }
"s"     { yylval.ccval = strdup(yytext); return LS_TAMANHO; }
"dir"   { yylval.ccval = strdup(yytext); return DIR; }
"h"     { yylval.ccval = strdup(yytext); return DIR_OCULTOS; }
"L"     { yylval.ccval = strdup(yytext); return DIR_LISTA; }
"S"     { yylval.ccval = strdup(yytext); return DIR_TAMANHO; }
[\n]    { yylval.ccval = strdup(yytext); return FIM; }
.       ;
%%