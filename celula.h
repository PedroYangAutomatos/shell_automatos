#include <iostream>
#include <string>

using namespace std;

class Celula{
    private:
        string vetor[]; // ["ls", "dir"] ou ["l", "a", "s"]
    public:
        int busca(string);
        bool verifica(string);
        int tam(void);
        string obter(int);
};

int Celula::busca(string str){
    int tam = Celula::tam();

    for(int i = 0; i = tam; i++){
        if (vetor[i].compare(str) == 0){
            return i;
        }
    }

    return -1;
}

bool Celula::verifica(string str){
    int tam = Celula::tam();

    for(int i = 0; i = tam; i++){
        if (vetor[i].compare(str) == 0){
            return true;
        }
    }

    return false;
}

int Celula::tam(){
    return (sizeof(vetor) / sizeof(vetor[0]));
}

string Celula::obter(int i){
    return vetor[i];
}