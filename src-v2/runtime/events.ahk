class EventBus {
    __New() {
        this.handlers := Map()
        this.nextToken := 1
    }

    On(name, callback, once := false) {
        if !this.handlers.Has(name) {
            this.handlers[name] := []
        }

        token := this.nextToken
        this.nextToken += 1

        this.handlers[name].Push({
            id: token,
            callback: callback,
            once: once,
        })

        return token
    }

    Once(name, callback) {
        return this.On(name, callback, true)
    }

    Off(name, token) {
        if !this.handlers.Has(name) {
            return false
        }

        handlers := this.handlers[name]
        for index, item in handlers {
            if (item["id"] = token) {
                handlers.RemoveAt(index)
                return true
            }
        }

        return false
    }

    Emit(name, args*) {
        if !this.handlers.Has(name) {
            return 0
        }

        handlers := this.handlers[name]
        purge := []

        for item in handlers {
            item["callback"].Call(args*)
            if item["once"] {
                purge.Push(item["id"])
            }
        }

        for token in purge {
            this.Off(name, token)
        }

        return handlers.Length
    }
}
