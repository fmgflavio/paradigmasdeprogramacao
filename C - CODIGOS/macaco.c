#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include <math.h>
#define N 10

/*
Flávio Mota Gomes - 2018005379 
Rafael Antunes Vieira - 2018000980 
Rafael Greca Vieira - 2018000434
*/

int solucao(int sala[N][N], int x_caixa, int y_caixa){

    int distancia_caixa_x = x_caixa;
    int distancia_caixa_y = y_caixa;

    for(int i=1; i<=distancia_caixa_x; i++){
        //anda para frente no eixo x
        sala[i][0] = 1;
        printf("O macaco deu um passo para frente. Posição atual: [%d][0]\n", i);
    }

    for(int i=1; i<=distancia_caixa_y; i++){
        //anda para frente no eixo x
        sala[distancia_caixa_x][i] = 1;
        printf("O macaco deu um passo para a esquerda. Posição atual: [%d][%d]\n", distancia_caixa_x, i);
    }

    printf("O macaco chegou na caixa!\n");

    int distancia_banana_x = x_caixa - ((N/2)-1);
    int distancia_banana_y = y_caixa - ((N/2)-1);
    
    //o macaco precisa voltar
    if(distancia_banana_x > 0){
        for(int i=abs(distancia_banana_x); i>0; i--){
            sala[distancia_caixa_x--][distancia_caixa_y] = 1;
            printf("O macaco empurrou a caixa para trás. Posição atual: [%d][%d]\n", distancia_caixa_x, distancia_caixa_y);
        }
    }else{
        if(distancia_banana_x < 0){
            //o macaco precisa andar para frente
            for(int i=1; i<=abs(distancia_banana_x); i++){
                sala[distancia_caixa_x++][distancia_caixa_y] = 1;
                printf("O macaco empurrou a caixa para frente. Posição atual: [%d][%d]\n", distancia_caixa_x, distancia_caixa_y);
            }
        }
    }

    //o macaco precisa voltar
    if(distancia_banana_y > 0){
        for(int i=abs(distancia_banana_y); i>0; i--){                                                               
            sala[distancia_caixa_x][distancia_caixa_y--] = 1;                                                                                                                                                                                                                                                                                                                                                                                 
            printf("O macaco empurrou a caixa para direita. Posição atual: [%d][%d]\n", distancia_caixa_x, distancia_caixa_y);
        }
    }else{

        if(distancia_banana_y < 0){
            //o macaco precisa andar para frente
            for(int i=1; i<=abs(distancia_banana_y); i++){
                sala[distancia_caixa_x][distancia_caixa_y++] = 1;
                printf("O macaco empurrou a caixa para esquerda. Posição atual: [%d][%d]\n", distancia_caixa_x, distancia_caixa_y);
            }
        }
    }

    printf("O macaco subiu na caixa!\n");

    printf("O macaco pegou a banana!\n");
}

int main(){

    int sala[10][10];
    int x_caixa = 3, y_caixa = 8;

    //1 = macaco
    //2 = banana
    //3 = caixa
    for(int i=0; i<10; i++){
        for(int j=0; j<10; j++){
            //aloca o macaco na posição 0,0
            if(i==0 && j==0){
                sala[i][j] = 1;
            }else{
                //aloca a banana no centro da sala
                if(i==(N/2)-1 && j==(N/2)-1){
                    sala[i][j] = 2;
                }else{
                    //aloca a caixa na sala
                    if(i==x_caixa && j==y_caixa){
                        sala[i][j] = 3;
                    }else{
                        sala[i][j] = 0;
                    }
                }
            }
        }
    }

    solucao(sala, x_caixa, y_caixa);

    return 1;
}