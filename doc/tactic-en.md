# Tactic

The tactic module allows to set up custom combat loops for each character independently.

This module is used by setting `on-long-press` in `config.ini`.

## Quick start

First, look at a few examples:

```ini
[fischl]
on-long-press = a, 100, a, 100, t, t

[hu_tao]
on-long-press = @e, a~, 150, j; a, e

[klee]
on-long-press = a, a~

[zhongli]
on-long-press = a, e~
```

The tactic module consists of the following units:

- `@e` E skill effective phase
- `@e?` E skill is ready
- `@m` Moving
- `a`/`a~` Normal attack/Charged attack
- `e`/`e~` E skill (tap/hold)
- `ee` Continuous use of E skill
- `j` Jump
- `s` Sprint
- `t` Aim
- `tt` Continuous aim
- Numbers, representing time delay, in `ms`

Different tactical units are separated by a `,`, and different tactical groups are separated by a `;`.

So going back to the very first few examples, in the case of Fischl, her tactical logic is set to:

- Normal attack
- Wait `100 ms`
- Normal attack
- Wait `100 ms`
- Aim (start)
- Aim (end)

A long press on the `left mouse button` will start the cycle of this action.

For Hu Tao, her logic is more complex and is divided into two parts.

- When the E skill is in effect, cycle through charged attack and jump
- When the E skill is not in effect, cycle through normal attack and E skill (when it is ready)

`@e` is a special marker that continues backwards only when the E skill is in effect; otherwise, it jumps to the next tactical group.

The remaining two examples are both relatively simple: Klee will use a cycle of normal attacks followed by charged attacks, and Zhongli will keep normal attacks after getting on his shield.

## Recommended

```ini
[amber]
on-long-press = a~, 150

[fischl]
on-long-press = @m, a, 100, a, tt; a, a~

[ganyu]
on-long-press = a~, a

[hu_tao]
on-long-press = !@e, a, e, @e, 300; a~, 150, j, 50

[keqing]
on-long-press = a, ee

[klee]
on-long-press = a, a~

[ningguang]
on-long-press = a, 700, a, 400, a~, 500, e

[venti]
on-long-press = @m, a, 100, a, tt; a, a~

[zhongli]
on-long-press = a, e~
```

The above tactics do not mean they are the optimal solution, if you have a better tactic, feel free to suggest it in the `issue`.

For most characters, the following settings would also be useful:

```ini
on-long-press = a, e
```