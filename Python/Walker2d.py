from collections import Counter
import random


class Walker2d:
    def __init__(self, number_of_particles, all_start_location=(0,0), move=None, handle_boundary=None):
        self.location_counts = Counter()
        self.location_counts[all_start_location] = number_of_particles
        self.move = move
        if self.move is None:
            self.move = lambda location: tuple([i + random.randint(-1, 1) for i in location])
        if handle_boundary is None:
            self.handle_boundary = lambda location: location

    def do_step(self):
        new_counts = Counter()
        for location, count in self.location_counts.items():
            for i in range(count):
                new_location = self.handle_boundary(self.move(location))
                if new_location is not None:
                    new_counts[new_location] += 1
        self.location_counts = new_counts