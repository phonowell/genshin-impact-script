# Tactic

Tactics allow you to save a lot of repetitive operations. You just need to press
and hold the left button.

Note that starting from version `0.0.35`, custom actions need to be configured
in `character.ini`.

Starting from version `0.0.40`, you can use the `on-side-button-1` and
`on-side-button-2` options to configure the side button actions.

## Quick Start

First, let's take an example:

```ini
[fischl]
on-long-press = a, 100, a, 100, tt

[hu_tao]
on-long-press = @e, a~, 150, j; a, e

[klee]
on-long-press = a, a~

[zhongli]
on-long-press = a, e~
```

Get to know these keywords:

| Keyword      | Description                              |
| ------------ | ---------------------------------------- |
| `#`          | Immediately jumps to the next group      |
| `@e`/`!@e`   | Whether the elemental skill is effective |
| `@e?`/`!@e?` | Whether the elemental skill is ready     |
| `@m`/`!@m`   | Whether the character is moving          |
| `a`/`a~`     | Normal attack/Charged attack             |
| `e`/`e~`     | Use elemental skill (tap/long press)     |
| `ee`         | Quickly use elemental skill twice        |
| `j`          | Jump                                     |
| `ja`         | Jump attack                              |
| `s`          | Sprint                                   |
| `t`          | Aim                                      |
| `tt`         | Quickly aim twice                        |
| Number       | Delay, in `milliseconds`                 |

Use `,` to separate different commands, and `;` to separate different groups.

So looking back at the example, Fischl's tactic is like this:

- Normal attack

- Wait for 100 milliseconds

- Normal attack

- Wait for 100 milliseconds

- Quickly aim twice

Hu Tao's logic is much more complicated and divided into two groups:

- When the elemental skill is effective, loop with charged attack jump

- When the elemental skill is not effective, loop with normal attack, and use
  the elemental skill when it is ready

`@e` is a special marker that only continues to execute if the elemental skill
is effective; otherwise it jumps to the next group.

The remaining two examples are relatively simple. Klee will loop normal attacks
plus charged attacks, while Zhongli will keep the shield active during normal
attacks.

## Recommended

```ini
[amber]
on-long-press = a~, 150

[fischl]
on-long-press = a, 100, a, tt

[ganyu]
on-long-press = a~, a

[hu tao]
on-long-press = !@e, a, e, @e, 300; a~, j, 100

[kamisato ayaka]
on-long-press = !@e?, a, 100, a, 150, a, 280, a, a~, 500, s, 400; a, e
on-switch = !@e?, s; e, 300, s

[keqing]
on-long-press = a, ee

[klee]
on-long-press = a, a~

[ningguang]
on-long-press = a, 700, a, 400, a~, 500, e

[sangonomiya kokomi]
on-long-press = a, a, j, 40

[venti]
on-long-press = a, a~

[zhongli]
on-long-press = a, e~
```

The above configuration is not an optimal solution. If you have a better
solution, please let me know at any time.

## Wildcards

Since version `0.0.34`, the following wildcards can be used:

- all <br> All characters

- bow <br> All bow characters

- catalyst <br> All catalyst characters

- claymore <br> All claymore characters

- polearm <br> All polearm characters

- sword <br> All sword characters

For most characters, this is the correct setting:

```ini
[all]
on-long-press = a, e
```

## Raw key

Since version `0.0.38`, you can call the keys on the keyboard by using `$`
followed by the key name, for example, `$w` represents pressing the `w` key.

Similarly, `$l-button:down, 1000, $l-button:up` represents holding down the left
button.
