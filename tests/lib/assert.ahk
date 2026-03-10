#Requires AutoHotkey v2.0

class Assert {
    static True(condition, message := "Expected condition to be true") {
        if !condition {
            throw Error(message)
        }
    }

    static False(condition, message := "Expected condition to be false") {
        if condition {
            throw Error(message)
        }
    }

    static Equal(expected, actual, message := "") {
        if (expected = actual) {
            return
        }

        if (message = "") {
            message := Format(
                "Expected {1}, got {2}",
                Assert.ValueToString(expected),
                Assert.ValueToString(actual)
            )
        }

        throw Error(message)
    }

    static ArrayEqual(expected, actual, message := "") {
        Assert.True(IsObject(expected), "Expected array is not an object")
        Assert.True(IsObject(actual), "Actual array is not an object")
        Assert.Equal(expected.Length, actual.Length, "Array lengths differ")

        loop expected.Length {
            if (expected[A_Index] != actual[A_Index]) {
                if (message = "") {
                    message := Format(
                        "Arrays differ at index {1}: expected {2}, got {3}",
                        A_Index,
                        Assert.ValueToString(expected[A_Index]),
                        Assert.ValueToString(actual[A_Index])
                    )
                }
                throw Error(message)
            }
        }
    }

    static Throws(callback, message := "Expected callback to throw") {
        thrown := false
        try {
            callback.Call()
        } catch {
            thrown := true
        }

        if !thrown {
            throw Error(message)
        }
    }

    static ValueToString(value) {
        if !IsObject(value) {
            return value ""
        }

        text := "["
        first := true
        for item in value {
            if !first {
                text .= ", "
            }
            text .= Assert.ValueToString(item)
            first := false
        }
        text .= "]"
        return text
    }
}
