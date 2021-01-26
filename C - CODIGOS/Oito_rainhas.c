/*
CIC133 - PARADIGMAS DE PROGRAMAÇÃO
Projeto Final

Flávio Mota Gomes - 2018005379
Rafael Antunes Vieira - 2018000980
Rafael Greca Vieira - 2018000434

*/

#include <stdbool.h> 
#include <stdio.h> 


///A função a seguir printa o tabuleiro:
void imprimir(int tabuleiro[8][8]) 
{ 
	for (int i = 0; i < 8; i++) { 
		for (int j = 0; j < 8; j++) 
			printf(" %d ", tabuleiro[i][j]); 
		printf("\n"); 
	} 
} 

/*
Esta função confere se a posição pode receber uma rainha, verificando à 
esquerda apenas, pois é a ordem de colocação
*/
int verifica(int tabuleiro[8][8], int linha, int coluna) 
{ 
	int i, j; 

	//Verifica linha à esquerda
	for (i = 0; i < coluna; i++) 
		if (tabuleiro[linha][i]) 
			return 0; 

	//Verifica diagonal superior à esquerda
	for (i = linha, j = coluna; i >= 0 && j >= 0; i--, j--) 
		if (tabuleiro[i][j]) 
			return 0; 

	//Verifica diagonal inferior à direit
	for (i = linha, j = coluna; j >= 0 && i < 8; i++, j--) 
		if (tabuleiro[i][j]) 
			return 0; 

	return 1; 
} 

//Função recursiva para resolução do problema:
int resolveProblema(int tabuleiro[8][8], int coluna){ 

	//A função aloca as rainhas por coluna (segundo argumento passado)
	if (coluna >= 8) return 1; //Isso porque já foram alocadas todas as rainhas 

	//Para cada coluna, o for testará colocar a rainha linha a linha:
	for (int i = 0; i < 8; i++) { 
		//Na coluna passada como argumento, testa-se todas as linhas i
		if (verifica(tabuleiro, i, coluna)) { 
			//Se verifica permite, coloca-se a rainha nesta posição:
			tabuleiro[i][coluna] = 1; 

			//Recursão para a próxima coluna
			if (resolveProblema(tabuleiro, coluna + 1)) 
				return 1; 

			//Se o if acima não obteve sucesso, colocar a rainha nesta posição foi um erro.
			//Portanto, retiramo-a da posição: 
			tabuleiro[i][coluna] = 0; 
		} 
	} 
	return 0; 
} 


// Main:
int main() 
{ 
	// Cria o tabuleiro 8x8 e preenche-o com valores
	// 0. Onde houver uma rainha, o valor é marcado como 1.
	int tabuleiro[8][8] = { { 0, 0, 0, 0, 0, 0, 0, 0 }, 
							{ 0, 0, 0, 0, 0, 0, 0, 0 }, 
							{ 0, 0, 0, 0, 0, 0, 0, 0 }, 
							{ 0, 0, 0, 0, 0, 0, 0, 0 },
				            { 0, 0, 0, 0, 0, 0, 0, 0 },
				            { 0, 0, 0, 0, 0, 0, 0, 0 },
				            { 0, 0, 0, 0, 0, 0, 0, 0 },
				            { 0, 0, 0, 0, 0, 0, 0, 0 } };

	//Chama função para resolver:
	int res = resolveProblema(tabuleiro, 0);

	if (res == 1){
		imprimir(tabuleiro);	
	}
	else{
		printf("\nErro.\n");
	}
	return 0; 
} 
