/*
CIC133 - PARADIGMAS DE PROGRAMAÇÃO
Projeto Final

Flávio Mota Gomes - 2018005379
Rafael Antunes Vieira - 2018000980
Rafael Greca Vieira - 2018000434

*/

public class Rainha { 

	///A função a seguir printa o tabuleiro:
	void imprimir(int tabuleiro[][]) 
	{ 
		for (int i = 0; i < 8; i++) { 
			for (int j = 0; j < 8; j++){
				System.out.print(" " + tabuleiro[i][j] + " ");
			}
			System.out.println(); 
		} 
	} 

	/*
	Esta função confere se a posição pode receber uma rainha, verificando à 
	esquerda apenas, pois é a ordem de colocação
	*/
	boolean verifica(int tabuleiro[][], int linha, int coluna) 
	{ 
		int i, j;
		//Verifica linha à esquerda
		for (i = 0; i < coluna; i++) 
			if (tabuleiro[linha][i] == 1) 
				return false; 
		//Verifica diagonal superior à esquerda
		for (i = linha, j = coluna; i >= 0 && j >= 0; i--, j--) 
			if (tabuleiro[i][j] == 1) 
				return false; 
		//Verifica diagonal inferior à direita
		for (i = linha, j = coluna; j >= 0 && i < 8; i++, j--) 
			if (tabuleiro[i][j] == 1) 
				return false; 
		return true; 
	} 

	//Função recursiva para resolução do problema:
	boolean resolveProblema(int tabuleiro[][], int coluna) 
	{ 
		//A função aloca as rainhas por coluna (segundo argumento passado)
		if (coluna >= 8) return true; //Isso porque já foram alocadas todas as rainhas

		//Para cada coluna, o for testará colocar a rainha linha a linha
		for (int i = 0; i < 8; i++) { 
			//Na coluna passada como argumento, testa-se todas as linhas i
			if (verifica(tabuleiro, i, coluna)) { 
				//Se verifica permite, coloca-se a rainha nesta posição:/
				tabuleiro[i][coluna] = 1; 

				//Recursão para a próxima coluna
				if (resolveProblema(tabuleiro, coluna + 1) == true) 
					return true; 

				//Se o if acima não obteve sucesso, colocar a rainha nesta posição foi um erro.
				//Portanto, retiramo-a da posição: 
				tabuleiro[i][coluna] = 0;
			} 
		} 
		return false; 
	}

	boolean montaTabuleiro() 
	{ 
		int tabuleiro[][] = { { 0, 0, 0, 0, 0, 0, 0, 0 }, 
							{ 0, 0, 0, 0, 0, 0, 0, 0 }, 
							{ 0, 0, 0, 0, 0, 0, 0, 0 }, 
							{ 0, 0, 0, 0, 0, 0, 0, 0 },
							{ 0, 0, 0, 0, 0, 0, 0, 0 },
							{ 0, 0, 0, 0, 0, 0, 0, 0 },
							{ 0, 0, 0, 0, 0, 0, 0, 0 },
							{ 0, 0, 0, 0, 0, 0, 0, 0 } }; 

        resolveProblema(tabuleiro, 0);
		imprimir(tabuleiro); 
		return true; 
	}
} 