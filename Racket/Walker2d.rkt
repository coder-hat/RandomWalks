#lang racket

(require racket/draw)
(require 2htdp/universe)


; A point is a 2-dimensional coordinate.
(struct point2d (x y) #:transparent)

(define GRID_WIDE_CELLS 250) ; cells
(define GRID_HIGH_CELLS 250) ; cells
(define GRID_CENTER_CELL (point2d (/ GRID_WIDE_CELLS 2) (/ GRID_HIGH_CELLS 2)))

(define INITIAL_PARTICLE_COUNT 1024)

(define CELL_SIZE_PIXELS 3) ; in pixels

;----- Particle-based functions

; Generate a hash table with all particles located at a cell
; near or at the center of the grid of cells.
(define (initial-particles)
  (hash GRID_CENTER_CELL INITIAL_PARTICLE_COUNT))

 ; Return -1, 0, or 1.
 (define (random-step)
   (- (random 3) 1))

; Return a point2d that is either at the same location as pt
; or is at one the 8 adjacent locations possible in a 2d grid.
(define (next-location pt)
  (point2d (+ (point2d-x pt) (random-step))
           (+ (point2d-y pt) (random-step))))

; Increment the count of hash table new-locations at key=next-particle.
(define (update-particle-count new-locations next-particle)
  (hash-set! new-locations next-particle (+ (hash-ref new-locations next-particle 0) 1)))

; Generate a new locations hash table from the current locations hash table.
(define (update-particle-locations old-locations)
  (let ([new-locations (make-hash)])
    (for* ([old-particle (hash-keys old-locations)]
           [i (in-range (hash-ref old-locations old-particle 0))])
      (update-particle-count new-locations (next-location old-particle)))
    new-locations))

; Return true if pt lies _outside_ the bounding box
; defined by [0, GRID_WIDE) and [0, GRID_HIGH)
(define (clipped-particle? location)
  (let ([px (point2d-x location)]
        [py (point2d-y location)])
    (or (< px 0) (>= px GRID_WIDE_CELLS) (< py 0) (>= py GRID_HIGH_CELLS))))

;----- Pixel-based functions

(define (draw-bitmap pixels-wide pixels-high location-counts)
  (let* ([bmp (make-bitmap pixels-wide pixels-high)]
         [dc (new bitmap-dc% (bitmap bmp))])
    (for* ([location (hash-keys location-counts)])
      (draw-cell dc (point2d-x location) (point2d-y location) CELL_SIZE_PIXELS (make-color 255 0 0 1.0)))
    bmp))

(define (draw-cell dc x-cell y-cell cell-pixels cell-color)
  (let ([x-pixel (* x-cell cell-pixels)]
        [y-pixel (* y-cell cell-pixels)])
    (for* ([y-offset (in-range cell-pixels)]
           [x-offset (in-range cell-pixels)])
      (send dc set-pixel (+ x-pixel x-offset) (+ y-pixel y-offset) cell-color))))

;----- Universe functions
#|
 NOTE 2022-03-06
 Current Behavior: runs until a particle reaches edge of the cell grid.
 At that point, crashes with a contract violation when draw-cell tries
 to draw outside the bitmap bounds.
|#

(define (bb-draw current-state)
  (let ([pixels-wide (* GRID_WIDE_CELLS CELL_SIZE_PIXELS)]
        [pixels-high (* GRID_HIGH_CELLS CELL_SIZE_PIXELS)])
    (draw-bitmap pixels-wide pixels-high current-state)))

(define (bb-tick current-state)
  (update-particle-locations current-state))

(big-bang (hash GRID_CENTER_CELL INITIAL_PARTICLE_COUNT)
  (on-draw bb-draw)
  (on-tick bb-tick)
  )
