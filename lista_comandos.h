#include <vector>
#include "comando.h"

using namespace std;

class ListaComandos{
    private:
        std::vector<Comando> comandos;
    public:
        int procura_comando(std::string);
        int tam();
        void aumentar_tamanho();
        Comando busca_indice(int);
        void adicionar_comando(std::string, std::string);
        std::string comando_equival_str(std::string);
};

// Retorna o índice do comando na lista, ou -1 se não achou
int ListaComandos::procura_comando(std::string comando){
    int tam = ListaComandos::tam();
    int indice_comando = -1;


    if (tam > 0){
        int i = 0; // i = indice de std::vector<Comando> comandos
        while (i < tam){
            indice_comando = comandos[i].verifica(comando);
            // Se achou, tenho que sair e não cagar na variável
            if (indice_comando == 0 || indice_comando == 1)
                return i; // RETORNO O INDICE DA LISTA DESSA CLASSE, E NÃO O INDÍCE 0 OU 1 DA CLASSE Comando
            i++;
        }
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

Comando ListaComandos::busca_indice(int indice){
    if (ListaComandos::tam() < indice)
        exit(1);
    else
        return comandos[indice];
}

void ListaComandos::adicionar_comando(std::string cl, std::string cw){
    ListaComandos::aumentar_tamanho();
    int tamanho = ListaComandos::tam() - 1;

    if (tamanho < 0)
        return;

    comandos[tamanho].adicionar(cl, cw);
}

std::string ListaComandos::comando_equival_str(std::string cmd_i){
    int indice; // indice de std::vector<Comando> comandos
    indice = ListaComandos::procura_comando(cmd_i);

    if (indice != -1){
        return comandos[indice].comando_equival(cmd_i);
    }
    else{
        return "";
    }
}
