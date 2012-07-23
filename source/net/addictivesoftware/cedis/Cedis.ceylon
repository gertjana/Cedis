

shared class Cedis() extends RedisConnection() satisfies Commands {


    actual shared void connect() {

    }

    shared actual void get(String key) {}
    shared actual void set(String key, String val) {}
}