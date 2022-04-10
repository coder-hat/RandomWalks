
function LocationCount(x, y, count) {
    return {
        x: x,
        y: y,
        count: count,
        key: () => x + "," + y
    }
}

function randomInt(upperBound) {
    return Math.floor(Math.random() * upperBound);
}

function randomShift(i) {
    return i + (randomInt(3) - 1);
}

function newLocation(loc) {
    return new LocationCount(randomShift(loc.x), randomShift(loc.y), 1)
}

function doStep(curLocations) {
    let newLocations = new Map();
    for (kv of curLocations.entries()) {
        let curLoc = kv[1];
        for (i=0; i < curLoc.count; i += 1) {
            let newLoc = newLocation(curLoc);
            if (newLocations.has(newLoc.key())) {
                newLocations.get(newLoc.key()).count += 1;
            } else {   
                newLocations.set(newLoc.key(), newLoc);
            }
        }
    }
    return newLocations;
}

//----- Notes and References

// Can try out code on online with:
// https://www.onlinegdb.com/online_javascript_rhino_interpreter

// "Create a Proper Game Loop"
// https://spicyyoghurt.com/tutorials/html5-javascript-game-development/create-a-proper-game-loop-with-requestanimationframe

// Create Conway's Game of Life in Javascript
// https://spicyyoghurt.com/tutorials/javascript/conways-game-of-life-canvas
