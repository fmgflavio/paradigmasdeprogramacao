; CIC133 - PARADIGMAS DE PROGRAMAÇÃO
; Projeto Final

; Flávio Mota Gomes - 2018005379
; Rafael Antunes Vieira - 2018000980
; Rafael Greca Vieira - 2018000434


; Aqui testa-se de uma rainha pode ser colocada na posicao (x,y)
(defun can-place (x y rainhas)
  (cond 
    ((member t (mapcar #'(lambda (xy) (or (= x (car xy)) (= y (cadr xy)))) rainhas)) nil)
    ((member t (mapcar #'(lambda (xy) (= 1 (abs (/ (- x (car xy)) (- y (cadr xy)))))) rainhas)) nil)
    (t)))

; O codigo tenta colocar uma rainha em casa posicao x
; Se conseguir, segue em frente com as demais utilizando recursão
; Se não conseguir, retrocede na recursão e vai para o proximo caso
; O tabuleiro tem dimensão 8x8.
(defun solve-loop (x y rainhas max)
; Condicionais mais complexos podem ser construídos através do form cond,  que é equivalente a if ... else if ... fi.
; Um cond consiste de símbolo con seguido por um número de cláusulas-cond, cada qual é uma lista. O primeiro elemento de uma cláusula-cond é a condição, os lementos restantes são a ação.
; O cond encontra a primeira cláusula que avalia para true, executando a ação respectiva e retornando o valor resultante. Nenhuma das restantes é avaliada.
  (cond
    ((= max (length rainhas)) (print (list 'solucao rainhas)) (cdr rainhas))
     ; imprimir resposta e retroceder (tentar resolver mais de 1 resposta)
     ; ((= max (comprimento das rainhas)) rainhas)
    ((or (> x max) (> y max)) (cdr rainhas)) ; backtrack
    ((can-place x y rainhas) ; testa se pode colocar rainha na posicao (recursao)
      ; append concatena listas.
      (setq rec (solve-loop (+ 1 x) 1 (append (list (list x y)) rainhas) max))
      ; para cada valor de y, ele testa x = 1 até x = max (sendo que max corresponde a 8)
      (cond
        ((equal rainhas rec) (solve-loop x (+ 1 y) rainhas max)) ; backtracked
        (t rec)))
    (t (solve-loop x (+ 1 y) rainhas max))))
    ; para cada valor de x, ele testa y = 1 até y = max (sendo que max corresponde a 8)

; Utiliza-se do tamanho maximo do tabuleiro, que é 8, e chama a funcao solve-loop iniciando pela primeira posicao do tabuleiro (1,1), que serao passados para (x,y) na funcao.
(defun solve (max rainhas)
  (solve-loop 1 1 rainhas max))

; Aqui ocorre o print das solucoes encontradas pelo codigo
; LISP. O argumento passado é 8, que é a quantidade de rainhas e a dimensao do tabuleiro.
(print (list 'solucao (solve 8 '())))

