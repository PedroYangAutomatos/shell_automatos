%{
    #include <iostream>
    #include <cstdlib>
    #include <string>
    #include <vector>
    #include <cstdio>
    #include "lista_comandos.h"
    using namespace std;

    ListaComandos cmds_aceitos;

    std::string comando_param_inicial = "";
    std::string comando_param_final = "";
    std::string comando_final = "";
    std::string params_final = "";
    std::string comando_input = "";
    std::string params_input = "";
    
    // Declaração de escopo
    extern "C" int yylex();
    extern "C" int yyparse();
    extern "C" char *yytext;

    // A variavel VAL_SYS_C vai ser usada nos indices de tudo
    // #if defined(WIN32) || defined(_WIN32) || defined(__WIN32) && !defined(__CYGWIN__)
    //     static const int VAL_SYS_C = 1; // Windows
    // #else
    //     static const int VAL_SYS_C = 0; // Linux mestre-corrida
    // #endif
    
    void yyerror(const char *s);
    void limpa_comando();
    void guarda_comando(const char *s);
    void guarda_parametro(const char *s);
    void popular_comandos_equivalentes();
%}

%union{
    int ival;
    float fval;
    char *cval;
}

%token <cval> INICIO_PARAMS_LINUX;
%token <cval> LS;
%token <cval> LS_LISTA;
%token <cval> LS_OCULTOS;
%token <cval> LS_DIR_TAMANHO;
%token <cval> DIR;
%token <cval> DIR_OCULTOS;
%token <cval> DIR_LISTA;
%token <cval> DIR_INI_ATTR;
%token <cval> DIR_INI_ORD;
%token <cval> MUDA_DIR;
%token <cval> ID_DIRETORIOS;
%token <cval> LOCAL_ATUAL;
%token <cval> CLEAR;
%token <cval> CLS;
%token <cval> DISCO_WINDOWS;


%token FIM;
%%

input:
    ls_fim
    | dir_fim
    | muda_dir_fim
    | local_atual_fim
    | limpa_tela_fim

ls_fim:
    ls
    | ls FIM
ls:
    LS { guarda_comando($1); } INICIO_PARAMS_LINUX { guarda_parametro($3); } ls_params
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
dir_multi_params:
    dir_params
    | dir_multi_params dir_params
dir_params:
    DIR_INI_ATTR { guarda_parametro($1); } dir_attr_params
    | DIR_INI_ORD { guarda_parametro($1); } dir_ord_params
    | DIR_LISTA { guarda_parametro($1); }
dir_attr_params:
    dir_attr_params dir_attr_param
    | dir_attr_param
dir_attr_param:
    DIR_OCULTOS { guarda_parametro($1); }
dir_ord_params:
    dir_ord_params dir_ord_param
    | dir_ord_param
dir_ord_param:
    LS_DIR_TAMANHO { guarda_parametro($1); }

muda_dir_fim:
    muda_dir
    | muda_dir FIM
muda_dir:
    MUDA_DIR { guarda_comando($1); }
    | MUDA_DIR {guarda_comando($1); } diretorios
diretorios:
    diretorios_windows_disco
    | diretorios_caminho
diretorios_caminho:
    ID_DIRETORIOS { guarda_parametro($1); }
    | ID_DIRETORIOS { guarda_parametro($1); } diretorios_caminho
diretorios_windows_disco:
    DISCO_WINDOWS { guarda_parametro($1); } diretorios_caminho

local_atual_fim:
    LOCAL_ATUAL { guarda_comando($1); } FIM

limpa_tela_fim:
    CLEAR { guarda_comando($1); } FIM
    | CLS { guarda_comando($1); } FIM

%%

int main(int, char**) {
    popular_comandos_equivalentes();
    do{
        limpa_comando();
        yyparse();
        comando_param_final.append(comando_final);
        comando_param_final.append(" ");
        comando_param_final.append(params_final);
        system(comando_param_final.c_str());
        cout << "COMANDO=" << comando_param_final << endl;
    } while(1);
}

void popular_comandos_equivalentes(){
    cmds_aceitos.adicionar_comando("ls", "dir");
    cmds_aceitos.adicionar_comando("cd", "cd");
    cmds_aceitos.adicionar_comando("pwd", "cd");
    cmds_aceitos.adicionar_comando("clear", "cls");
}

// Função para limpar os comandos gravados da última entrada
void limpa_comando(){
    comando_param_inicial = "";
    comando_param_final = "";
    comando_final = "";
    params_final = "";
    comando_input = "";
    params_input = "";
}

void guarda_comando(const char *s){
    comando_input = s;
    comando_final = cmds_aceitos.comando_equival_str(s);
}

void guarda_parametro(const char *s){
    std::string params_temp = s;

    // É DIFERENTE DO SISTEMA, TEM QUE TRATAR
    if (cmds_aceitos.comando_equival_str(comando_input).compare(comando_input) != 0){

    //     // LS E DIR
        if (comando_input.compare("ls") == 0 || comando_input.compare("dir") == 0){
            // LS
            if (comando_input.compare("ls") == 0){
                if (params_temp.compare("s") == 0){
                    params_final.append(" /o s");
                }
                if (params_temp.compare("a") == 0){
                    params_final.append(" /a h");
                }
                if (params_temp.compare("l") == 0){
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
                    params_final.append("l");
                }
                if (params_temp.compare("h") == 0){
                    params_final.append("a");
                }
                if (params_temp.compare("s") == 0){
                    params_final.append("s");
                }
            }
        } // LS E DIR

        // CD
        if (comando_input.compare("cd") == 0){
            params_final.append(s);
        } // CD


    } // SISTEMA

    else{
        params_final.append(s);
    }
    // Se tiver no linux
    if (comando_input.compare("cd") == 0){
        if (VAL_SYS == 0){
            // Se tiver o disco como fazemos no windows. Exemplo: c:/
            if (params_final.find_first_of(":") == 1){
                params_final.erase(0, 2);
            }
        }
    }
//     // params_final.append(cmds_aceitos.param_equival_str(s, comando_input));
}

void yyerror(const char *s) {
    cout << "ERRO: COMANDO DESCONHECIDO!" << s << endl;
}
