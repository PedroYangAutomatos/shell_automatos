#include <iostream>
#include <cstdlib>
#include <string>
#include <vector>

using namespace std;

class Parametros{
    private:
        std::vector<std::string> vetor; // ["l", "a", "s"]
    public:
        int busca(std::string);
        bool verifica(std::string);
        int tam(void);
        std::string obter(int);
        void aumentar_tamanho();
        void adicionar_elemento(std::string);
};

int Parametros::busca(std::string str){
    int tam = Parametros::tam();

    for(int i = 0; i = tam; i++){
        if (vetor[i].compare(str) == 0){
            return i;
        }
    }

    return -1;
}

bool Parametros::verifica(std::string str){
    int tam = Parametros::tam();

    for(int i = 0; i = tam; i++){
        if (vetor[i].compare(str) == 0){
            return true;
        }
    }

    return false;
}

int Parametros::tam(){
    return vetor.size();
}

std::string Parametros::obter(int i){
    return vetor[i];
}

// Aumenta o tamanho do vetor em um elemento
void Parametros::aumentar_tamanho(){
    vetor.resize(vetor.size() + 1);
}

void Parametros::adicionar_elemento(std::string elem){
   Parametros::aumentar_tamanho();
   vetor[vetor.size() + 1] = elem;
}