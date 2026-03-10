#Requires AutoHotkey v2.0

RegisterRuntimeTests(runner) {
    runner.Add("EventBus once handler runs only once", TestEventBusOnce)
    runner.Add("ServiceContainer caches service instances", TestServiceContainerCachesInstances)
    runner.Add("ConfigStore loads defaults and persists values", TestConfigStoreLoadAndPersist)
}

TestEventBusOnce() {
    bus := EventBus()
    counter := TestCounter()

    bus.Once("ping", ObjBindMethod(counter, "Inc"))
    bus.Emit("ping")
    bus.Emit("ping")

    Assert.Equal(1, counter.value)
}

TestServiceContainerCachesInstances() {
    services := ServiceContainer()
    probe := TestCounter()

    services.Register("sample", ServiceFactory.Bind(probe))

    first := services.Get("sample")
    second := services.Get("sample")

    Assert.True(first == second, "Expected the same cached service instance")
    Assert.Equal(1, probe.value, "Factory should only run once")
}

TestConfigStoreLoadAndPersist() {
    path := A_Temp "\gis-ahkv2-config-test.ini"
    try FileDelete(path)
    FileAppend("", path, "UTF-8")

    store := ConfigStore(path, FakeLogger())
    store.Load()

    Assert.Equal("", store.Get("basic", "process", ""))
    Assert.True(store.GetBool("better-pickup", "enable", false))

    store.Set("basic", "process", "GenshinImpact.exe")

    store2 := ConfigStore(path, FakeLogger())
    store2.Load()

    Assert.Equal("GenshinImpact.exe", store2.Get("basic", "process", ""))

    try FileDelete(path)
}

ServiceFactory(probe, services) {
    probe.Inc()
    return Map("name", "sample")
}

class TestCounter {
    __New() {
        this.value := 0
    }

    Inc(*) {
        this.value += 1
    }
}
