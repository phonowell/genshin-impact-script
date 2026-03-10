class ServiceContainer {
    __New() {
        this.factories := Map()
        this.instances := Map()
    }

    Register(name, factory) {
        this.factories[name] := factory
        return this
    }

    Has(name) {
        return this.instances.Has(name) || this.factories.Has(name)
    }

    Get(name) {
        if this.instances.Has(name) {
            return this.instances[name]
        }

        if !this.factories.Has(name) {
            throw Error("Service not registered: " name)
        }

        instance := this.factories[name].Call(this)
        this.instances[name] := instance
        return instance
    }
}
