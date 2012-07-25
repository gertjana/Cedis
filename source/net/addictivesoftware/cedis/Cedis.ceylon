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
    actual shared HashMap<String, String> hgetAll(String key) {
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
    
    doc "Set a timeout on key. After the timeout has expired, the key will automatically be deleted. 
    	 A key with an associated timeout is often said to be volatile in Redis terminology."
    shared actual Integer expire(String key, Integer seconds) {
        connection.sendCommand("EXPIRE", {key, seconds.string});
    	return parseInteger(connection.getReply()) else -1;
    }
    
    doc "Same as expire, but allows for a unix timestamp (seconds since January 1, 1970)."
    shared actual Integer expireAt(String key, Integer unixTime) {
        connection.sendCommand("EXPIREAT", {key, unixTime.string});
    	return parseInteger(connection.getReply()) else -1;
    }
    
    doc "Returns the bit value at offset in the string value stored at key."
    shared actual Boolean getBit(String key, Integer offset) {
        connection.sendCommand("GETBIT", {key, offset.string});
    	return connection.getReply() == "1";
    }
    
    doc "Sets or clears the bit at offset in the string value stored at key.
    	 Returns the original value."
    shared actual Boolean setBit(String key, Integer offset, Boolean val) {
        variable Integer bitValue := 0;
        if (val) {
            bitValue := 1;
        }
        connection.sendCommand("SETBIT", {key, offset.string, bitValue.string});
    	return connection.getReply() == "1";
    }
    
    doc "Returns the remaining time to live of a key that has a timeout"
    shared actual Integer ttl(String key) {
        connection.sendCommand("TTL", { key });
    	return parseInteger(connection.getReply()) else -1;
    }
    
    doc "Decrements the key by one"
    shared actual Integer decr(String key) {
		connection.sendCommand("DECR", { key });
    	return parseInteger(connection.getReply()) else -1;
    }
    
    doc "Decrements the key by the given amount"
    shared actual Integer decrBy(String key, Integer amount) {
        connection.sendCommand("DECRBY", { key, amount.string });
    	return parseInteger(connection.getReply()) else -1;
    }
    
    doc "Increments the key"
    shared actual Integer incr(String key) {
        connection.sendCommand("INCR", { key });
    	return parseInteger(connection.getReply()) else -1;
    }
    
    doc "Increments the key by the given amount"
    shared actual Integer incrBy(String key, Integer amount) {
        connection.sendCommand("INCRBY", { key, amount.string });
    	return parseInteger(connection.getReply()) else -1;
    }
    
}