import tkinter as tk
import random
import time

from Walker2d import Walker2d

GRID_COLS = 250
GRID_ROWS = 250
GRID_ALL_START_LOCATION = (GRID_COLS // 2, GRID_ROWS // 2)
CELL_DISPLAY_SIZE = 3

NUMBER_OF_PARTICLES = 1024

class TkWalker2d:
    def __init__(self, canvas, color):
        self.canvas = canvas
        self.color = color
        self.walker = Walker2d(NUMBER_OF_PARTICLES, GRID_ALL_START_LOCATION)

    def draw(self):
        self.walker.do_step()
        self.canvas.delete("all")
        for location in self.walker.location_counts.keys():
            x, y = location  # grid coordinates
            x *= CELL_DISPLAY_SIZE  # display coordinates
            y *= CELL_DISPLAY_SIZE
            self.canvas.create_rectangle(x, y, x+CELL_DISPLAY_SIZE, y+CELL_DISPLAY_SIZE, fill=self.color, outline=self.color)
        self.canvas.after(1, self.draw)  # (time_delay, method_to_execute)


if __name__ == "__main__":

    root = tk.Tk()
    root.title("Diffusion Simulated by Random Walk")
    root.resizable(False, False)
    root.wm_attributes("-topmost", 1)

    canvas = tk.Canvas(root, width=GRID_COLS*CELL_DISPLAY_SIZE, height=GRID_ROWS*CELL_DISPLAY_SIZE, bd=0, highlightthickness=0)
    canvas.pack()

    walkDisplay = TkWalker2d(canvas, "red")
    walkDisplay.draw()  # Changed per Bryan Oakley's comment (comment from original example in Stack Overflow)
    tk.mainloop()


#----- NOTES

# 1. Tkinter's canvas doesn't have a straightforward "draw a pixel" function.
# But, we can "trick" canvas into creating a 1-pixel "line" to use as a pixel.
# See:
# https://stackoverflow.com/questions/30168896/tkinter-draw-one-pixel
# self.canvas.create_line(x, y, x + 1, y)

# 2. TkWalker2d class and usage demonstrates tkinter after() method
# Derived from code by:
# https://stackoverflow.com/users/926143/7stud
# posted in discusssion:
# https://stackoverflow.com/questions/29158220/tkinter-understanding-mainloop