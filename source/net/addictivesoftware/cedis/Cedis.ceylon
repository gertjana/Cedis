import ceylon.collection { HashMap }

doc "Redis Client for Ceylon"
by "Gertjan Assies"
shared class Cedis(String host="localhost", Integer port=6379, Integer timeout=2000) satisfies RedisCommands {

    RedisConnection connection = RedisConnection(host, port, timeout);

    shared void connect() {
        connection.connect();
    }
    shared void disconnect() {
        connection.disconnect();
    }

    doc "returns server info"
    actual shared String info() {
        connection.sendCommandNoArgs("info");
        return connection.getReply();
    }

    doc "Get the value of the specified key. 
         If the key does not exist the special value 'nil' is returned. If the value stored at key is not a string an
         error is returned because GET can only handle string values.
         Time complexity: O(1)"
    actual shared String get(String key) {
        connection.sendCommand("GET", {key});
        return connection.getReply();
    }

    doc "Set the string value as value of the key. 
         The string can't be longer than 1073741824 bytes (1 GB). 
         Time complexity: O(1)"
    actual shared String set(String key, String val) {
        connection.sendCommand("SET", {key, val});
        return connection.getReply();
    }

    doc "Set the respective fields to the respective values. HMSET replaces old values with new values.
        If key does not exist, a new key holding a hash is created.
        Time complexity: O(N) (with N being the number of fields)"
    actual shared String hmset(String key, Map<String, String> val) {
        SequenceBuilder<String> sb = SequenceBuilder<String>();
        sb.append(key);
        for (Entry<String, String> entry in val) {
            sb.append(entry.key);
            sb.append(entry.item);
        }
        connection.sendCommand("HMSET", sb.sequence);
        return connection.getReply();
    }

    doc "Retrieve the values associated to the specified fields.
         If some of the specified fields do not exist, nil values are returned.
         Non existing keys are considered like empty hashes.
         Time complexity: O(N) (with N being the number of fields)"
    actual shared Iterable<String> hmget(String key, String... val) {
        SequenceBuilder<String> sb = SequenceBuilder<String>();
        sb.append(key);
        for (String string in val) {
            sb.append(string);
        }
        connection.sendCommand("HMGET", sb.sequence);
        return connection.getBulkReply();
    }

    doc "Return all the fields and associated values in a hash.
         Time complexity: O(N), where N is the total number of entries"
    actual shared HashMap<String, String> hgetall(String key) {
        connection.sendCommand("HGETALL", {key});
        HashMap<String, String> result = HashMap<String, String>();
        variable Boolean isKey := true;
        variable String entryKey := "";
        for (String string in connection.getBulkReply()) {
            if (isKey) {
                entryKey := string;
                isKey := false;
            } else {
                result.put(entryKey, string);
                isKey := true;
            }
        }
        return result;
    }
    
    doc "If key holds a hash, retrieve the value associated to the specified field.
     	Time complexity: O(1)"
    shared actual String hget(String key, String field) {
        connection.sendCommand("HGET", {key, field});
    	return connection.getReply();
    }
    
    doc "Set the specified hash field to the specified value.
     	If key does not exist, a new key holding a hash is created.
     	Time complexity: O(1)"
    shared actual Integer hset(String key, String field, String val) {
        connection.sendCommand("HSET", {key, field, val});
    	return parseInteger(connection.getReply()) else -1;
    }
    
    doc "Returns true if key exists"
    actual shared Boolean existsKey(String key) {
    	connection.sendCommand("EXISTS", {key});
    	return connection.getReply() == "1";
    }
    
    doc "Clears all databases"
    shared String flushAll() {
        connection.sendCommandNoArgs("FLUSHALL");
        return connection.getReply();
    }
    
    doc "Returns the type of a stored key"
    shared actual String type(String key) {
        connection.sendCommand("TYPE", {key});
    	return connection.getReply();
    }
    shared actual Integer expire(String key, Integer seconds) {
        connection.sendCommand("EXPIRE", {key, seconds.string});
    	return parseInteger(connection.getReply()) else -1;
    }
    
}