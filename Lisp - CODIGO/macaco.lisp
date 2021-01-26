(defvar n 10) ;Tamanho da sala
(defvar pos_cacho (random n)) ;Posição do cacho
(defvar pos_macaco 0) ;Posição do macaco
(print "Tamanho da sala")
(print n)
(print "Posição do cacho:")
(print pos_cacho)
(loop for i from 1 to pos_cacho
 do (setf pos_macaco (+ pos_macaco 1))
(print "O macaco empurrou a caixa. Posição do
macaco:")
 (print pos_macaco)
)
(print "O macaco está embaixo do cacho")
(defvar qnt_golpes (random 5))
(loop for i from 1 to qnt_golpes
 do (print "O macaco golpeou o cacho")
)
(print "As bananas caíram")
(print "O macaco comeu a banana")