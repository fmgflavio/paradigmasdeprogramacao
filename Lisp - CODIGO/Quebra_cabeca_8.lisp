;; estrutura representando um estado para o problema
(defstruct state
	no
	g_val
	h_val
	f_val
	no_pai
)

;;declaração da variavel global de estado inicial e final

;; estado final
(defvar *estado_final* (list '1 '2 '3 '4 '5 '6 '7 '8 '0 '8))

;; estado inicial
(defvar *estado_inicial* (list '4 '2 '5 '0 '1 '3 '7 '8 '6 '3)) 
	

(defun calculo_heuristica (no_atual) 

;;função que calcula o valor da função heurística no nó atual.
	(if(eq no_atual NIL)
		(return-from calculo_heuristica 9999)
	)

	(setf inplaced_tiles 0)
	(dotimes(contador 9)
		(if(eq (nth contador no_atual) (nth contador *estado_final*))
			(setf inplaced_tiles (+ inplaced_tiles 1))()
		)
		collect inplaced_tiles
	)

	(return-from calculo_heuristica (- 9 inplaced_tiles))
)

(defun configura_o_valor_h_na_struct(temp_no)
;;	função de ajudante para a função calculo_heuristica
	(setf h (calculo_heuristica temp_no))
)

(defun inicia_estado(temp_no)
;;	função que é usada para inicializar os valores de um estado recém-gerado
	(setq new_state (make-state :no temp_no
		:g_val 0
		:h_val ((lambda (temp_no) (setf h (configura_o_valor_h_na_struct temp_no))) temp_no)
		:f_val 9999
		:no_pai NIL ))

	(return-from inicia_estado new_state)
)

(defun reposiciona_espaco(given_list new_blank_pos old_blank_pos)
;;	função que gera uma nova lista com espaço em branco movido para a posição especificada
	(setf copied_list (copy-list given_list))
	(rotatef (nth new_blank_pos copied_list) (nth old_blank_pos copied_list))
	(fill copied_list new_blank_pos :start 9 :end 10) 
	(return-from reposiciona_espaco copied_list)

)


(defun move_pecas(temp_state)
;;	função que gera estados sucessores para um determinado estado temporário
	(setf no_atual (state-no temp_state))
	(setf no_anterior (nth 9 no_atual)) 
	(setf move_cima (- no_anterior 3))
	(setf move_abaixo (+ no_anterior 3))
	(setf move_esquerda (- no_anterior 1))
	(setf move_direita (+ no_anterior 1))
	(setf estado_acima NIL)
	(setf estado_abaixo NIL)
	(setf estado_esquerda NIL)
	(setf estado_direita NIL)
	(setf no_pai_g_val (state-g_val temp_state))
	(if(>= move_cima 0)
		(progn 
			(setf estado_acima (reposiciona_espaco no_atual move_cima no_anterior)) 
			(setf up_state (inicia_estado estado_acima))
			(setf (state-g_val up_state) (+ 1 no_pai_g_val)) 
			(setf (state-f_val up_state) (+ (state-g_val up_state) (state-h_val up_state)))
			(setf (state-no_pai up_state) temp_state)

		)
		(progn
			(setf estado_acima NIL) 
			(setf up_state (inicia_estado estado_acima))
			(setf (state-g_val up_state) 9999) 
			(setf (state-f_val up_state) 9999) 
			(setf (state-no_pai up_state) NIL)
		)
		

	)
	(if(<= move_abaixo 8)
		(progn
			(setf estado_abaixo (reposiciona_espaco no_atual move_abaixo no_anterior))
			(setf down_state (inicia_estado estado_abaixo))
			(setf (state-g_val down_state) (+ 1 no_pai_g_val)) 
			(setf (state-f_val down_state) (+ (state-g_val down_state) 
					(state-h_val down_state))) 
			(setf (state-no_pai down_state) temp_state)
		)
		(progn
			(setf estado_abaixo NIL)
			(setf down_state (inicia_estado estado_abaixo))
			(setf (state-g_val down_state) 9999) 
			(setf (state-f_val down_state) 9999) 
			(setf (state-no_pai down_state) NIL)
		)
		
	)
	(if(and (>= move_esquerda 0)(/= (mod no_anterior 3) 0))
		(progn
			(setf estado_esquerda (reposiciona_espaco no_atual move_esquerda no_anterior))
			(setf left_state (inicia_estado estado_esquerda))
			(setf (state-g_val left_state) (+ 1 no_pai_g_val)) 
		
			(setf (state-f_val left_state) (+ (state-g_val left_state) 
					(state-h_val left_state))) 
			(setf (state-no_pai left_state) temp_state)
		)
		(progn
			(setf estado_esquerda NIL)
			(setf left_state (inicia_estado estado_esquerda))
			(setf (state-g_val left_state) 9999) 
			(setf (state-f_val left_state) 9999) 
			(setf (state-no_pai left_state) NIL)
		)
		
	)
	(if(and (<= move_direita 8) (/= (mod (+ 1 no_anterior) 3) 0))
		(progn

			(setf estado_direita (reposiciona_espaco no_atual move_direita no_anterior))
			(setf right_state (inicia_estado estado_direita))
			(setf (state-g_val right_state) (+ 1 no_pai_g_val)) 
			
			(setf (state-f_val right_state) (+ (state-g_val right_state) 
					(state-h_val right_state))) 
			(setf (state-no_pai right_state) temp_state)

		)
		(progn

			(setf estado_direita NIL)
			(setf right_state (inicia_estado estado_direita))
			(setf (state-g_val right_state) 9999) 
			(setf (state-f_val right_state) 9999) 
			(setf (state-no_pai right_state) NIL)

		)
		
	)
	(setf list_of_pecas_filhas (list up_state down_state left_state right_state))

)


(defun melhor_estado (open_list) 
;; função que retorna melhor estado entre lista de estados abertos
	(setf min_el (inicia_estado (state-no (nth 0 open_list))))
	(setf (state-f_val min_el) 9999)
	(block list_loop
		(loop for s in open_list do
			(if(< (state-f_val s) (state-f_val min_el))
					(setf min_el (copy-state s)) () )
		)
		(return-from list_loop min_el)
	)
)


(defun estado_igual(curr_state estado_final)
;; função para verificar se nó estão corretos
	(setf list1 (subseq (state-no curr_state) 0 9))
	(setf list2 (subseq estado_final 0 9))
	(dotimes(contador 9)
		(
			if(not(eq (nth contador list1)(nth contador list2)))
				(return-from estado_igual NIL)
		)

	)

	(return-from estado_igual T)
	
)

(defun imprime_posicao (lista_de_no)
;; função que imprime o quadro se move 
	(loop for x in lista_de_no do
		(setf t_list (subseq x 0 (- (list-length x) 1)))
		(format t "~a ~a ~a ~%" (first x) (second x) (third x))
		(format t "~a ~a ~a ~%" (fourth x) (fifth x) (sixth x))
		(format t "~a ~a ~a ~%" (seventh x) (eighth x) (ninth x))
		(format t "~v@{~A~:*~}~%~%" 30 "-")
	)

)
(defun imprime_estado(x)
;; função que imprime o estado em uma placa adequada como representação
		(format t "~a ~a ~a ~%" (first x) (second x) (third x))
		(format t "~a ~a ~a ~%" (fourth x) (fifth x) (sixth x))
		(format t "~a ~a ~a ~%" (seventh x) (eighth x) (ninth x))
		(format t "~v@{~A~:*~}~%~%" 30 "-")

)

(defun imprime_caminho(curr_state estados_lista)

;; função para imprimir caminho entre estado de início e estado objetivo
	(setf lista_de_no nil)
	(loop while(not(eq curr_state NIL)) do
		(progn
			
			(push (state-no curr_state) lista_de_no)
			
			(setf curr_state (state-no_pai curr_state))
			
		)
		
	)
	(reverse  lista_de_no)

	(imprime_posicao lista_de_no)
)

(defun search_duplicate(temp_state search_list)
	(loop for s in search_list do
		(setf c_no (state-no s))
		(if(estado_igual temp_state c_no)
			(return s)
		)

	)

)

(defun remove_element (el s_list)
;; função para remover o elemento dado da lista dada
	(setq m_list nil)
	(loop for states in s_list do
		(progn
			(if(not(equal (state-no states) (state-no el)))
				(
					push states m_list
				)
			)
			
		)
		collect m_list
	)
	(return-from remove_element m_list)
)



(defun verifica_objetivo (estado_inicial estado_final)
;; função para verificar se estado objetivo pode ser alcançado a partir do estado inicial
	(setf lista_estado_inicial nil)
	(setf lista_estado_final nil)
	(dotimes(outer_contador 9)
		(progn
			(if(not(eq (nth outer_contador estado_inicial) 0))
				(progn
					(setf inner_contador (+ 1 outer_contador))
					(loop while(<= inner_contador 8) do
						(progn
							
							(if(not(eq(nth inner_contador estado_inicial) 0))
								(progn
									(push (list (nth outer_contador estado_inicial) 
													(nth inner_contador estado_inicial)) 
														lista_estado_inicial)

								)
							)
							(setf inner_contador (+ 1 inner_contador))

						)
					)

				)
			)
		)
	)
	
	(dotimes(outer_contador 9)
		(progn
			(if(not(eq (nth outer_contador estado_final) 0))
				(progn
					(setf inner_contador (+ 1 outer_contador))
					(loop while(<= inner_contador 8) do
						(progn
							
							(if(not(eq(nth inner_contador estado_final) 0))
								(progn
									(push (list (nth outer_contador estado_final) 
													(nth inner_contador estado_final)) 
														lista_estado_final)

								)
							)
							(setf inner_contador (+ 1 inner_contador))

						)
					)

				)
			)
		)
	)
	(setf common 0)
	(loop for x in lista_estado_inicial do

		(loop for y in lista_estado_final do
			(progn
				(if(and (eq (first x) (first y)) (eq (second x)(second y)) )
					(setf common (+ 1 common))
				)
			)
			
			
		)
	)
	(setf inversion_count 0)	
	
	(setf inversion_count (- (list-length lista_estado_inicial) common))
	
	(if(eq (mod inversion_count 2) 0)(return-from verifica_objetivo T)
						(return-from verifica_objetivo NIL))
)


(defun A_STAR (estado_incial estado_final)
;;função que executa o algoritmo a-star usando funções de ajudante
	(setf s_no (state-no estado_incial))
	(setf g_no estado_final)
	(if(not(verifica_objetivo (state-no estado_incial) estado_final))
		(progn
			(format t "~%Infeasible Puzzle!!~%")
			(return-from A_STAR "infeasible puzzle")
		)
		
	)

	(setf closed_list nil)
	(setf estados_lista 0)
	(setf contador 0)
	(if(null estado_incial)
		(progn
			(format t "~%Erro!!~%")
			(return-from A_STAR "Erro")
		)
		
	)
	(setf open_list (list estado_incial))
	(setf contador 0)

	(loop while (not(null open_list)) do
	(progn

		(setf contador (+ 1 contador))


		(setf current (melhor_estado open_list))

		(incf estados_lista)

		(if(estado_igual current estado_final) 
			(progn
					
				(imprime_caminho current estados_lista)
				(return-from A_STAR 'success)
			)
			
		)
		
		(setf pecas_filhas (move_pecas current)) 
		

		(loop for son in pecas_filhas do
			(progn
				( if(state-no son)
					(progn
						(setf son_old_closed (search_duplicate son closed_list))
							#|((and (null son_old_open ) (null son_old_closed))
								(push son open_list)

							)
							(
								(and (not(null son_old_open)) (< (state-f_val son) (state-f_val son_old_open)))
									(progn 
										(setf open_list (remove_element son_old_open open_list)) 
										(push son open_list)
									)
							)
							(
								(and (not(null son_old_closed)) (< (state-f_val son) (state-f_val son_old_closed)))
									(progn	 
										(setf closed_list (remove_element son_old_closed closed_list))
										(push son open_list)
									)
							)|#
							#|(
								(and (not(null son_old_open)) (not(null son_old_closed)))
									(push son open_list)
							)
							|#
						
						(if(null son_old_closed)
								(push son open_list))
						
					)
				)
			)
		)
		(push current closed_list) 
		(setf open_list (remove_element current open_list))


	)

	)

	return "Erro"

)




(defun quebra_cabeca_8()

(setf estado_incial (inicia_estado *estado_inicial*))
(A_STAR estado_incial *estado_final*) 
)

;; Inicia a função 
(quebra_cabeca_8)