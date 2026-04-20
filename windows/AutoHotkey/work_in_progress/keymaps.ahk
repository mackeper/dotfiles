rIsHeld := false
rWasHeld := false
tapThreshold := 200

r:: {
    global rIsHeld, rWasHeld

    ; Ignore if this is a key repeat
    if (rIsHeld) {
        return
    }

    rIsHeld := true
    rWasHeld := false
    SetTimer holdCheck, -tapThreshold
}

holdCheck() {
    global rIsHeld, rWasHeld
    if (rIsHeld) {
        rWasHeld := true
    }
}

r up:: {
    global rIsHeld, rWasHeld
    rIsHeld := false

    if (!rWasHeld) {
        Send "r"
    } else {
    }

    SetTimer holdCheck, 0
}

j::{
    if (rIsHeld) {
        Send "{Left}"
    } else {
        Send "{Blind}j"
    }
}
k::{
    if (rIsHeld) {
        Send "{Down}"
    } else {
        Send "{Blind}j"
    }
}
l::{
    if (rIsHeld) {
        Send "{Up}"
    } else {
        Send "{Blind}j"
    }
}
`;::{
    if (rIsHeld) {
        Send "{Right}"
    } else {
        Send "{Blind};"
    }
}
