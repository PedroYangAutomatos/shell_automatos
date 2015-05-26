%{
    #include <iostream>
    #include <cstdlib>
    #include <string>
    #include <vector>
    #include <cstdio>
    #include "lista_comandos.h"
    using namespace std;

    ListaComandos cmds_aceitos;

    std::string comando_final = "";
    std::string params_final = "";
    std::string comando_input = "";
    std::string params_input = "";

    std::string temp_param = "";
    
    // Declaraao de escopo
    extern "C" int yylex();
    extern "C" int yyparse();
    extern "C" char *yytext;

    // A variavel VAL_SYS_C vai ser usada nos indices de tudo
    #if defined(WIN32) || defined(_WIN32) || defined(__WIN32) && !defined(__CYGWIN__)
        static const int VAL_SYS_C = 1; // Windows
    #else
        static const int VAL_SYS_C = 0; // Linux mestre-corrida
    #endif
    
    void yyerror(const char *s);
    void limpa_comando();
    void redireciona_comando();
    void ls_dir_comando();
    void lista_diretorio();
    void lista_diretorio_l();
    void guarda_comando(const char *s);
    void guarda_parametro(const char *s);
    void teste();
%}

%union{
    int ival;
    float fval;
    char *cval;
}

%token <cval> INICIO_PARAMS_LINUX;
%token <cval> INICIO_PARAMS_WINDOWS;
%token <cval> LS;
%token <cval> LS_LISTA;
%token <cval> LS_OCULTOS;
%token <cval> LS_DIR_TAMANHO;
%token <cval> DIR;
%token <cval> DIR_OCULTOS;
%token <cval> DIR_LISTA;
%token <cval> DIR_INI_ATTR;
%token <cval> DIR_INI_ORD;

%token FIM;
%%

input:
    ls_fim
    | dir_fim

ls_fim:
    ls
    | ls FIM
ls:
    LS { guarda_comando($1); } INICIO_PARAMS_LINUX ls_params
    | LS { guarda_comando($1); }
ls_params:
    ls_param
    | ls_params ls_param
ls_param:
    LS_LISTA { guarda_parametro($1); }
    | LS_OCULTOS { guarda_parametro($1); }
    | LS_DIR_TAMANHO { guarda_parametro($1); }



dir_fim:
    dir
    | dir FIM
dir:
    DIR { guarda_comando($1); }
    | DIR { guarda_comando($1); } dir_multi_params 
    | DIR { guarda_comando($1); } dir_multi_unico
    | DIR { guarda_comando($1); } dir_multi_unico dir_multi_params
    | DIR { guarda_comando($1); } dir_multi_params dir_multi_unico
dir_multi_unico:
    dir_unico_param
    | dir_multi_unico dir_unico_param
dir_multi_params:
    dir_params
    | dir_multi_params dir_params
dir_params:
    DIR_INI_ATTR { guarda_parametro($1); } dir_attr_params
    | DIR_INI_ORD { guarda_parametro($1); } dir_ord_params
dir_attr_params:
    dir_attr_params dir_attr_param
    | dir_attr_param
dir_attr_param:
    DIR_OCULTOS { guarda_parametro($1); }
    | DIR_LISTA { guarda_parametro($1); }
dir_ord_params:
    dir_ord_params dir_ord_param
    | dir_ord_param
dir_ord_param:
    LS_DIR_TAMANHO { guarda_parametro($1); }
dir_unico_param:
    DIR_LISTA { guarda_parametro($1); }
%%

int main(int, char**) {
    std::vector<std::string> vtmp_l(3);
    std::vector<std::string> vtmp_w(5);
    vtmp_l[0] = "l";
    vtmp_l[1] = "a";
    vtmp_l[2] = "s";
    vtmp_w[0] = "/w";
    vtmp_w[1] = "h";
    vtmp_w[2] = "s";
    vtmp_w[3] = "/a";
    vtmp_w[4] = "/o";
    cmds_aceitos.adicionar_comando("ls", "dir", vtmp_l, vtmp_w);
    do{
        limpa_comando();
        yyparse();
        // redireciona_comando();
        cout << "CMD: " << comando_final << "; PARAMS: " << params_final << endl;
    } while(1);
}

// Função para limpar os comandos gravados da última entrada
void limpa_comando(){
    comando_final = "";
    params_final = "";
    comando_input = "";
    params_input = "";
}

// Função que redireciona para qual função do bash chamar: ls_dir, pwd, cd, etc...
void redireciona_comando(){
    // Preciso ter algo para ver os comandos válidos.
    if (comando_input.compare("ls") == 0 ||
       comando_input.compare("dir") == 0){
            ls_dir_comando();
    }
}

// Função para exibir os diretórios, independente do ls ou dir
void ls_dir_comando(){

    int sistema;
    if (comando_input.compare("ls") == 0){
        sistema = 0;
    }
    else{
        if (comando_input.compare("dir") == 0){
            sistema = 1;
        }
        else{
            sistema = -1;
        }
    }

    // Se o comando for igual ao
    if (sistema == VAL_SYS){

    }
}

void guarda_comando(const char *s){
    comando_input = s;
    comando_final = cmds_aceitos.comando_equival_str(s);
    cout << "CMDACTS: " << cmds_aceitos.comando_equival_str(s) << endl;
}

void guarda_parametro(const char *s){
    cout << "teste ci: " << comando_input << endl;
    std::string params_temp = s;
     
    // É DIFERENTE DO SISTEMA, TEM QUE TRATAR
    // if (cmds_aceitos.comando_equival_str(comando_input).compare(comando_input) != 0){
        // LS E DIR
        // if (params_temp == cmds_aceitos.comando_equival_str("ls")){
            // LS
            if (comando_input.compare("ls") == 0){
                if (params_temp.compare("s") == 0){
                    // cout << "ENTREI s" << endl;
                    params_final.append(" /o s");
                }
                if (params_temp.compare("a") == 0){
                    // cout << "ENTREI a" << endl;
                    params_final.append(" /a h");
                }
                if (params_temp.compare("l") == 0){
                    // cout << "ENTREI l" << endl;
                    params_final.append(" /w");
                }
            }
            // DIR
            if (comando_input.compare("dir") == 0){
                // se não tiver '-', adicione
                if (params_final.find_first_of("-") == -1){
                    params_final.append(" -");
                }
                if (params_temp.compare("/w") == 0){
                    cout << "entrei w" << endl;
                    params_final.append("l");
                }
                if (params_temp.compare("h") == 0){
                    params_final.append("a");
                }
                if (params_temp.compare("s") == 0){
                    params_final.append("s");
                }
            }
        // }
    // }

    // SE FOR IGUAL AO DO SISTEMA, ACHO QUE NÃO PRECISA TRATAR.
    // else{

    // }
    // params_final.append(cmds_aceitos.param_equival_str(s, comando_input));
}

void teste(){
    cout << "entrei" << endl;
}

void yyerror(const char *s) {
    cout << "EEK, parse error!  Message: " << s << endl;
}
