import java.lang { System }
import ceylon.interop.java {javaString}
import ceylon.collection { HashMap }

doc "Run the module `cedis`."
void run() {
    Cedis cedis = Cedis();
    cedis.connect();
    
    print("INFO");
    print(cedis.info());
    print("SET test 123");
    print(cedis.set("test", "123"));
    print("GET test");
    print(cedis.get("test"));
    
    print("HMSET testuser:1 :name Theo Tester :email theo@test.com");
    
    HashMap<String, String> hm = HashMap<String, String>();
    hm.put(":name", "Theo Tester"); 
    hm.put(":email", "theo@test.com"); 
    
    print(cedis.hmset("testuser:1", hm)); 
    print("HMGET testuser:1 :name");
    print(cedis.hmget("testuser:1", ":name")); 
    print("HMGET testuser:1 :email");
    print(cedis.hmget("testuser:1", ":email")); 
    print("HMGET testuser:1 :name :email");
    print(cedis.hmget("testuser:1", ":name", ":email", ":unknown")); 

    print("HGETALL testuser:1");
    print(cedis.hgetall("testuser:1"));


    cedis.disconnect(); 
}