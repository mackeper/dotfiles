#Persistent ; Keep this script running until the user explicitly exits it.

RemapKey(key, modifier) {
    hold_duration := 300
    StartTime := A_TickCount
    KeyWait, %key%, T0.%hold_duration%
    ElapsedTime := A_TickCount - StartTime
    if (ElapsedTime >= hold_duration) {
        SendInput, {%modifier% down}{%key%}
        KeyWait, %key%
        SendInput, {%modifier% up}
    } else {
        SendInput, %key%
    }
}

*f::RemapKey("r", "lshift")
*d::RemapKey("e", "lctrl")
*s::RemapKey("w", "latl")
*a::RemapKey("q", "lwin")
*x::RemapKey("w", "ratl")

*j::RemapKey("j", "rshift")
*k::RemapKey("k", "rctrl")
*l::RemapKey("l", "lalt")
*h::RemapKey("h", "rwin")
*.::RemapKey(".", "ralt")

