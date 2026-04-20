Persistent ; Keep this script running until the user explicitly exits it.

RemapKey(key, modifier) {
    res := KeyWait(key, "T0.3")
    if (!res) {
        SendInput("{" modifier " down}{" key "}")
        KeyWait(key)
        SendInput("{" modifier " up}")
    } else {
        SendInput(key)
    }
}

*f::RemapKey("f", "lshift")
*d::RemapKey("d", "lctrl")
*s::RemapKey("s", "latl")
*a::RemapKey("a", "lwin")
*x::RemapKey("x", "ratl")

*j::RemapKey("j", "rshift")
*k::RemapKey("k", "rctrl")
*l::RemapKey("l", "lalt")
*h::RemapKey("h", "rwin")
*.::RemapKey(".", "ralt")

