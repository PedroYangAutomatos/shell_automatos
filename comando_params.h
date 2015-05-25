// #include <iostream>
// #include <list>
// #include <string>
#include "parametros.h"

using namespace std;

// A variavel VAL_SYS vai ser usada nos indices de tudo
#if defined(WIN32) || defined(_WIN32) || defined(__WIN32) && !defined(__CYGWIN__)
    static const int VAL_SYS = 1; // Windows
#else
    static const int VAL_SYS = 0; // Linux mestre-corrida
#endif

// Essa classe é só para armazenar um comando (e o equivalente na outra plataforma),
// junto com seus parâmetros. Os indíces do array dos parâmetros é a equivalência.
// Ou seja, o params_l[2] e o params_w[2] fazem a mesma coisa, só que em suas
// respectivas plataformas
class ComandoParams{
    private:
        // ["ls", "dir"]... sempre com o linux sendo no indice 0, e windows no indice 1
        std::string comando[2];
        Parametros params_l;
        Parametros params_w;
    public:
        int verifica(std::string);
        std::string comando_equival(std::string);
        std::string param_equival(std::string);
        void adicionar(std::string, std::string, std::vector<std::string>, std::vector<std::string>);
};

// Verifica se o comando recebido faz parte da instância, e retorna o índice dele
int ComandoParams::verifica(std::string cmd_i){
    if (cmd_i.compare(comando[0]) == 0){
        return 0;
    }
    else{
        if (cmd_i.compare(comando[1]) == 0){
            return 1;
        }
    }

    return -1;
}

// Retorna o comando equivalente do sistema, ou o próprio comando se ele
// for o correto
std::string ComandoParams::comando_equival(std::string cmd_i){
    // Se existir o comando no std::string comando[], retorno o comando
    // do sistema (mesmo se o input já for o certo, não tem problema)
    if (ComandoParams::verifica(cmd_i) != -1){
        return comando[VAL_SYS];
    }
    else{
        return "";
    }
}

// Retorna o parametro equivalente ao comando inserido.
std::string ComandoParams::param_equival(std::string param_i){
    // ACHO QUE FALTA COLOCAR ALGO RELACIONADO AO VAL_SYS AQUI. SEI LÁ
    int indice;

    indice = params_l.busca(param_i);
    if (indice != -1){ // Eh do linux
        return params_l.obter(indice);
    }
    else{ // Se não for do linux
        indice = params_w.busca(param_i);
        if (indice != -1){ // É do windows
            return params_w.obter(indice);
        }
        else{ // Não existe em nenhum dos dois
            return "";
        }
    }
}

void ComandoParams::adicionar(std::string cl, std::string cw, std::vector<std::string> pl, std::vector<std::string> pw){
    comando[0] = cl;
    comando[1] = cw;
    params_l.copiar_vetor(pl);
    params_w.copiar_vetor(pw);
}
