## Plan Type

`implementation`

## Goal

将当前基于 `coffee-ahk` / `shell-ahk` / AHK v1 的原神脚本，重构为一个可直接维护的 `AutoHotkey v2` 项目。

约束：

- 不保留 `coffee-ahk` 作为未来维护依赖
- 不做“逐文件机械翻译”
- 允许推翻现有模块边界与运行时设计
- 旧仓库仅作为行为参考与数据来源

## Capability Assessment

- 已适用 `plan-implementation`：用于复杂重构计划与阶段划分
- 已识别 `use-fire-keeper`：仅在保留现有 Node 辅助脚本或迁移数据工具时复用
- 暂无专用 `AHK v2` 迁移 skill：本次采用手工架构设计 fallback，并在 notes 中记录
- 后续代码落地后适用 `review-code-changes`：用于阶段性交付复盘

## Current State

- 现有运行时通过 [`source/index.coffee`](/Users/mimiko/Projects/genshin-impact-script/source/index.coffee) 聚合模块
- 编译入口通过 [`task/build.ts`](/Users/mimiko/Projects/genshin-impact-script/task/build.ts) 调用 `coffee-ahk`
- 当前源码约 39 个 `.coffee` 运行时模块，总计约 4619 行
- 当前构建已可进入编译阶段，但因外部依赖 [`source/state.coffee`](/Users/mimiko/Projects/genshin-impact-script/source/state.coffee) 的兄弟仓库数据而失败
- 当前仓库不是自包含状态，不适合作为长期维护基础

## Phases

### Phase 1: Freeze Legacy Behavior And Define v2 Boundaries

进入条件：

- 已确认目标是“直接做 AHK v2”
- 允许旧架构被推翻

执行内容：

- 为旧系统建立功能清单、热键清单、配置项清单、外部依赖清单
- 将现有模块划分为 `runtime`、`platform`、`domain`、`feature` 四层
- 明确哪些旧设计必须废弃：全局 `$`、隐式初始化顺序、跨仓库导入、强耦合单例
- 产出 v2 项目的目录结构、命名规则、模块边界、依赖方向

涉及文件：

- [`source/index.coffee`](/Users/mimiko/Projects/genshin-impact-script/source/index.coffee)
- [`source/misc.coffee`](/Users/mimiko/Projects/genshin-impact-script/source/misc.coffee)
- [`source/type/global.d.ts`](/Users/mimiko/Projects/genshin-impact-script/source/type/global.d.ts)
- [`source/type/shell.d.ts`](/Users/mimiko/Projects/genshin-impact-script/source/type/shell.d.ts)
- [`doc/keymap.md`](/Users/mimiko/Projects/genshin-impact-script/doc/keymap.md)
- [`data/config.ini`](/Users/mimiko/Projects/genshin-impact-script/data/config.ini)

退出条件：

- 有一份明确的 v2 目标架构文档
- 旧系统功能与依赖已完成清点
- 不再允许新增基于 `coffee-ahk` 的功能开发

验证路径：

- 架构文档可映射所有现有核心功能
- 每个旧模块都能归到一个新的目标层级

### Phase 2: Build A Minimal AHK v2 Runtime Skeleton

进入条件：

- v2 模块边界已定义
- 已确定不复刻 `$` 巨型全局 API

执行内容：

- 新建 `src-v2/` 或等价 v2 源码目录
- 建立 v2 项目骨架：`main.ahk`、`bootstrap`、`app context`
- 实现基础运行时：
  - 日志
  - 配置读写
  - 定时器封装
  - 事件总线
  - 热键注册器
  - 窗口句柄/进程封装
- 建立错误处理与调试开关

涉及文件/模块：

- 新建 `src-v2/main.ahk`
- 新建 `src-v2/bootstrap/*.ahk`
- 新建 `src-v2/runtime/*.ahk`
- 新建 `src-v2/platform/windows/*.ahk`

退出条件：

- 启动脚本可以加载并退出
- 可注册热键、输出日志、读取配置、查询目标窗口
- 运行时不依赖 `coffee-ahk` 或 `shell-ahk`

验证路径：

- 手动 smoke test：启动、托盘、热键、日志、配置读取
- 关键模块之间不出现循环依赖

### Phase 3: Replace Platform Adapters And Native Libraries

进入条件：

- v2 skeleton 已稳定
- 基础事件/配置/窗口抽象已可用

执行内容：

- 重写或替换以下平台模块：
  - 窗口管理：旧 [`source/window.coffee`](/Users/mimiko/Projects/genshin-impact-script/source/window.coffee)
  - GDI 截图与取色：旧 [`source/gdip.coffee`](/Users/mimiko/Projects/genshin-impact-script/source/gdip.coffee)
  - 色彩缓存与区域查询：旧 [`source/color-manager.coffee`](/Users/mimiko/Projects/genshin-impact-script/source/color-manager.coffee)
  - 配置与 ini：旧 [`source/config.coffee`](/Users/mimiko/Projects/genshin-impact-script/source/config.coffee)
  - JSON / 文件读取：旧 [`source/json.coffee`](/Users/mimiko/Projects/genshin-impact-script/source/json.coffee)
  - 控制器支持：旧 [`source/controller.coffee`](/Users/mimiko/Projects/genshin-impact-script/source/controller.coffee)
- 评估并处理旧 `.ahk` 库：
  - [`source/lib/Gdip_All.ahk`](/Users/mimiko/Projects/genshin-impact-script/source/lib/Gdip_All.ahk)
  - [`source/lib/Gdip_PixelSearch.ahk`](/Users/mimiko/Projects/genshin-impact-script/source/lib/Gdip_PixelSearch.ahk)
  - [`source/lib/Jxon.ahk`](/Users/mimiko/Projects/genshin-impact-script/source/lib/Jxon.ahk)
  - [`source/lib/XInput.ahk`](/Users/mimiko/Projects/genshin-impact-script/source/lib/XInput.ahk)
  - [`source/lib/ShiftAppVolume.ahk`](/Users/mimiko/Projects/genshin-impact-script/source/lib/ShiftAppVolume.ahk)

退出条件：

- 核心平台能力在 v2 下等价可用
- 旧代码中 `Native '...'` 语义已被封装到明确适配层
- 核心能力不再依赖 v1 命令风格

验证路径：

- 实机测试：窗口激活、截图、取色、INI 读写、控制器输入
- 性能基线：截图与取色频率达到旧版可接受范围

### Phase 4: Rebuild State And Scene Perception Layer

进入条件：

- 底层平台能力已稳定
- 能稳定获取窗口图像和像素颜色

执行内容：

- 重写状态判断相关模块：
  - [`source/scene.coffee`](/Users/mimiko/Projects/genshin-impact-script/source/scene.coffee)
  - [`source/scene2.coffee`](/Users/mimiko/Projects/genshin-impact-script/source/scene2.coffee)
  - [`source/state.coffee`](/Users/mimiko/Projects/genshin-impact-script/source/state.coffee)
  - [`source/party.coffee`](/Users/mimiko/Projects/genshin-impact-script/source/party.coffee)
  - [`source/party2.coffee`](/Users/mimiko/Projects/genshin-impact-script/source/party2.coffee)
  - [`source/character.coffee`](/Users/mimiko/Projects/genshin-impact-script/source/character.coffee)
- 把状态识别从“隐式轮询 + 全局共享缓存”改成“显式采样 + 明确缓存策略”
- 消除对外部兄弟仓库的直接依赖，内置或重新生成状态颜色数据

退出条件：

- 可以在 v2 中稳定识别基础场景、角色信息和关键战斗状态
- `state` 数据来源变为仓库内自包含

验证路径：

- 为场景/状态识别建立截图样本回归集
- 逐项验证 `normal`、`menu`、`dialogue`、`single`、`domain` 等关键状态

### Phase 5: Rebuild Feature Modules On Top Of The New Runtime

进入条件：

- 场景与状态感知已经稳定
- 输入与定时器系统已可复用

执行内容：

- 按优先级重写功能模块：
  1. `picker` / `movement` / `camera`
  2. `skill` / `party-switch` / `tactic`
  3. `fishing` / `jumper` / `recorder` / `replayer`
  4. `hud` / `console` / `sound` / `menu`
- 每个功能模块只依赖稳定的 runtime 接口，不直接访问底层 Win32/GDI 细节
- 废弃旧的隐式单例互相回调方式，改用显式服务引用或 app context

退出条件：

- 核心用户功能可以在 v2 版本中工作
- 模块之间没有不可控的双向依赖

验证路径：

- 针对每个功能做手工用例回归
- 先恢复高价值功能，再恢复边缘功能

### Phase 6: Packaging, Regression Harness, And Release Readiness

进入条件：

- 核心功能已可用
- v2 版本可以作为日常测试对象

执行内容：

- 建立新的构建与打包脚本，替换旧 [`task/build.ts`](/Users/mimiko/Projects/genshin-impact-script/task/build.ts) 主路径
- 为截图样本、配置样本、状态样本建立回归 harness
- 补齐迁移文档、开发文档、发布流程
- 决定旧代码的归档策略：保留只读 legacy 目录或单独分支

退出条件：

- v2 版本具备可发布形态
- 从干净环境可以完成构建、运行、打包
- 旧 `coffee-ahk` 链路不再是默认开发路径

验证路径：

- 干净机器 bootstrap 演练
- 发布包手工验收
- 回归集通过

## Priorities

优先恢复：

1. 进程/窗口感知
2. 截图/取色/GDI
3. 场景与状态识别
4. 角色切换与技能逻辑
5. 拾取、移动、钓鱼等功能

明确降级：

- 旧的 Node 编译链不是保留目标
- 旧的 `$` 全局 API 不是保留目标
- 旧模块命名和类层次不是保留目标

## Milestones

1. `M1`: 完成 v2 架构设计和 legacy 清点
2. `M2`: v2 skeleton 可启动，可读配置，可注册热键
3. `M3`: 截图/取色/窗口/配置链路跑通
4. `M4`: scene/state/party 识别跑通
5. `M5`: 核心功能恢复可用
6. `M6`: 打包、回归、发布准备完成

## Risks

- AHK v1 库移植到 v2 的兼容成本高于预期
- 图像识别阈值和截图 API 在 v2 下行为变化
- 当前仓库的隐式全局状态较多，拆分时容易出现行为漂移
- 缺少自动化样本集，很多验证依赖人工实机
- 旧功能过多时，若不做优先级分层，重写周期会失控

## Anti-Goals

- 不做“边修 coffee-ahk，边写 v2”双线长期维护
- 不做“先把全部 Coffee 机械翻译，再慢慢整理”
- 不做“先上 Rust 再给 AHK 调用”的大跃进式基础设施重构

## Immediate Next Actions

1. 新建 `docs/architecture-ahkv2.md`，落地目标架构与模块边界
2. 建立 legacy inventory：功能、热键、配置、外部依赖、关键截图区域
3. 新建 `src-v2/` 基础目录与 `main.ahk`
4. 先实现 `logger`、`config`、`timer`、`event-bus`、`window` 五个最小 runtime 模块

## Status

`✓ In progress`

Completed in this pass:

- `docs/architecture-ahkv2.md`
- `docs/legacy-inventory.md`
- `src-v2/main.ahk`
- `src-v2/bootstrap/*`
- `src-v2/runtime/*`
- `src-v2/platform/windows/*`
- `src-v2/platform/graphics/color_service.ahk`
- `src-v2/platform/graphics/capture_service.ahk`
- `src-v2/domain/scene/*`
- `src-v2/domain/state/*`
- `src-v2/features/movement/auto_forward.ahk`
- `src-v2/features/movement/camera_control.ahk`
- `src-v2/features/window/window_position.ahk`
- `data/state-colors.ini`
- `tests/*`
- `docs/testing-ahkv2.md`

Next execution target:

- extend Phase 3 toward screenshot/GDI parity
- start party and character ownership in Phase 4
