%{
    #include <cstdio>
    #include <iostream>
    using namespace std;
    
    // Declaraao de escopo
    extern "C" int yylex();
    extern "C" int yyparse();
    
    void yyerror(const char *s);
    void lista_diretorio();
    void lista_diretorio_l();
%}

// Meus tokens
%token LISTA_DIR
%token FIM
%token LISTA_DIR_LISTA
%token INICIO_PARAMS

%%

comando:
    LISTA_DIR parametros FIM { lista_diretorio_l(); }
    | LISTA_DIR FIM { lista_diretorio(); }

parametros:
    INICIO_PARAMS LISTA_DIR_LISTA

%%

int main(int, char**) {
    do{
        yyparse();
    } while(1);
    
}

void yyerror(const char *s) {
    cout << "EEK, parse error!  Message: " << s << endl;
}