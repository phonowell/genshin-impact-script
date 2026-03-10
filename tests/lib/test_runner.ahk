#Requires AutoHotkey v2.0

class TestRunner {
    __New() {
        this.tests := []
        this.failures := []
        this.passes := 0
    }

    Add(name, callback) {
        this.tests.Push({
            name: name,
            callback: callback,
        })
    }

    Run() {
        for test in this.tests {
            try {
                test["callback"].Call()
                this.passes += 1
                OutputDebug("[PASS] " test["name"] "`n")
            } catch as err {
                this.failures.Push({
                    name: test["name"],
                    message: err.Message,
                })
                OutputDebug("[FAIL] " test["name"] ": " err.Message "`n")
            }
        }

        this.PrintSummary()
        return this.failures.Length
    }

    PrintSummary() {
        OutputDebug("`n")
        OutputDebug("Test summary`n")
        OutputDebug("Passed: " this.passes "`n")
        OutputDebug("Failed: " this.failures.Length "`n")

        for failure in this.failures {
            OutputDebug(
                Format(" - {1}: {2}`n", failure["name"], failure["message"])
            )
        }
    }
}
