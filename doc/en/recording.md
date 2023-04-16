# Recording

Offer programmable key recording and replaying feature.

## Quick Start

Initially, press `Ctrl + Numpad Dot`. After hitting a few other keys, press `Ctrl + Numpad Dot` again to obtain the first recording. Its file name is `replay/0.txt`.

By pressing `Ctrl + Numpad 0`, you should be able to replay this recording.

`replay/0~9.txt` provides ten built-in shortcuts. You can invoke them by pressing `Ctrl + Numpad 0~9`.

The content of a recording usually looks like this:

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

Each line represents an action, including the action time (in milliseconds), key, and position information (in percentages), separated by spaces.

More complex recording content may also be like this:

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

Lines starting with `#` represent comments and will not be parsed or executed. Currently, inline comments are not supported.

Lines starting with `@` contain special markers. The currently available markers are as follows:

- @input
- @paste
- @run
- @sleep

After saving the above text content as `replay/9.txt`, press `Ctrl + Numpad 9` in the game to see the input of `hello world` sent.

```txt
@run 9
```

After saving the above text content as `replay/0.txt`, press `Ctrl + Numpad 0` in the game to see the same action executed. This is because the `@run` marker provides the feature of jumping between different recordings.
