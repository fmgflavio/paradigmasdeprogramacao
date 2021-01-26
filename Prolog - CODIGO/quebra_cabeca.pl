% CIC133 - PARADIGMAS DE PROGRAMAÇÃO
% Projeto Final

% Flávio Mota Gomes - 2018005379
% Rafael Antunes Vieira - 2018000980
% Rafael Greca Vieira - 2018000434

%notação do node
:- op(400,yfx,'#').

%função que irá retornar a solução
%State#0#F#[] significa que vai buscar um estado inicial, profundidade zero
%e que ainda não possui uma solução
solucao(State, Solucao) :- funcao_custo(State, 0, F),
                     busca([State#0#F#[]], S), reverse(S, Solucao).

%calcula o custo total do estado
%P é a profundidade que o nó tá na árvore
%%C é o custo do estado
%F é o valor total do custo (profundidade + custo do estado)
funcao_custo(State, P, F) :- f_custo(State, C),
                         F is P + C.

%busca um estado que é igual o estado final que desejamos encontrar
busca([State#_#_#Solucao|_], Solucao) :- final(State).

%pega o primeiro elemento da lista e realiza a busca até o último elemento
busca([B|R], S) :- expandir(B, Children),
                   inserir_tudo(Children, R, Open),
                   busca(Open, S).

inserir_tudo([F|R], Open1, Open3) :- inserir(F, Open1, Open2),
                                 inserir_tudo(R, Open2, Open3).

inserir_tudo([], Open, Open).

inserir(B, Open, Open) :- repetir_no(B, Open), ! .
inserir(B, [C|R], [B,C|R]) :- menor_custo(B, C), ! .
inserir(B, [B1|R], [B1|S]) :- inserir(B, R, S), !.
inserir(B, [], [B]).

%repete o nó
repetir_no(P#_#_#_, [P#_#_#_|_]).

%utilizada para ordenar a ordem dos nós de forma crescente
menor_custo( _#_#F1#_ , _#_#F2#_ ) :- F1 < F2.

expandir(State#D#_#S,All_My_Children) :-
     bagof(Child#D1#F#[Move|S],
           (D1 is D+1,
             movimenta_peca(State,Child,Move),
             funcao_custo(Child,D1,F)),
           All_My_Children).

final(1/2/3/5/8/6/0/7/4).

%o quebra cabeça considerado está representado abaixo
%onde o espaço em branco será representado por um 0 (zero)
%no lugar de uma das letras

%A | B | C
%D | E | F
%G | H | I

%define todos as movimetações possíveis do espaço em branco para a direita
%o estado da esquerda representa o estado do quebra cabeça antes da movimentação
%e o da direita depois da movimentação do espaço em branco
direita(A/0/C/D/E/F/H/I/J, A/C/0/D/E/F/H/I/J).
direita(A/B/C/D/0/F/H/I/J, A/B/C/D/F/0/H/I/J).
direita(A/B/C/D/E/F/H/0/J, A/B/C/D/E/F/H/J/0).
direita(0/B/C/D/E/F/H/I/J, B/0/C/D/E/F/H/I/J).
direita(A/B/C/0/E/F/H/I/J, A/B/C/E/0/F/H/I/J).
direita(A/B/C/D/E/F/0/I/J, A/B/C/D/E/F/I/0/J).

%define todos as movimetações possíveis do espaço em branco para a esquerda
%o estado da esquerda representa o estado do quebra cabeça antes da movimentação
%e o da direita depois da movimentação do espaço em branco
esquerda(A/0/C/D/E/F/H/I/J, 0/A/C/D/E/F/H/I/J).
esquerda(A/B/C/D/0/F/H/I/J, A/B/C/0/D/F/H/I/J).
esquerda(A/B/C/D/E/F/H/0/J, A/B/C/D/E/F/0/H/J).
esquerda(A/B/0/D/E/F/H/I/J, A/0/B/D/E/F/H/I/J).
esquerda(A/B/C/D/E/0/H/I/J, A/B/C/D/0/E/H/I/J).
esquerda(A/B/C/D/E/F/H/I/0, A/B/C/D/E/F/H/0/I).

%define todos as movimetações possíveis do espaço em branco para baixo
%o estado da esquerda representa o estado do quebra cabeça antes da movimentação
%e o da direita depois da movimentação do espaço em branco
baixo(A/B/C/0/E/F/H/I/J, A/B/C/H/E/F/0/I/J).
baixo(A/B/C/D/0/F/H/I/J, A/B/C/D/I/F/H/0/J).
baixo(A/B/C/D/E/0/H/I/J, A/B/C/D/E/J/H/I/0).
baixo(0/B/C/D/E/F/H/I/J, D/B/C/0/E/F/H/I/J).
baixo(A/0/C/D/E/F/H/I/J, A/E/C/D/0/F/H/I/J).
baixo(A/B/0/D/E/F/H/I/J, A/B/F/D/E/0/H/I/J).

%define todos as movimetações possíveis do espaço em branco para cima
%o estado da esquerda representa o estado do quebra cabeça antes da movimentação
%e o da direita depois da movimentação do espaço em branco
cima(A/B/C/0/E/F/H/I/J, 0/B/C/A/E/F/H/I/J).
cima(A/B/C/D/0/F/H/I/J, A/0/C/D/B/F/H/I/J).
cima(A/B/C/D/E/0/H/I/J, A/B/0/D/E/C/H/I/J).
cima(A/B/C/D/E/F/0/I/J, A/B/C/0/E/F/D/I/J).
cima(A/B/C/D/E/F/H/0/J, A/B/C/D/0/F/H/E/J).
cima(A/B/C/D/E/F/H/I/0, A/B/C/D/E/0/H/I/F).

f_custo(Puzz, H) :- custo(Puzz, P),
                      H is P.

%movimenta as peças de acordo com o que for passado como parâmetro
%no terceiro argumento
movimenta_peca(P, C, esquerda) :-  esquerda(P, C).
movimenta_peca(P, C, direita) :-  direita(P, C).
movimenta_peca(P, C, baixo) :-  baixo(P, C).
movimenta_peca(P, C, cima) :-  cima(P, C).

%calcula o custo que um determinado estado do quebra cabeça possui
custo(A/B/C/D/E/F/G/H/I, P) :-
     a(A,Pa), b(B,Pb), c(C,Pc),
     d(D,Pd), e(E,Pe), f(F,Pf),
     g(G,Pg), h(H,Ph), i(I,Pi),
     P is Pa+Pb+Pc+Pd+Pe+Pf+Pg+Ph+Pg+Pi.

%calcula o custo do quebra cabeça
%o custo é a calculado pela quantidade de movimentos que deverão
%ser feitos para que a peça esteja no lugar correto
%(comparando com o estado final que deseja obter)
a(0,0). a(1,0). a(2,1). a(3,2). a(4,4). a(5,1). a(6,3). a(7,3). a(8,2).
b(0,0). b(1,1). b(2,0). b(3,1). b(4,3). b(5,2). b(6,2). b(7,2). b(8,1).
c(0,0). c(1,2). c(2,1). c(3,0). c(4,2). c(5,3). c(6,1). c(7,3). c(8,2).
d(0,0). d(1,1). d(2,2). d(3,3). d(4,3). d(5,0). d(6,2). d(7,2). d(8,1).
e(0,0). e(1,2). e(2,1). e(3,2). e(4,2). e(5,1). e(6,1). e(7,1). e(8,0).
f(0,0). f(1,3). f(2,2). f(3,1). f(4,1). f(5,2). f(6,0). f(7,2). f(8,2).
g(0,0). g(1,2). g(2,3). g(3,4). g(4,2). g(5,1). g(6,3). g(7,1). g(8,2).
h(0,0). h(1,3). h(2,2). h(3,3). h(4,1). h(5,2). h(6,2). h(7,0). h(8,1).
i(0,0). i(1,4). i(2,3). i(3,2). i(4,0). i(5,3). i(6,1). i(7,1). i(8,2).

% ? - solucao(1/2/3/5/6/0/7/8/4, S).                 
