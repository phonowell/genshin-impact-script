BuildApp(rootDir := "") {
    if (rootDir = "") {
        rootDir := RegExReplace(A_ScriptDir, "[\\/]+src-v2$")
    }

    services := ServiceContainer()
    RegisterCoreServices(services, rootDir)

    return GenshinApp(rootDir, services)
}

RegisterCoreServices(services, rootDir) {
    services.Register("logger", LoggerFactory.Bind(rootDir))
    services.Register("events", EventBusFactory)
    services.Register("timers", TimerRegistryFactory)
    services.Register("config", ConfigFactory.Bind(rootDir))
    services.Register("hud", HudServiceFactory)
    services.Register("hotkeys", HotkeyRegistryFactory)
    services.Register("capture", CaptureServiceFactory)
    services.Register("color", ColorServiceFactory)
    services.Register("window", WindowServiceFactory)
    services.Register("input", InputServiceFactory)
    services.Register("tray", TrayServiceFactory.Bind(rootDir))
    services.Register("scene", SceneDetectorFactory)
    services.Register("state-rules", StateRulesFactory.Bind(rootDir))
    services.Register("state", StateDetectorFactory)
    services.Register("feature:auto-forward", AutoForwardFeatureFactory)
    services.Register("feature:camera-control", CameraControlFeatureFactory)
    services.Register("feature:window-position", WindowPositionFeatureFactory)
}

LoggerFactory(rootDir, services) {
    logDir := rootDir "\logs"
    if !DirExist(logDir) {
        DirCreate(logDir)
    }
    return Logger(logDir "\gis-ahkv2.log", false)
}

EventBusFactory(services) {
    return EventBus()
}

TimerRegistryFactory(services) {
    return TimerRegistry()
}

ConfigFactory(rootDir, services) {
    return ConfigStore(rootDir "\data\config.ini", services.Get("logger"))
}

HudServiceFactory(services) {
    return HudService(services.Get("timers"), services.Get("logger"))
}

HotkeyRegistryFactory(services) {
    return HotkeyRegistry(services.Get("logger"))
}

ColorServiceFactory(services) {
    return ColorService(
        services.Get("window"),
        services.Get("capture"),
        services.Get("logger")
    )
}

WindowServiceFactory(services) {
    return WindowService(services.Get("config"), services.Get("logger"))
}

CaptureServiceFactory(services) {
    return CaptureService(services.Get("window"), services.Get("logger"))
}

InputServiceFactory(services) {
    return InputService(services.Get("logger"))
}

TrayServiceFactory(rootDir, services) {
    return TrayService(rootDir, services.Get("logger"))
}

SceneDetectorFactory(services) {
    return SceneDetector(
        services.Get("color"),
        services.Get("window"),
        services.Get("events"),
        services.Get("logger")
    )
}

StateRulesFactory(rootDir, services) {
    rules := StateRules(rootDir "\data\state-colors.ini", services.Get("logger"))
    rules.Load()
    return rules
}

StateDetectorFactory(services) {
    return StateDetector(
        services.Get("color"),
        services.Get("scene"),
        services.Get("state-rules"),
        services.Get("events"),
        services.Get("logger")
    )
}

AutoForwardFeatureFactory(services) {
    return AutoForwardFeature(
        services.Get("hotkeys"),
        services.Get("input"),
        services.Get("scene"),
        services.Get("state"),
        services.Get("events"),
        services.Get("hud"),
        services.Get("logger")
    )
}

CameraControlFeatureFactory(services) {
    return CameraControlFeature(
        services.Get("hotkeys"),
        services.Get("timers"),
        services.Get("input"),
        services.Get("scene"),
        services.Get("logger")
    )
}

WindowPositionFeatureFactory(services) {
    return WindowPositionFeature(
        services.Get("hotkeys"),
        services.Get("window"),
        services.Get("hud"),
        services.Get("logger")
    )
}
