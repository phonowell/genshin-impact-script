# Tactic

Tactics can save a lot of repetitive operations. Just press and hold the left
mouse button.

Note that since version `0.0.35`, tactics need to be configured in
`character.ini`.

Since version `0.0.40`, you can use the `on-side-button-1` and
`on-side-button-2` items to configure side button actions.

## Quick Start

First, an example:

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
| `#`          | Immediately jump to the next group       |
| `@e`/`!@e`   | Whether the elemental skill is effective |
| `@e?`/`!@e?` | Whether the elemental skill is ready     |
| `@m`/`!@m`   | Whether the character is moving          |
| `a`/`a~`     | Normal attack / charged attack           |
| `e`/`e~`     | Use elemental skill (tap / long press)   |
| `ee`         | Quickly use elemental skill twice        |
| `j`          | Jump                                     |
| `ja`         | Jump attack                              |
| `s`          | Sprint                                   |
| `t`          | Aim                                      |
| `tt`         | Quickly aim twice                        |
| Number       | Delay, unit is `ms`                      |

Different instructions are separated by `,`, and different groups are separated
by `;`.

So looking back at the example, Fischl's tactic is like this:

- Normal attack

- Wait for 100ms

- Normal attack

- Wait for 100ms

- Quickly aim twice

Hu Tao's logic is much more complicated, divided into two groups:

- When the elemental skill is effective, loop using charged attack jump

- When the elemental skill is not effective, loop using normal attack, and use
  the elemental skill when the elemental skill is ready

`@e` is a special mark, which will continue to execute forward only when the
elemental skill is effective; otherwise, it will jump to the next group.

The remaining two examples are relatively simple. Klee will loop using normal
attack plus charged attack, while Zhongli will constantly break the shield in
normal attack.

## Copy homework

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

The above configuration is not the optimal solution. If you have a better
solution, please let me know.

## Wildcard

Since version `0.0.34`, the following wildcards can be used:

- all <br> All characters

- bow <br> All bow characters

- catalyst <br> All catalyst characters

- claymore <br> All claymore characters

- polearm <br> All polearm characters

- sword <br> All sword characters

For most characters, setting it like this is always correct:

```ini
[all]
on-long-press = a, e
```

## Raw key

Since version `0.0.38`, you can call the key on the keyboard by following the
key name with `$`, for example `$w` represents pressing the `w` key.

Similarly, `$l-button:down, 1000, $l-button:up` means long press the left mouse
button.
