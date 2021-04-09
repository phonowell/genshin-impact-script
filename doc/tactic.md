# Tactics Module

The Tactics module allows to set up custom combat loops for each character independently.

This module is used by setting `tactic` in `config.ini`. Also, it replaces the previous `type-cbt`.

## Quick start

First, look at a few examples:

```ini
[fischl]
tactic = a, 100, a, 100, t, t

[hu_tao]
tactic = @e, A, 150, j; a, e

[klee]
tactic = a, A

[zhongli]
tactic = a, E
```

The tactic module consists of the following units:

- `@e` E skill effective phase
- `@m` Moving
- `a`/`A` Normal attack/Charged attack
- `e`/`E` E skill (tap/hold)
- `j` Jump
- `s` Sprint
- `t` Aim
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

## Recommended Tactics

```ini
[fischl]
tactic = a, 100, a, 100, t, t

[ganyu]
tactic = A, 150

[hu_tao]
tactic = @e, A, 150, j; a, e

[klee]
tactic = a, A

[zhongli]
tactic = a, E
```

The above tactics do not mean they are the optimal solution, if you have a better tactic, feel free to suggest it in the `issue`.

For most characters, the following settings would also be useful.

```ini
tactic = a, e
```