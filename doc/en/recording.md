# Recording

This feature provides programmable keystroke recording and playback
functionality.

## Quick Start

To get started, press `Ctrl + Numpad Dot`, press a few more keys, and then press
`Ctrl + Numpad Dot` again to record your first action. The file name for this
recording is `replay/0.txt`.

To replay this recording, press `Ctrl + Numpad 0`.

`replay/0~9.txt` are ten built-in shortcut entries that can be accessed by
pressing `Ctrl + Numpad 0~9`.

The contents of a recording are usually formatted as follows:

```txt
1000 esc:down
500 esc:up
1000 l-button:down 2%,94%
50 l-button:up 2%,94%
1000 l-button:down 60%,70%
50 l-button:up 60%,70%
15000 l-button:down 95%,91%
50 l-button:up 95%,91%
1000 l-button:down 58%,52%
50 l-button:up 58%,52%
1000 l-button:down 35%,58%
50 l-button:up 35%,58%
1000 l-button:down 38%,35%
50 l-button:up 38%,35%
```

Each line represents an action, including the action time (in milliseconds),
key, and position information (in percentages), separated by spaces.

More complex recording content may also look like this:

```txt
# start chat
1000 enter:down
50 enter:up
50 enter:down
50 enter:up

# input
@input hello
50 space:down
50 space:up
@input world

# send
50 enter:down
50 enter:up

# exit
50 esc:down
50 esc:up
```

Lines starting with `#` are comments and will not be parsed and executed. Inline
comments are currently not supported.

Lines starting with `@` represent special markers, and the current special
markers are as follows:

- @input
- @paste
- @run
- @sleep

After saving the above text content as `replay/9.txt`, press `Ctrl + Numpad 9`
in the game, and you should see `hello world` being input and sent.

```txt
@run 9
```

After saving the above text content as `replay/0.txt`, press `Ctrl + Numpad 0`
in the game, and you should see the same actions performed as before. This is
because the `@run` tag provides the ability to jump between different
recordings.
