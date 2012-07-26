
doc "asserts if expected is not equal to actual"
shared void assertEquals(Object? expected, Object? actual) {
    if (!exists expected && !exists actual) { return; }
    if (exists expected) {
        if (exists actual) {
            if (expected.equals(actual))  {
                return;
            }
        }
    }
    throw AssertionException(failedMessage(expected,actual));
}

doc "asserts if expected is not equal to actual"
shared void assertNotEquals(Object? expected, Object? actual) {
    if (exists expected && !exists actual) { return; }
    if (!exists expected && exists actual) { return; }
    if (exists expected) {
        if (exists actual) {
            if (!expected.equals(actual))  {
                return;
            }
        }
    }
    throw AssertionException(failedMessage(expected,actual));
}

doc ""
shared void assertTrue(Boolean expected) {
    if (!expected) { throw AssertionException("expected is not True"); }
}

doc ""
shared void assertFalse(Boolean expected) {
    if (expected) { throw AssertionException("expected is not False"); }
}   


String failedMessage(Object? expected, Object? actual) {
    variable String aString := "null"; 
    if (exists expected) {
        aString := expected.string;
    }
    variable String bString := "null"; 
    if (exists actual) {
        bString := actual.string;
    }
    return "expected: " + aString + " but got: " + bString;
}
