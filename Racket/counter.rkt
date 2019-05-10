#lang racket/gui

(define COUNT 0)

; Make a frame by instantiating the frame% class
(define frame (new frame%
                   [label "Counter"]
                   [width 80]
                   [height 60]))

(define main-pane (new horizontal-pane%
                       [parent frame]
                       [alignment '(center center)]))
 
; Make a text message in the frame
(define msg (new message%
                 [parent main-pane]
                 [label (number->string COUNT)]
                 [horiz-margin 15]
                 [min-width 30]))

(define (update-counter control event)
  (set! COUNT (add1 COUNT))
  (send msg set-label (number->string COUNT)))
 
; Make a button in the frame
(define counter (new button%
                     [parent main-pane]
                     [label "Count"]
                     [min-width 50]
                     [callback update-counter]))
 
; Show the frame by calling its show method
(send frame show #t)

