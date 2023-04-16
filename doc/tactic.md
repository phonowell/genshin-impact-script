# 自定义动作

自定义动作能够省去大量重复操作，只需要长按左键即可。

注意，自版本`0.0.35`起，自定义动作需在`character.ini`中配置。

自版本`0.0.40`起，可以使用`on-side-button-1`与`on-side-button-2`项配置侧键动作。

自版本`0.0.48`起，该功能暂时被禁用。

## 快速开始

首先，来个例子：

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

| 关键字       | 说明                      |
| ------------ | ------------------------- |
| `#`          | 立刻跳转至下一组          |
| `@e`/`!@e`   | 元素战技是否生效          |
| `@e?`/`!@e?` | 元素战技是否就绪          |
| `@m`/`!@m`   | 角色是否正在移动          |
| `a`/`a~`     | 普通攻击/重击             |
| `e`/`e~`     | 使用元素战技（点按/长按） |
| `ee`         | 快速使用两次元素战技      |
| `j`          | 跳跃                      |
| `ja`         | 跳跃攻击                  |
| `s`          | 冲刺                      |
| `t`          | 瞄准                      |
| `tt`         | 快速瞄准两次              |
| 数字         | 延时，单位为`毫秒`        |

不同指令间使用`,`分隔，不同组之间使用`;`分隔。

所以回看示例，小艾咪的自定义动作就是这样：

- 普通攻击

- 等待 100 毫秒

- 普通攻击

- 等待 100 毫秒

- 快速瞄准两次

胡桃的逻辑就复杂不少，分为两组：

- 当元素战技生效时，循环使用重击跳

- 当元素战技不生效时，循环使用普通攻击，并在元素战技就绪时使用元素战技

`@e`是一个特殊的标记，只有在元素战技生效时才会继续向后执行；否则就会跳到下一组。

剩下的两个例子都比较简单。可莉将循环使用普通攻击加重击，而钟离则会在普通攻击中不断开盾。

## 抄作业

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

上述配置并非最优方案，如果你有更好的方案，随时告诉我。

## 通配符

自版本`0.0.34`起，可以使用如下通配符：

- all <br>所有角色

- bow <br>所有弓系角色

- catalyst <br>所有法器角色

- claymore <br>所有双手剑角色

- polearm <br>所有枪系角色

- sword <br>所有单手剑角色

对于绝大多数角色来说，这么设置总没错：

```ini
[all]
on-long-press = a, e
```

## 原生按键

自版本`0.0.38`起，可以通过`$`后跟按键名来调用键盘的上的按键，例如`$w`即代表按下`w`键。

类似的，`$l-button:down, 1000, $l-button:up`表示长按左键。
