% CIC133 - PARADIGMAS DE PROGRAMAÇÃO
% Projeto Final

% Flávio Mota Gomes - 2018005379
% Rafael Antunes Vieira - 2018000980
% Rafael Greca Vieira - 2018000434

% Sequencia de movimentos e novos estados a partir desses movimentos
move(estado(no_centro,acima_caixa,no_centro,nao_tem),
pegar_banana,
estado(no_centro,acima_caixa,no_centro,tem) ).

move(estado(P,no_chao,P,Banana),
subir, % subir na caixa
estado(P,acima_caixa,P,Banana) ).

move(estado(P1,no_chao,P1,Banana),
empurrar(P1,P2), % empurrar caixa de P1 para P2
estado(P2,no_chao,P2,Banana) ).

move(estado(P1,no_chao,Caixa,Banana),
caminhar(P1,P2), % caminhar de P1 para P2
estado(P2,no_chao,Caixa,Banana) ).

% Caso em que o macaco ja tem a banana
consegue(estado(_,_,_,tem),[]).

% Movimentar e tentar conseguir a banana
consegue(Estado1,[Movimento|Resto]) :- move(Estado1,Movimento,Estado2), consegue(Estado2,Resto).

% X é o caminho que faz o macaco conseguir pegar a banana a partir do estado inicial
X = (caminhar(na_porta,na_janela), empurrar(na_janela, no_centro), subir, pegar_banana). 


% Este eh o estado para testar no input
% consegue(estado(na_porta,no_chao,na_janela,nao_tem),X).


