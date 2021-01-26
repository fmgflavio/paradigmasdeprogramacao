/*
*  CIC133 - PARADIGMAS DE PROGRAMAÇÃO
* Projeto Final
*
* Flávio Mota Gomes - 2018005379
* Rafael Antunes Vieira - 2018000980
* Rafael Greca Vieira - 2018000434
*
* Estrutura de consulta       
* ?- tabuleiro(S), solucao(S), solucionar(S).
*
*
*/


solucao([]).

% Verifica que Y esta entre 1 e 8, para nao ultrapassar dimensao do tabuleiro
solucao([X,Y|Aux2]):-
		solucao(Aux2),
		pertence(Y,[1,2,3,4,5,6,7,8]),
		block([X,Y],Aux2).

pertence(X,[X|_]).

pertence(X,[_|Aux]):- pertence(X,Aux).

block(_,[]).

block([X,Y],[X1,Y1|Aux2]):-
		Y =\= Y1,
		Y1 - Y =\= X1 - X,
		Y1 - Y =\= X - X1,
		block([X,Y],Aux2).


% Estrutura do tabuleiro (linha, coluna)
tabuleiro([1,_,2,_,3,_,4,_,5,_,6,_,7,_,8,_]).

% Isto garante espaco entre uma solucao e outra
solucionar([]).

% Apresenta o print
solucionar([X, Y | Aux]) :- write('|'), write(X), write(', '), write(Y), solucionar(Aux).       