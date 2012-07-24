import java.lang { System }
import ceylon.interop.java {javaString}
import ceylon.collection { HashMap }

doc "Run the module `cedis`. some poor man's Unit Tests"
void run() {
    Cedis cedis = Cedis();
    cedis.connect();
    
    cedis.flushAll();
    
    print("SET test 123");
    assertEquals("OK", cedis.set("test", "123"));
    print("GET test");
    assertEquals("123", cedis.get("test"));
    
    print("HMSET testuser:1 :name Theo Tester :email theo@test.com");
    
    HashMap<String, String> hm = HashMap<String, String>();
    hm.put(":name", "Theo Tester"); 
    hm.put(":email", "theo@test.com"); 
    
    assertEquals("OK", cedis.hmset("testuser:1", hm)); 
    print("HMGET testuser:1 :name");
    assertEquals("1", cedis.hmget("testuser:1", ":name").sequence.size.string); 
    assertEquals("Theo Tester", cedis.hmget("testuser:1", ":name").first else "element empty!!"); 
    print("HMGET testuser:1 :email");
    assertEquals("1", cedis.hmget("testuser:1", ":email").sequence.size.string); 
    assertEquals("theo@test.com", cedis.hmget("testuser:1", ":email").first else "element empty!!"); 
    print("HMGET testuser:1 :name :email :unknown");
    assertEquals("3", cedis.hmget("testuser:1", ":name", ":email", ":unknown").sequence.size.string); 
    assertEquals("Theo Tester", cedis.hmget("testuser:1", ":name", ":email", ":unknown").first else "element empty!!"); 
    assertEquals("theo@test.com", cedis.hmget("testuser:1", ":name", ":email", ":unknown").sequence.item(1) else "element empty!!"); 
    assertEquals("", cedis.hmget("testuser:1", ":name", ":email", ":unknown").last else "element empty!!"); 

    print("HGETALL testuser:1");
    assertEquals("2", cedis.hgetall("testuser:1").sequence.size.string);
    assertTrue(cedis.hgetall("testuser:1").contains("Theo Tester"));
    assertTrue(cedis.hgetall("testuser:1").contains("theo@test.com"));
    assertEquals(Entry<String, String>(":email","theo@test.com"), cedis.hgetall("testuser:1").first else "element empty!");
    assertEquals(Entry<String, String>(":name","Theo Tester"), cedis.hgetall("testuser:1").rest.first else "element empty!");

	print("HSET testhash :food hashee");
	assertEquals(1, cedis.hset("testhash", ":food", "hashee"));
	print("HGET testhash :food");
	assertEquals("hashee", cedis.hget("testhash", ":food"));
	print("HSET testhash :food hasheekidee");
	assertEquals(0, cedis.hset("testhash", ":food", "hasheekidee"));

	print("EXISTS test");
	assertTrue(cedis.existsKey("test"));
	assertFalse(cedis.existsKey("nonexisting"));

	print("TYPE test");
	assertEquals("string", cedis.type("test"));
	assertEquals("hash", cedis.type("testhash"));
	assertEquals("none", cedis.type("whatever"));

	print("EXPIRE test");
	assertEquals(1, cedis.expire("test", 5));
	assertEquals(0, cedis.expire("whatever", 5));

    cedis.disconnect(); 
}

void assertEquals(Object a, Object b) {
    if (a.equals(b)) {
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
