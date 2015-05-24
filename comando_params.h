#include <iostream>
#include <list>
#include <string>
#include "celula.h"

using namespace std;

// A variavel VAL_SYS vai ser usada nos indices de tudo
#if defined(WIN32) || defined(_WIN32) || defined(__WIN32) && !defined(__CYGWIN__)
    static const int VAL_SYS = 1; // Windows
#else
    static const int VAL_SYS = 0; // Linux mestre-corrida
#endif

class ComandoParams{
    private:
        Celula comando; // ["ls", "dir"], ou de parametros ["l", "a", "s"]
        Celula params_l;
        Celula params_w;
    public:
        string comando_equival(string);
        string param_equival(string);
};

string ComandoParams::comando_equival(string cmd_i){
    if (comando.verifica(cmd_i)){
        return comando.obter(VAL_SYS);
    }
    else{
        return "";
    }
}

string ComandoParams::param_equival(string param_i){
    int indice;
    indice = params_l.busca(param_i);

    if (indice != -1){ // Eh do linux
        return params_l.obter(indice);
    }
    else{ // 
        indice = params_w.busca(param_i);
        if (indice != -1){
            return params_w.obter(indice);
        }
        else{
            return "";
        }
    }
}