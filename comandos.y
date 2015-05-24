%{
    #include <cstdio>
    #include <iostream>
    #include <string>
    using namespace std;

    const char *comando_completo = "a";
    std::string comando_final = "";
    std::string comando_input = "";
    std::string params_input = "";
    
    // Declaraao de escopo
    extern "C" int yylex();
    extern "C" int yyparse();
    extern "C" char *yytext;
    
    void yyerror(const char *s);
    void lista_diretorio();
    void lista_diretorio_l();
    void guarda_comando(const char *s);
    void guarda_parametro(const char *s);
    void pteste(const char *s);
%}

%union{
    int ival;
    float fval;
    char *ccval;
}

%token <ccval> INICIO_PARAMS_LINUX;
%token <ccval> INICIO_PARAMS_WINDOWS;
%token <ccval> LS;
%token <ccval> LS_LISTA;
%token <ccval> LS_OCULTOS;
%token <ccval> LS_TAMANHO;
%token <ccval> DIR;
%token <ccval> DIR_OCULTOS;
%token <ccval> DIR_LISTA;
%token <ccval> DIR_TAMANHO;

%token FIM;
%%

ls_fim:
    ls
    | ls FIM

ls:
    LS INICIO_PARAMS_LINUX ls_params { guarda_comando($1); }
    | LS { guarda_comando($1); }

ls_params:
    ls_param
    | ls_params ls_param

ls_param:
    LS_LISTA { guarda_parametro($1); }
    | LS_OCULTOS { guarda_parametro($1); }
    | LS_TAMANHO { guarda_parametro($1); }

%%

int main(int, char**) {
    do{
        yyparse();
    } while(1);
}

void guarda_comando(const char *s){
    comando_input.append(s);
    cout << "ci: " << comando_input << endl;
}

void guarda_parametro(const char *s){
    params_input.append(s);
    cout << "pi: " << params_input << endl;
}

void yyerror(const char *s) {
    cout << "EEK, parse error!  Message: " << s << endl;
}