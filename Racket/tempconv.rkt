#lang racket/gui

;; code was improved by reaching out to racket-users: https://groups.google.com/forum/#!topic/racket-users/ZBKQPJSIGXM

(define (round-tenths x)
  (/ (round (* x 10)) 10))

(define (convert-c C) ; convert from celsius to fahrenheit
  (number->string (round-tenths (+ 32 (* C (/ 9.0 5))))))

(define (convert-f F) ; convert from fahrenheit to celsius
  (number->string (round-tenths (* (- F 32) (/ 5.0 9)))))

;; task requires bidirectional data flow between two text fields (i.e., read-field and write-field)
(define (update-text-field read-field write-field converter)
  (define text (send read-field get-value))
  (cond
    [(string=? text "")
     ; when read-field is empty, set background color to white and set write-field to empty 
     (send read-field set-field-background (make-object color% 255 255 255 1))
     (send write-field set-value "")]
    [(number? (string->number text))
     ; when read-field contains valid text, set background color for both read-field and write-field to white
     ; and set write-field to converted value from read-field
     (send read-field set-field-background (make-object color% 255 255 255 1))
     (send write-field set-field-background (make-object color% 255 255 255 1))
     (send write-field set-value (converter (string->number text)))]
    [else
     ; all other text is invalid, set background color of read-field to red and set write-field to empty
     (send read-field set-field-background (make-object color% 255 0 0 1))
     (send write-field set-value "")]))

;; callback function to update text-fahrenheit when text-celsius changes
(define (update-fahrenheit control event)
  (update-text-field text-celsius text-fahrenheit convert-c))

;; callback function to update text-celsius when text-fahrenheit changes
(define (update-celsius control event)
  (update-text-field text-fahrenheit text-celsius convert-f))

;; main window
(define frame (new frame%
                   [label "TempConv"]
                   [height 60]))

(define main-pane (new horizontal-pane%
                       [parent frame]))

;; next four elements are arranged left-to-right in the order written here
;; i.e., text-celsius, label-celsius, text-fahrenheit, label-fahrenheit
(define text-celsius (new text-field%
                          [label #f]
                          [parent main-pane]
                          [callback update-fahrenheit]))

(define label-celsius (new message%
                           [parent main-pane]
                           [label "Celsius ="]))

(define text-fahrenheit (new text-field%
                             [label #f]
                             [parent main-pane]
                             [callback update-celsius]))

(define label-fahrenheit (new message%
                              [parent main-pane]
                              [label "Fahrenheit"]))
 
;; show the frame by calling its show method
(send frame show #t)

