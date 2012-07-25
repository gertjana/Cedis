import java.lang { System }
import ceylon.interop.java {javaString}
import ceylon.collection { HashMap }

doc "Run the module `cedis`. some poor man's Unit Tests"
void run() {
    Cedis cedis = Cedis();
    cedis.connect();
    
    cedis.flushAll();
    
    print("SET GET");
    assertEquals("OK", cedis.set("test", "123"));
    assertEquals("123", cedis.get("test"));
    
    print("HMSET HMGET");
    
    HashMap<String, String> hm = HashMap<String, String>();
    hm.put(":name", "Theo Tester"); 
    hm.put(":email", "theo@test.com"); 
    
    assertEquals("OK", cedis.hmset("testuser:1", hm)); 
    assertEquals("1", cedis.hmget("testuser:1", ":name").sequence.size.string); 
    assertEquals("Theo Tester", cedis.hmget("testuser:1", ":name").first else "element empty!!"); 
    assertEquals("1", cedis.hmget("testuser:1", ":email").sequence.size.string); 
    assertEquals("theo@test.com", cedis.hmget("testuser:1", ":email").first else "element empty!!"); 
    assertEquals("3", cedis.hmget("testuser:1", ":name", ":email", ":unknown").sequence.size.string); 
    assertEquals("Theo Tester", cedis.hmget("testuser:1", ":name", ":email", ":unknown").first else "element empty!!"); 
    assertEquals("theo@test.com", cedis.hmget("testuser:1", ":name", ":email", ":unknown").sequence.item(1) else "element empty!!"); 
    assertEquals("", cedis.hmget("testuser:1", ":name", ":email", ":unknown").last else "element empty!!"); 

    print("HGETALL HGET HSET");
    assertEquals("2", cedis.hgetAll("testuser:1").sequence.size.string);
    assertTrue(cedis.hgetAll("testuser:1").contains("Theo Tester"));
    assertTrue(cedis.hgetAll("testuser:1").contains("theo@test.com"));
    assertEquals(Entry<String, String>(":email","theo@test.com"), cedis.hgetAll("testuser:1").first else "element empty!");
    assertEquals(Entry<String, String>(":name","Theo Tester"), cedis.hgetAll("testuser:1").rest.first else "element empty!");
	assertEquals(1, cedis.hset("testhash", ":food", "hashee"));
	assertEquals("hashee", cedis.hget("testhash", ":food"));
	assertEquals(0, cedis.hset("testhash", ":food", "hasheekidee"));

	print("EXISTS TYPE");
	assertTrue(cedis.existsKey("test"));
	assertFalse(cedis.existsKey("nonexisting"));

	assertEquals("string", cedis.type("test"));
	assertEquals("hash", cedis.type("testhash"));
	assertEquals("none", cedis.type("whatever"));

	print("EXPIRE EXPIREAT TTL");
	assertEquals(1, cedis.expire("test", 5));
	assertEquals(0, cedis.expire("whatever", 5));
	assertTrue(cedis.ttl("test") <=5);
	assertEquals(-1, cedis.ttl("whatever"));
	
	cedis.set("testexpireat", "bla");
	assertEquals(1, cedis.expire("test", 234562345));
	assertEquals(0, cedis.expire("whatever", 234562345));

	print("SETBIT GETBIT");
	assertEquals(false, cedis.setBit("bittest", 5, true));
	assertEquals(false, cedis.setBit("bittest", 3, true));
	assertEquals(true, cedis.setBit("bittest", 3, false));
	assertEquals(true, cedis.getBit("bittest", 5));
	assertEquals(false, cedis.getBit("bittest", 3));

	print("INCR INCRBY DECR DECRBY");
    assertEquals("OK", cedis.set("testincrdecr", "3"));
    assertEquals(4, cedis.incr("testincrdecr"));
    assertEquals(7, cedis.incrBy("testincrdecr", 3));
    assertEquals(6, cedis.decr("testincrdecr"));
    assertEquals(2, cedis.decrBy("testincrdecr", 4));
    
    
    cedis.disconnect(); 
}

void assertEquals(Object a, Object b) {
    if (a.equals(b)) {
        print("OK");
    } else {
        print("FAIL: " + a.string + " <-> " + b.string);
    }
}
void assertNotEquals(Object a, Object b) {
    if (!a.equals(b)) {
        print("OK");
    } else {
        print("FAIL: " + a.string + " <-> " + b.string);
    }
}


void assertTrue(Boolean a) {
    if (a) {
        print("OK");
    } else {
        print("FAIL");
    }
}
void assertFalse(Boolean a) {
	assertTrue(!a);
}    
