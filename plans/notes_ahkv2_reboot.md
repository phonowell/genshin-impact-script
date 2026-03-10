## Notes

### Decision

最终技术方向定为：

- 短期不继续加码 `coffee-ahk`
- 中长期维护主线为 `AutoHotkey v2`
- 旧仓库作为行为参考，不作为未来架构基础

### Why This Direction

- 现有代码的主要不确定性来自自研编译链和自研运行时，而不是业务功能本身
- `AHK v2` 已经覆盖许多当年 `coffee-ahk` 需要补齐的语法与语言能力
- 当前仓库构建失败首先暴露的是工具链与外部依赖问题，而不是单纯业务 bug

### Existing Architecture Summary

- 语言层：CoffeeScript
- 编译层：`coffee-ahk`
- 运行时：`shell-ahk` + vendored `.ahk` libs + 全局单例
- 装配方式：[`source/index.coffee`](/Users/mimiko/Projects/genshin-impact-script/source/index.coffee) 统一导入，[`source/misc.coffee`](/Users/mimiko/Projects/genshin-impact-script/source/misc.coffee) 统一初始化
- 配置/数据：`ini` + `yaml -> json`
- 感知路径：窗口 -> GDI 截图 -> 像素/颜色判断 -> scene/state -> feature

### Smells To Remove In v2

- 巨型全局 `$` API
- 初始化顺序依赖 `task/sort.ts`
- 跨模块隐式单例引用
- 直接在业务模块中写 `Native '...'`
- 兄弟仓库输入作为构建前提
- 场景判断和功能执行耦合过深

### Proposed Target Layout

```text
src-v2/
  main.ahk
  bootstrap/
    app.ahk
    wiring.ahk
  runtime/
    logger.ahk
    config.ahk
    timer.ahk
    events.ahk
    hotkeys.ahk
    services.ahk
  platform/
    windows/
      window_service.ahk
      input_service.ahk
      tray_service.ahk
    graphics/
      capture_service.ahk
      color_service.ahk
      image_regions.ahk
    storage/
      ini_store.ahk
      json_store.ahk
  domain/
    scene/
      scene_detector.ahk
      state_detector.ahk
      party_detector.ahk
    combat/
      skill_service.ahk
      tactic_runner.ahk
    movement/
      movement_service.ahk
      camera_service.ahk
  features/
    pickup.ahk
    fishing.ahk
    recorder.ahk
    replayer.ahk
    hud.ahk
```

### Module Mapping Heuristics

- `window`, `config`, `json`, `timer`, `console`, `sound`: runtime/platform
- `gdip`, `color-manager`, `point`, `area`: platform/graphics
- `scene`, `scene2`, `state`, `party`, `party2`, `character`: domain
- `skill`, `tactic`, `movement`, `camera`, `picker`, `fishing`: features/domain service

### Migration Order Rationale

- 先平台，后识别，最后功能
- 不先迁 `skill` / `tactic`，因为它们依赖 scene/state/party
- 不先迁 `hud` / `menu`，因为它们不决定核心功能可用性

### Validation Strategy

- 建立截图样本库
- 对 `scene/state/party` 做可重复回归
- 每个阶段保留 smoke script，而不是等整库完成再联调

### Open Questions

- `Gdip_All.ahk` 和 `XInput.ahk` 是否存在可靠的 AHK v2 版本，待实现时确认
- `state.yaml` 是否应转为仓库内静态数据，还是通过新工具脚本生成，待确认
- 是否保留 Node 辅助工具处理 `yaml/json` 与发布，当前倾向保留最小 Node 工具链

### Fallback Record

- 因无专用 `AHK v2 migration` skill，本次计划基于仓库结构手工设计
- 若后续在 GDI/XInput/v2 兼容上遇到阻塞，再单独补充验证子计划

### Working Assumptions

- 允许新建独立 `src-v2/`，不强制就地改 `.coffee`
- 允许旧版在 `master` 或 legacy 分支冻结
- 允许先恢复主路径功能，不追求首版 100% 功能覆盖

### Execution Progress

Completed in the current implementation pass:

- wrote `docs/architecture-ahkv2.md`
- wrote `docs/legacy-inventory.md`
- created the first `src-v2` app skeleton
- created runtime services for logging, config, timers, events, hotkeys, and service wiring
- created initial Windows platform wrappers for tray and window management
- added the first input, scene, and state service boundaries in `src-v2`
- added a minimal color-based detection loop for `scene` and `state`
- added cached capture support through vendored `Gdip_All.ahk`
- recovered legacy element colors into repo-owned `data/state-colors.ini`
- migrated the first user-facing features: auto-forward, camera control, and window positioning
- added an initial AHK v2 test harness under `tests/`
- extended the AHK v2 tests to cover migrated feature logic with fake services

Immediate next code target:

- graphics capture and color services
- state and scene data ownership inside the repo
- first detector service built on top of the new runtime
