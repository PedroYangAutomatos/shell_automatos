// #include <iostream>
// #include <cstdlib>
// #include <string>
// #include <vector>
#include "comando_params.h"

using namespace std;

class ListaComandos{
    private:
        std::vector<ComandoParams> comandos;
    public:
        int procura_comando(std::string);
        int tam();
        void aumentar_tamanho();
        // void adicionar_elemento(std::string);
        ComandoParams busca_indice(int);
        void adicionar_comando(std::string, std::string, std::vector<std::string>, std::vector<std::string>);
};

// Retorna o índice do comando na lista, ou -1 se não achou
int ListaComandos::procura_comando(std::string comando){
    int tam = ListaComandos::tam();
    int indice_comando = -1;

    cout << "tam=" << tam << endl;

    if (tam > 0){
        int i = 0;
        while (i < tam){
        // for(int i = 0; tam; i++){
            cout << "iu= " << i << endl;
            indice_comando = comandos[i].verifica(comando);
            i++;
        }
    }
    // Se tem um índice para esse comando
    if (indice_comando != -1){
        return indice_comando;
    }

    return -1;
}

int ListaComandos::tam(){
    return comandos.size();
}

// Aumenta o tamanho da lista de comandos em um elemento
void ListaComandos::aumentar_tamanho(){
    comandos.resize(comandos.size() + 1);
}

// void ListaComandos::adicionar_elemento(std::string elem){
//    ListaComandos::aumentar_tamanho();
//    comandos[comandos.size() + 1] = elem;
// }

ComandoParams ListaComandos::busca_indice(int indice){
    if (ListaComandos::tam() < indice){
        exit(1);
    }
    else{
        return comandos[indice];
    }
}

void ListaComandos::adicionar_comando(std::string cl, std::string cw, std::vector<std::string> pl, std::vector<std::string> pw){
    ListaComandos::aumentar_tamanho();
    int tamanho = ListaComandos::tam() - 1;

    if (tamanho < 0){
        return;
    }

    comandos[tamanho].adicionar(cl, cw, pl, pw);
}
