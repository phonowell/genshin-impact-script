# 自定义动作 Tactic

自定义动作能够省去大量重复操作，只需要长按左键即可

Tactics can save a lot of repetitive actions, by simply long pressing your left
button

注意，自版本`0.0.35`起，自定义动作需在`character.ini`中配置

Note that since version `0.0.35`, tactics must be configured in `character.ini`

自版本`0.0.40`起，可以使用`on-side-button-1`与`on-side-button-2`项配置侧键动作

Since version `0.0.40`, you can use `on-side-button-1` and `on-side-button-2` to
configure side button actions

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

Let's get familiar with these keywords:

| 关键字<br>Keyword | 说明<br>Description                                       |
| ----------------- | --------------------------------------------------------- |
| `#`               | 立刻跳转至下一组<br>Jump immediately to the next group    |
| `@e`/`!@e`        | 元素战技是否生效<br>E skill effective/not-effective phase |
| `@e?`/`!@e?`      | 元素战技是否就绪<br>E skill is ready/not-ready            |
| `@m`/`!@m`        | 角色是否正在移动<br>Character is/isn't in movement state  |
| `a`/`a~`          | 普通攻击/重击<br>Normal attack/Charged attack             |
| `e`/`e~`          | 使用元素战技（点按/长按）<br>E skill (tap/hold)           |
| `ee`              | 快速使用两次元素战技<br>Two quick uses of E skill         |
| `j`               | 跳跃<br>Jump                                              |
| `ja`              | 跳跃攻击<br>Jump & attack                                 |
| `s`               | 冲刺<br>Sprint                                            |
| `t`               | 瞄准<br>Aim                                               |
| `tt`              | 快速瞄准两次<br>Quick aim twice                           |
| 数字<br>Numbers   | 延时，单位为`毫秒`<br>Representing time delay, in `ms`    |

不同指令间使用`,`分隔，不同组之间使用`;`分隔

Separate different commands with `,`, and different groups with `;`

所以回看示例，小艾咪的自定义动作就是这样：

So let's look at the example again, and see how Fischl's tactic is configured:

- 普通攻击

  Normal attack

- 等待 100 毫秒

  Wait 100 ms

- 普通攻击

  Normal attack

- 等待 100 毫秒

  Wait 100 ms

- 快速瞄准两次

  Quick aim twice

胡桃的逻辑就复杂不少，分为两组：

Hu Tao's logic is a bit more complicated, with two groups:

- 当元素战技生效时，循环使用重击跳

  When E skill is effective, loop charged attack & jump

- 当元素战技不生效时，循环使用普通攻击，并在元素战技就绪时使用元素战技

  When E skill is not effective, loop normal attack, and use E skill when it's
  ready

`@e`是一个特殊的标记，只有在元素战技生效时才会继续向后执行；否则就会跳到下一组

`@e` is a special marker, and only when E skill is effective will the following
commands be executed; otherwise, it will jump to the next group

剩下的两个例子都比较简单。可莉将循环使用普通攻击加重击，而钟离则会在普通攻击中不
断开盾

The other two examples are pretty simple. Klee will loop normal attack & charged
attack, while Zhongli will keep his shield up while attacking

## 抄作业 Recommended

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

上述配置并非最优方案，如果你有更好的方案，随时`issue`

The above configuration is not the optimal solution, if you have a better idea,
feel free to `issue`

## 通配符 Wildcard

自版本`0.0.34`起，可以使用如下通配符：

Since version `0.0.34`, you can use the following wildcard:

- all <br>所有角色 <br>All characters

- bow <br>所有弓系角色 <br>All bow characters

- catalyst <br>所有法器角色 <br>All catalyst characters

- claymore <br>所有双手剑角色 <br>All claymore characters

- polearm <br>所有枪系角色 <br>All polearm characters

- sword <br>所有单手剑角色 <br>All sword characters

对于绝大多数角色来说，这么设置总没错：

For most characters, this is probably the best way to set it up:

```ini
[all]
on-long-press = a, e
```

## 原生按键 Raw key

自版本`0.0.38`起，可以通过`$`后跟按键名来调用键盘的上的按键，例如`$w`即代表按
下`w`键

Since version `0.0.38`, you can use `$` followed by the key name to call the key
on the keyboard, for example, `$w` means pressing the `w` key

类似的，`$l-button:down, 1000, $l-button:up`表示长按左键

Similarly, `$l-button:down, 1000, $l-button:up` means long press the left button
