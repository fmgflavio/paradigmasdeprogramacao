#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>

/*
Flávio Mota Gomes - 2018005379 
Rafael Antunes Vieira - 2018000980 
Rafael Greca Vieira - 2018000434
*/

/*
FUNÇÕES DA FILA DE PRIORIDADE
*/

//ir para baixo, esquerda, cima e direita
//será utilizada para movimentar o espaço branco de lugar
int linha[] = {1, 0, -1, 0};
int coluna[] = {0, -1, 0, 1};

typedef struct fila{
    struct no *inicio;
}fila;

typedef struct no{
    int x, y;
    int mat[3][3];
    int custo;
    int nivel;
    struct no *prox;
    struct no *anterior;
    struct no *pai;
}no;

//Cria fila
fila *criaFila(){
    fila *f;
    
    f = (fila*) malloc(sizeof(fila));
    if(!f){
        printf("Erro ao alocar a fila!\n");
        exit(1);
    }
    
    f->inicio = NULL;
    
    return f;
}

//Insere o nó na fila de prioridade
void insereNo(fila *f, no *No){
    //alocar memória e inicializar o novo nó
    no *aux;
    
    //Se a fila estiver vazia insere no começo
    if(f->inicio == NULL){
        f->inicio = No;
        return;
    }else{
        aux = (no *) malloc(sizeof(no));

        if(!aux){
            printf("Erro ao alocar o nó auxiliar!\n");
            exit(-1);
        }

        aux = f->inicio;

        if(aux == NULL){
            f->inicio = No;
            return;
        }

        if(aux->custo + aux->nivel > No->custo + No->nivel){
            aux->anterior = No;
            No->prox = aux;
            f->inicio = No;
            return;
        }
        
        while(aux->prox != NULL && (aux->prox->custo + aux->prox->nivel) < (No->custo + No->nivel)){
            aux = aux->prox;
        }
        
        //Insere o nó na posição correta ou no final da fila
        No->prox= aux->prox;
        aux->prox = No;
        No->anterior = aux;

        if(No->prox != NULL){
            No->prox->anterior = No;
        }
        
        return;
    }
}

//Tira os elementos da lista começando pelo início
no *removeNo(fila *f){
    no *noAux;

    noAux = (no*) malloc(sizeof(no));
    if(!noAux){
        printf("Erro ao alocar a memória!\n");
    }

    if(f->inicio != NULL){
        noAux = f->inicio;
        f->inicio = f->inicio->prox;
    }

    return noAux;
}

//Verifica se a fila está vazia
int filaVazia(fila *f){
    return(f->inicio == NULL);
}

/*
FUNÇÕES DO BRANCH AND BOUND
*/
  
// Function to print N x N matrix 
int imprime_matriz(int mat[3][3]){

    for (int i = 0; i < 3; i++){ 
        for (int j = 0; j < 3; j++){
            printf("%d ", mat[i][j]);
        } 
        printf("\n"); 
    } 
} 

//cria um novo nó
no* criaNo(int inicial[3][3], int x, int y, int nivel, no* pai, int novo_x, int novo_y){ 
    no* novoNo;
    novoNo = (no*) malloc(sizeof(no));
    if(!novoNo){
        printf("Erro ao alocar a memória!\n");
    }

    novoNo->prox = NULL;

    novoNo->anterior = NULL;
    
    novoNo->pai = pai;
  
    //copia o conteúdo da matriz para a variável mat do nó
    memcpy(novoNo->mat, inicial, sizeof novoNo->mat); 
  
    //movo o espaço em branco de lugar
    novoNo->mat[x][y] = novoNo->mat[x][y] + novoNo->mat[novo_x][novo_y];
    novoNo->mat[novo_x][novo_y] = novoNo->mat[x][y] - novoNo->mat[novo_x][novo_y];
    novoNo->mat[x][y] = novoNo->mat[x][y] - novoNo->mat[novo_x][novo_y];
  
    novoNo->custo = 9999; 
  
    //quantidade de movimentos feitos até o momento
    //também pode ser entendido como a profundida que o nó se encontra
    //na árvore 
    novoNo->nivel = nivel; 
  
    //atualiza a nova posição do espaço em branco
    novoNo->x = novo_x; 
    novoNo->y = novo_y; 
  
    return novoNo; 
}

//calcula a quantidade de peãs que estão no lugar errado
//obs: não considera o espaço vazio no cálculo
int calcula_custo(int inicial[3][3], int final[3][3]){ 
    
    int custo = 0;
    
    for (int i = 0; i < 3; i++){
      for (int j = 0; j < 3; j++){
        if (inicial[i][j] != 0 && inicial[i][j] != final[i][j]) {
            custo++; 
        }
      }
    }

    //retorna o custo calculado para o nó
    return custo; 
} 
  
//verifica se a posição do espaço em branco é válida 
int verifica(int x, int y){ 
    return (x >= 0 && x < 3 && y >= 0 && y < 3); 
} 
  
//função recursiva para printar o caminho do nó raiz
//até o estado final 
void imprime_caminho(no* caminho){

    if(!caminho){ 
        return;
    }

    imprime_caminho(caminho->pai); 
    imprime_matriz(caminho->mat); 
    printf("\n"); 
}
  
//função que irá utilizar o algoritmo branch and bound para
//encontrar a solução
void solucao(fila *f, int inicial[3][3], int x, int y, int final[3][3]){ 
      
    //cria o nó raíz
    no* raiz = criaNo(inicial, x, y, 0, NULL, x, y); 
    raiz->custo = calcula_custo(inicial, final); 

    //insere o nó raíz na fila de prioridade; 
    insereNo(f, raiz); 
    
    //enquanto a fila não estiver vazia, vai continuar procurando pelo nó
    //que possui o menor custo
    while (!filaVazia(f)){
        
        //retira o nó com menor custo da fila de prioridade 
        no *menor = removeNo(f);
        
        //se o custo for zero quer dizer que uma solução foi encontrada 
        if (menor->custo == 0){

            imprime_caminho(menor); 
            return; 
        } 
   
        //será criado quatro nós filhos para o nó de menor custo
        for (int i = 0; i < 4; i++){

            if (verifica(menor->x + linha[i], menor->y + coluna[i])){

                no* filho = criaNo(menor->mat, menor->x, menor->y, menor->nivel + 1, menor, menor->x + linha[i], menor->y + coluna[i]); 
                filho->custo = calcula_custo(filho->mat, final); 

                //adiciona os nós filhos na lista de prioridade
                insereNo(f, filho); 
            } 
        } 

    }
}

int main(){

    fila *f = criaFila();

    //estado inicial 
    //o valor zero representa o espaço vazio
    int inicial[3][3] = { 
        {1, 2, 3}, 
        {5, 6, 0}, 
        {7, 8, 4} 
    }; 
  
    //estado final
    int final[3][3] = { 
        {1, 2, 3}, 
        {5, 8, 6}, 
        {0, 7, 4} 
    }; 
  
    //posição da matriz onde está o espaço em branco
    int x = 1, y = 2; 
  
    solucao(f, inicial, x, y, final);
}