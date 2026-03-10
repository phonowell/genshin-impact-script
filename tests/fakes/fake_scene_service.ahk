#Requires AutoHotkey v2.0

class FakeSceneService {
    __New(current := "unknown") {
        this.current := current
    }

    Is(name) {
        if IsObject(name) {
            for item in name {
                if (item = this.current) {
                    return true
                }
            }
            return false
        }

        return this.current = name
    }
}
