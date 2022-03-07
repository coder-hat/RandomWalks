#lang racket

(require racket/draw)
(require 2htdp/universe)


; A point is a 2-dimensional coordinate.
(struct point2d (x y) #:transparent)

(define GRID_WIDE 250) ; cells
(define GRID_HIGH 250) ; cells
(define GRID_CENTER_PT (point2d (/ GRID_WIDE 2) (/ GRID_HIGH 2)))

(define CELL_SIZE_PX 3) ; in pixels
(define INITIAL_CELL_COUNT 1024) ; in cells

; Place all points at a cell near or at the center of the grid.a
; i.e the initial points hash-table has all possible points "registered" at one location.
(define initial-points (hash GRID_CENTER_PT INITIAL_CELL_COUNT))

; Return -1, 0, or 1
(define (random-step)
  (- (random 3) 1))

; Return a point2d that is either at the same location as pt
; or is at one the 8 adjacent locations possible in a 2d grid.
(define (next-location pt)
  (point2d (+ (point2d-x pt) (random-step))
           (+ (point2d-y pt) (random-step))))

; Return true if pt lies _outside_ the bounding box
; defined by [0, GRID_WIDE) and [0, GRID_HIGH)
(define (clipped-point? pt)
  (let ([px (point2d-x pt)]
        [py (point2d-y pt)])
    (or (< px 0) (>= px GRID_WIDE) (< py 0) (>= py GRID_HIGH))))

; Increment the count for the new-points hash table item with key=next-point.
(define (update-point-count new-points next-point)
  (hash-set! new-points next-point (+ (hash-ref new-points next-point 0) 1)))

; Generate a new points hash table from the current points hash table.
(define (next-points old-points)
  (let ([new-points (make-hash)])
    (for* ([old-pt (hash-keys old-points)]
           [i (in-range (hash-ref old-points old-pt 0))])
      (update-point-count new-points (next-location old-pt)))
    new-points))

(define (draw-bitmap pixels-wide pixels-high location-counts)
  (let* ([bmp (make-bitmap pixels-wide pixels-high)]
         [dc (new bitmap-dc% (bitmap bmp))])
    (for* ([location (hash-keys location-counts)])
      (draw-cell dc (point2d-x location) (point2d-y location) CELL_SIZE_PX (make-color 255 0 0 1.0)))
    bmp))

(define (draw-cell dc x-cell y-cell cell-pixels cell-color)
  (let ([x-pixel (* x-cell cell-pixels)]
        [y-pixel (* y-cell cell-pixels)])
    (for* ([y-offset (in-range cell-pixels)]
           [x-offset (in-range cell-pixels)])
      (send dc set-pixel (+ x-pixel x-offset) (+ y-pixel y-offset) cell-color))))

;----- Universe functions

(define (bb-draw current-state)
  (let ([pixels-wide (* GRID_WIDE CELL_SIZE_PX)]
        [pixels-high (* GRID_HIGH CELL_SIZE_PX)])
    (draw-bitmap pixels-wide pixels-high current-state)))

(define (bb-tick current-state)
  (next-points current-state))

(big-bang (hash GRID_CENTER_PT INITIAL_CELL_COUNT)
  (on-draw bb-draw)
  (on-tick bb-tick)
  )

