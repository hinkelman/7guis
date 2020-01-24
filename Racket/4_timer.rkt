#lang racket/gui

;; many problems with this code
;; abandoning the 7guis project b/c taken up by Matthias
;; https://github.com/mfelleisen/7GUI


(define count 0)

(define (update-gauge control event)
  (define slider-value (send slider get-value))
  (when (> slider-value 0) ; minimum value for gauge% range is 1
    (send gauge set-range slider-value)))

(define (reset-gauge control event)
  ;(send the-timer start (send gauge get-range))
  (set! count 0)
  (send gauge set-value 0)
  ; (send the-timer notify)
  )

(define (timer-callback)
  (define slider-value (send slider get-value))
  (define gauge-range (send gauge get-range))
  (set! count (+ count 1))
  (cond
    [(> count gauge-range) ; might not need this if I can figure out how to make timer more responsive to slider
     (send the-timer stop)]
    [else
     (send gauge set-value count)
     (send msg set-label (string-append (number->string (/ count 10.0)) "s"))
     (when (>= count slider-value)
       (send the-timer stop))]))

;; main window
(define frame (new frame%
                   [label "Timer"]
                   [width 400]
                   [border 5]))

(define gauge (new gauge%
                   [label "Elapsed Time"]
                   [parent frame]
                   [range 150]))

(define msg (new message%
                 [parent frame]
                 [auto-resize #t]
                 [label "0.0s"]))

(define slider (new slider%
                    [label "Duration"]
                    [parent frame]
                    [style '(horizontal plain)]
                    [min-value 0]
                    [max-value 300]
                    [init-value 150]
                    [callback update-gauge]))

(define the-timer (new timer%
                       [notify-callback timer-callback]
                       [interval 100])) ; 100 ms = 0.1 s

(define button (new button%
                    [parent frame]
                    [min-width 400]
                    [label "Reset"]
                    [callback reset-gauge]))

;; show the frame by calling its show method
(send frame show #t)
