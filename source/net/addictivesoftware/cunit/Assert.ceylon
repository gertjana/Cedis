
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
shared void assertTrue(Boolean a) {
    if (!a) { throw AssertionException("FAIL"); }
}

doc ""
shared void assertFalse(Boolean a) {
    assertTrue(!a);
}   

String failedMessage(Object? a, Object? b) {
    variable String aString := "null"; 
    if (exists a) {
        aString := a.string;
    }
    variable String bString := "null"; 
    if (exists b) {
        bString := b.string;
    }
    return "FAIL: " + aString + " <-> " + bString;
}
