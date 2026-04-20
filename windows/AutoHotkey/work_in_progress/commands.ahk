#Requires AutoHotkey v2.0
#SingleInstance

SetCapsLockState(AlwaysOff)

gui_run:
{

}

CapsLock::
{
    MsgBox("CapsLock pressed")
    return
}
