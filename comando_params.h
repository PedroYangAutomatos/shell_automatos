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
        Celula params; // 1 para comandos, 2 para params
    public:
        string comando_correto(string);
};

string ComandoParams::comando_correto(string cmd_i){
    if (comando.verifica(cmd_i)){
        return comando.obter(VAL_SYS);
    }
    else{
        return "";
    }
}
