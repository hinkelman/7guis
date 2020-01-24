#lang racket/gui

(require gregor)

;; test if string in iso8601 format is a valid date
(define (iso8601-date? date-str)
  (cond
    ; iso-8601->date will convert year only or year and month to a date
    ; but we don't want that behavior here so testing for string length of 10
    [(not (= 10 (string-length date-str))) #f] 
    [else (date? (with-handlers ([exn:gregor:parse? (λ (e) #f)]) ; returns #f if exception raised and date otherwise
                   (iso8601->date date-str)))]))

(define (check-date-field date-field date-value)
  (cond
    [(iso8601-date? date-value)
     (send date-field set-field-background (make-object color% 255 255 255 1))]
    [else
     (send date-field set-field-background (make-object color% 255 0 0 1))]))

(define (main-callback control event)
  (define ft-value (send flight-type get-string-selection))
  (define dd-value (send departure-date get-value))
  (define rd-value (send return-date get-value))
  (check-date-field departure-date dd-value)
  (cond
    [(string=? "one-way flight" ft-value)
     (send return-date enable #f)
     ; even if return-date is invalid, set background to white when one-way flight is selected
     (send return-date set-field-background (make-object color% 255 255 255 1))]
    [(string=? "return flight" ft-value)
     ; without unless in the next line text field loses focus after every character change
     (unless (send return-date is-enabled?) (send return-date enable #t))
     (check-date-field return-date rd-value)
     (if (and (iso8601-date? dd-value) (iso8601-date? rd-value) (string>? rd-value dd-value))
         (send book-button enable #t)
         (send book-button enable #f))
     ]))

;; callback function
(define (send-book-msg button event)
  (define dd (send departure-date get-value))
  (define rd (send return-date get-value))
  (if (string=? "one-way flight" (send flight-type get-string-selection))
      (send book-msg set-label (string-append "You have booked a one-way flight for " dd))
      (send book-msg set-label (string-append "You have booked a return flight from " dd " to " rd)))
  (send book-dialog show #t))

;; main window
(define frame (new frame%
                   [label "Book Flight"]
                   [width 150]
                   [border 5]))

(define flight-type (new choice%
                         (label #f)
                         (parent frame)
                         (choices (list "one-way flight" "return flight"))
                         [callback main-callback]))

(define departure-date (new text-field%
                            [label #f]
                            [init-value "2019-05-23"]
                            [parent frame]
                            [callback main-callback]))

(define return-date (new text-field%
                         [label #f]
                         [init-value "2019-05-28"]
                         [enabled #f] ; no change in font color when disabled
                         [parent frame]
                         [callback main-callback]))

(define book-button (new button%
                         [parent frame]
                         [label "Book"]
                         [callback send-book-msg]))

(define book-dialog (new dialog%
                         [label "Confirmation"]
                         [style (list 'close-button)]))

(define book-msg (new message%
                      [parent book-dialog]
                      [label "temp"]
                      [auto-resize #t]))

;; show the frame by calling its show method
(send frame show #t)

