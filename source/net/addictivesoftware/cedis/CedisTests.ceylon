import net.addictivesoftware.cunit { test, after, before, assertEquals, assertNotEquals, assertTrue, assertFalse }
import ceylon.collection { HashMap }


doc "Tests for Cedis Client, requires a running redis db"
shared class CedisTests() {
    Cedis cedis = Cedis { host="localhost"; port=6379; };
 
    before
    shared void setup() {
        cedis.connect();
        cedis.flushAll();
    }

    after
    shared void teardown() {
        cedis.disconnect(); 
    }

    test
    shared void getSetTests() {
        assertEquals("OK", cedis.set("test", "123"));
        assertEquals("123", cedis.get("test"));        
    }

    test
    shared void existsTests() {
        assertEquals("OK", cedis.set("testexists", "123"));
        assertTrue(cedis.existsKey("testexists"));
        assertFalse(cedis.existsKey("nonexisting"));        
    }
    
    test
    shared void typeTest() {
        assertEquals("OK", cedis.set("teststring", "123"));
        assertEquals(1, cedis.hset("testhash2", "foo", "bar"));
        assertEquals("string", cedis.type("teststring"));
        assertEquals("hash", cedis.type("testhash2"));
        assertEquals("none", cedis.type("whatever"));
    }
    
    test
    shared void hashTests() {
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

        assertEquals("2", cedis.hgetAll("testuser:1").sequence.size.string);
        assertTrue(cedis.hgetAll("testuser:1").contains("Theo Tester"));
        assertTrue(cedis.hgetAll("testuser:1").contains("theo@test.com"));
        assertEquals(Entry<String, String>(":email","theo@test.com"), cedis.hgetAll("testuser:1").first else "element empty!");
        assertEquals(Entry<String, String>(":name","Theo Tester"), cedis.hgetAll("testuser:1").rest.first else "element empty!");
        assertEquals(1, cedis.hset("testhash", ":food", "hashee"));
        assertEquals(1, cedis.hset("testhash2", ":food", "hashee"));
        assertEquals("hashee", cedis.hget("testhash", ":food"));
        assertEquals(0, cedis.hset("testhash", ":food", "hasheekidee"));
        assertEquals(1, cedis.hdel("testhash", ":food", ":something"));
        assertEquals(1, cedis.hdel("testuser:1", ":name", ":whatever"));
        assertTrue(cedis.existsKey("testuser:1"));
        assertFalse(cedis.existsKey("testhash"));
        assertEquals("theo@test.com", cedis.hget("testuser:1", ":email"));
        
        assertEquals("OK", cedis.hmset("users:4", hm));
        assertTrue(cedis.hexists("users:4", ":name"));
        assertTrue(cedis.hexists("users:4", ":email"));
        assertFalse(cedis.hexists("users:4", ":whatever"));
        assertEquals(2, cedis.hlen("users:4"));
        assertEquals(2, cedis.hkeys("users:4").sequence.size);
        assertEquals(2, cedis.hvals("users:4").sequence.size);
        assertEquals(":email", cedis.hkeys("users:4").first else "");
        assertEquals(":name", cedis.hkeys("users:4").last else "");
        assertEquals("theo@test.com", cedis.hvals("users:4").first else "");
        assertEquals("Theo Tester", cedis.hvals("users:4").last else "");
    } 
    
    test
    shared void expireTests() {
        assertEquals("OK", cedis.set("testexpire", "testexpire"));
        assertEquals(1, cedis.expire("testexpire", 5));
        assertEquals(0, cedis.expire("whatever", 5));
        assertTrue(cedis.ttl("testexpire") <=5);
        assertEquals(-1, cedis.ttl("whatever"));
        
        assertEquals("OK", cedis.set("testexpireat", "bla"));
        assertEquals(1, cedis.expireAt("testexpireat", 234562345));
        assertEquals(0, cedis.expireAt("whatever", 234562345));
    }    

}


