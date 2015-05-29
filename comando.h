#include <iostream>
#include <cstdlib>
#include <string>
#include <cstdio>

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
class Comando{
    private:
        // ["ls", "dir"]... sempre com o linux sendo no indice 0, e windows no indice 1
        std::string comando[2];
    public:
        int verifica(std::string);
        std::string comando_equival(std::string);
        void adicionar(std::string, std::string);
};

// Verifica se o comando recebido faz parte da instância, e retorna o índice dele
int Comando::verifica(std::string cmd_i){
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
std::string Comando::comando_equival(std::string cmd_i){
    // Se existir o comando no std::string comando[], retorno o comando
    // do sistema (mesmo se o input já for o certo, não tem problema)
    if (Comando::verifica(cmd_i) != -1){
        return comando[VAL_SYS];
    }
    else{
        return "";
    }
}

void Comando::adicionar(std::string cl, std::string cw){
    comando[0] = cl;
    comando[1] = cw;
}
