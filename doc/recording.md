# 记录

提供可编程的按键录制与重放功能。

## 快速开始

首先，按下`Ctrl + Numpad Dot`，随意按几个其他按键之后，再次按下`Ctrl + Numpad Dot`，你就获得了第一份录像。它的文件名为`replay/0.txt`。

按下`Ctrl + Numpad 0`，你应该可以重复播放这份录像。

`replay/0~9.txt`为内建的十个快捷入口，按下`Ctrl + Numpad 0~9`即可调用它们。

一份录像中的内容通常像是这样：

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

每一行代表一个动作，包含动作时间（单位为毫秒）、按键和位置信息（单位为百分比），使用空格分隔开。

更复杂一些的录像内容也可能会是这样：

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

以`#`开始的行代表注释，不会被解析执行。目前不支持行内注释。

以`@`开始的行代表包含特殊标记，目前已有的特殊标志如下：

- @input
- @paste
- @run
- @sleep

将上述文本内容保存为`replay/9.txt`后，在游戏中按下`Ctrl + Numpad 9`,应当能看到输入并发送了`hello world`。

```txt
@run 9
```

将上述文本内容保存为`replay/0.txt`后，在游戏中按下`Ctrl + Numpad 0`，应当能看到执行了与之前一致的动作。这是因为`@run`标记提供了在不同录像间跳转的功能。
