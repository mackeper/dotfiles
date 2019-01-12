# Buffers
:e file - edit a file in a new buffer
:bnext or :bn - go to the next buffer
:bprev or :bp - go to the previous buffer
:bd - delete a buffer (close a file)
:ls - list all open buffers

# TABS
:tabedit {file}   edit specified file in a new tab
:tabfind {file}   open a new tab with filename given, searching the 'path' to find it
:tabclose         close current tab
:tabclose {i}     close i-th tab
:tabonly          close all other tabs (show only the current tab)

:tabs         list all tabs including their displayed windows
:tabm 0       move current tab to first
:tabm         move current tab to last
:tabm {i}     move current tab to position i+1

gt            go to next tab
gT            go to previous tab
{i}gt         go to tab in position i


# WINDOWS
:sp file - open a file in a new buffer and split window
:vsp file - open a file in a new buffer and vertically split window
Ctrl + ws - split window
Ctrl + ww - switch windows
Ctrl + wq - quit a window
Ctrl + wv - split window vertically

# Terminal
:terminal
:ter
<C-\> <c-n> to exit

# Sessions
:mks <path> - create new session
:so <path> - restore session
