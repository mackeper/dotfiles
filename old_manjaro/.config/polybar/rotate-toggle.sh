#!/bin/sh
right='0 -1 1 1 0 0 0 0 1'
left='0 1 0 -1 0 1 0 0 1'
normal='0 0 0 0 0 0 0 0 0'

 if $(xrandr --properties | grep eDP1 | grep -qoP "right.*\("); then 
    xrandr -o normal;
    xinput set-prop "Wacom HID 50DC Finger" --type=float "Coordinate Transformation Matrix" $normal;
    xinput set-prop "SYNA2B2C:01 06CB:7F27 Touchpad" --type=float "Coordinate Transformation Matrix" $normal;
    xinput set-prop "Wacom HID 50DC Pen Pen (0x9b4095b9)" --type=float "Coordinate Transformation Matrix" $normal;
 else
    xrandr -o right
    xinput set-prop "Wacom HID 50DC Finger" --type=float "Coordinate Transformation Matrix" $left;
    xinput set-prop "SYNA2B2C:01 06CB:7F27 Touchpad" --type=float "Coordinate Transformation Matrix" $left;
    xinput set-prop "Wacom HID 50DC Pen Pen (0x9b4095b9)" --type=float "Coordinate Transformation Matrix" $left;
 fi
    # xrandr -o left
    # xinput set-prop "Wacom HID 50DC Finger" --type=float "Coordinate Transformation Matrix" 0 -1 1 1 0 0 0 0 1;
    # xinput set-prop "SYNA2B2C:01 06CB:7F27 Touchpad" --type=float "Coordinate Transformation Matrix" 0 -1 1 1 0 0 0 0 1;
    # xinput set-prop "Wacom HID 50DC Pen Pen (0x9b4095b9)" --type=float "Coordinate Transformation Matrix" 0 -1 1 1 0 0 0 0 1;
