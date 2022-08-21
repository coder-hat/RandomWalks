
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

// Destructuring Assignment
// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Destructuring_assignment

// "Create a Proper Game Loop"
// https://spicyyoghurt.com/tutorials/html5-javascript-game-development/create-a-proper-game-loop-with-requestanimationframe

// Create Conway's Game of Life in Javascript
// https://spicyyoghurt.com/tutorials/javascript/conways-game-of-life-canvas

// HTML Button onclick - JavaScript Click Event Tutorial
// https://www.freecodecamp.org/news/html-button-onclick-javascript-click-event-tutorial/

// Create a Button in Javascript
// https://herewecode.io/blog/create-button-javascript/

// Add a button to an HTML page using Javascript
// https://stackoverflow.com/questions/6123136/add-button-to-an-html-page-using-javascript

// Starting and Stopping Animation Frames
// Stack Overflow:
// "How to stop a requestAnimationFrame recursion/loop?"
// https://stackoverflow.com/questions/10735922/how-to-stop-a-requestanimationframe-recursion-loop
