# 自定义动作 Tactic

自定义动作能够省去大量重复操作，只需要长按左键即可

The tactic module can save a lot of repetitive actions, by simply long pressing your left button

## 快速开始 Quick start

首先，来个例子：

First, look at a few examples:

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

认识一下这些关键字：

Discover these keywords:

| 按键<br>Keyword | 说明<br>Description |
| --- | --- |
| `@e`/`!@e`| 元素战技是否生效<br>E skill effective/not-effective phase |
| `@e?`/`!@e?` | 元素战技是否就绪<br>E skill is ready/not-ready |
| `@m`/`!@m` | 角色是否正在移动<br>Character is/isn't in movement state |
| `a`/`a~` | 普通攻击/重击<br>Normal attack/Charged attack |
| `e`/`e~` | 使用元素战技（点按/长按）<br>E skill (tap/hold) |
| `ee` | 快速使用两次元素战技<br>Two quick uses of E skill |
| `j` | 跳跃<br>Jump |
| `ja` | 跳跃攻击<br>Jump & attack |
| `s` | 冲刺<br>Sprint |
| `t` | 瞄准<br>Aim |
| `tt` | 快速瞄准两次<br>Quick aim twice |
| 数字<br>Numbers | 延时，单位为`毫秒`<br>Representing time delay, in `ms` |

不同指令间使用`,`分隔，不同组之间使用`;`分隔

Different tactical units are separated by a `,`, and different tactical groups are separated by a `;`

所以回看示例，小艾咪的自定义动作就是这样：

So going back to the very first few examples, in the case of Fischl, her tactical logic is set to:

- 普通攻击
- Normal attack
- 等待100毫秒
- Wait `100 ms`
- 普通攻击
- Normal attack
- 等待100毫秒
- Wait `100 ms`
- 快速瞄准两次
- Aim twice very quickly

胡桃的逻辑就复杂不少，分为两组：

For Hu Tao, her logic is more complex and is divided into two groups:

- 当元素战技生效时，循环使用重击跳
- When the E skill is in effect, cycle through charged attack and jump
- 当元素战技不生效时，循环使用普通攻击，并在元素战技就绪时使用元素战技
- When the E skill is not in effect, cycle through normal attack and E skill (when it is ready)

`@e`是一个特殊的标记，只有在元素战技生效时才会继续向后执行；否则就会跳到下一组

`@e` is a special marker that continues backwards only when the E skill is in effect; otherwise, it jumps to the next tactical group

剩下的两个例子都比较简单。可莉将循环使用普通攻击加重击，而钟离则会在普通攻击中不断开盾

The remaining two examples are both relatively simple: Klee will use a cycle of normal attacks followed by charged attacks, and Zhongli will keep normal attacks after getting on his shield

## 抄作业 Recommended

```ini
[amber]
on-long-press = a~, 150

[fischl]
on-long-press = a, 100, a, tt

[ganyu]
on-long-press = a~, a

[hu_tao]
on-long-press = !@e, a, e, @e, 300; a~, j, 100

[keqing]
on-long-press = a, ee

[klee]
on-long-press = a, a~

[ningguang]
on-long-press = a, 700, a, 400, a~, 500, e

[sangonomiya_kokomi]
on-long-press = a, a, j, 40

[venti]
on-long-press = a, a~

[zhongli]
on-long-press = a, e~
```

上述配置并非最优方案，如果你有更好的方案，随时`issue`

The above tactics do not mean they are the optimal solution, if you have a better tactic, feel free to suggest it in the `issue`

## 通配符 Wildcard

自版本`0.0.34`起，可以使用如下通配符：

Since version `0.0.34`, the following wildcards can be used:

- all
  <br>所有角色
  <br>All characters

- bow
  <br>所有弓系角色
  <br>All bow characters

- catalyst
  <br>所有法器角色
  <br>All catalyst characters

- claymore
  <br>所有双手剑角色
  <br>All claymore characters

- polearm
  <br>所有枪系角色
  <br>All polearm characters

- sword
  <br>所有单手剑角色
  <br>All sword characters

对于绝大多数角色来说，这么设置总没错：

For most characters, the following setting would be useful:

```ini
[all]
on-long-press = a, e
```