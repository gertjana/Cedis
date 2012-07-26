import ceylon.collection { HashMap, HashSet }

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
    
    doc "Returns true if key exists

Time complexity: O(1)"
    actual shared Boolean existsKey(String key) {
    	connection.sendCommand("EXISTS", {key});
    	return connection.getReply() == "1";
    }
    
    doc "Clears all databases"
    shared String flushAll() {
        connection.sendCommandNoArgs("FLUSHALL");
        return connection.getReply();
    }
    
    doc "Returns the type of a stored key

Time complexity: O(1)"
    shared actual String type(String key) {
        connection.sendCommand("TYPE", {key});
    	return connection.getReply();
    }
    
    doc "Set a timeout on key. After the timeout has expired, the key will automatically be deleted.

Time complexity: O(1) "
    shared actual Integer expire(String key, Integer seconds) {
        connection.sendCommand("EXPIRE", {key, seconds.string});
    	return parseInteger(connection.getReply()) else -1;
    }
    
    doc "Same as expire, but allows for a unix timestamp (seconds since January 1, 1970).

Time complexity: O(1)"
    shared actual Integer expireAt(String key, Integer unixTime) {
        connection.sendCommand("EXPIREAT", {key, unixTime.string});
    	return parseInteger(connection.getReply()) else -1;
    }
    
    doc "Returns the bit value at offset in the string value stored at key."
    shared actual Boolean getBit(String key, Integer offset) {
        connection.sendCommand("GETBIT", {key, offset.string});
    	return connection.getReply() == "1";
    }
    
    doc "Sets or clears the bit at offset in the string value stored at key and returns the original value."
    shared actual Boolean setBit(String key, Integer offset, Boolean val) {
        connection.sendCommand("SETBIT", {key, offset.string, val then "1" else "0"});
    	return connection.getReply() == "1";
    }
    
    doc "Returns the remaining time to live of a key that has a timeout

Time complexity: O(1)"
    shared actual Integer ttl(String key) {
        connection.sendCommand("TTL", { key });
    	return parseInteger(connection.getReply()) else -1;
    }
    
    doc "Decrements the key by one

Time complexity: O(1)"
    shared actual Integer decr(String key) {
		connection.sendCommand("DECR", { key });
    	return parseInteger(connection.getReply()) else -1;
    }
    
    doc "Decrements the key by the given amount

Time complexity: O(1)"
    shared actual Integer decrBy(String key, Integer amount) {
        connection.sendCommand("DECRBY", { key, amount.string });
    	return parseInteger(connection.getReply()) else -1;
    }
    
    doc "Increments the key

Time complexity: O(1)"
    shared actual Integer incr(String key) {
        connection.sendCommand("INCR", { key });
    	return parseInteger(connection.getReply()) else -1;
    }
    
    doc "Increments the key by the given amount

Time complexity: O(1)"
    shared actual Integer incrBy(String key, Integer amount) {
        connection.sendCommand("INCRBY", { key, amount.string });
    	return parseInteger(connection.getReply()) else -1;
    }

    doc "If key already exists and is a string, this command appends the value at the end of the string. 
If key does not exist it is created and set as an empty string
         
Time Complexity 0(1) assuming the appended value length is smaller then the key."
    shared actual Integer append(String key, String val) {
        connection.sendCommand("APPEND", { key, val });
        return parseInteger(connection.getReply()) else -1;
    }

    doc "Set the key to the specified value and returns the original value
        
Time complexity: O(1)"
    shared actual String getSet(String key, String val) {
        connection.sendCommand("GETSET", { key, val });
        return connection.getReply();
    }

    doc "Set key to hold the string value and set key to timeout after a given number of seconds, This is an atomic action

Time complexity: O(1)"
    shared actual String setex(String key, Integer seconds, String val) {
        connection.sendCommand("SETEX", { key, seconds.string, val });
        return connection.getReply();
    }

    doc "Set key to hold string value if key does not exist. 

 In that case, it is equal to SET. 
 When key already holds a value, no operation is performed. 
 SETNX is short for 'SET if N ot e X ists'.

 Time Complexity 0(1)"
    shared actual Integer setnx(String key, String val) {
        connection.sendCommand("SETNX", { key, val });
        return parseInteger(connection.getReply()) else -1;
    }

    doc "Returns a substring of the value for the specified key"
    shared actual String substr(String key, Integer start, Integer end) {
        connection.sendCommand("SUBSTR", { key, start.string, end.string });
        return connection.getReply();
    }

    doc "Delete one or more hash fields

Time complexity: O(N) where N is the number of fields to be removed."
    shared actual Integer hdel(String key, String... fields) {
        SequenceBuilder<String> sb = SequenceBuilder<String>();
        sb.append(key);
        for (String field in fields) {
            sb.append(field);
        }
        connection.sendCommand("HDEL", sb.sequence);
        return parseInteger(connection.getReply()) else -1;
    }


    doc "Returns true if field is an existing field in the hash stored at key.

Time complexity: O(1)"
    shared actual Boolean hexists(String key, String field) {
        connection.sendCommand("HEXISTS", { key, field });
        return connection.getReply() == "1";
    }

    
    doc "Returns all the field keys for a hashkey

Time complexity: O(N) where N is the size of the hash."
    shared actual Iterable<String> hkeys(String key) {
        connection.sendCommand("HKEYS", { key });
        return connection.getBulkReply();
    }
    doc "Returns the number of fields contained in the hash"
    shared actual Integer hlen(String key) {
       connection.sendCommand("HLEN", { key });
       return parseInteger(connection.getReply()) else -1;
    }

    doc "Returns all the field values for a hashkey

Time complexity: O(N) where N is the size of the hash."
    shared actual Iterable<String> hvals(String key) {
        connection.sendCommand("HVALS", { key });
        return connection.getBulkReply();
    }

    doc "Add the specified members to the set stored at key. 

Specified members that are already a member of this set are ignored. 
If key does not exist, a new set is created before adding the specified members.
An error is returned when the value stored at key is not a set.
Time complexity: O(N) where N is the number of members to be added."
    shared actual Integer sadd(String key, String... member) {
        SequenceBuilder<String> sb = SequenceBuilder<String>();
        sb.append(key);
        for (String string in member) {
            sb.append(string);
        }
        connection.sendCommand("SADD", sb.sequence);
//TODO howto distinguish between error and result
        return parseInteger(connection.getReply()) else -1;
    }

    doc "Returns all the members of the set value stored at key.

Time complexity: O(N) where N is the set cardinality."
    shared actual Set<String> smembers(String key) {
        connection.sendCommand("SMEMBERS", { key });
        HashSet<String> result = HashSet<String>();
        for (String member in connection.getBulkReply()) {
            result.add(member);
        }
        return result;
    }

    doc "Remove the specified members from the set stored at key. 

Specified members that are not a member of this set are ignored. 
If key does not exist, it is treated as an empty set and this command returns 0.
Time complexity: O(N) where N is the number of members to be removed."
    shared actual Integer srem(String key, String... member) {
        SequenceBuilder<String> sb = SequenceBuilder<String>();
        sb.append(key);
        for (String string in member) {
            sb.append(string);
        }
        connection.sendCommand("SREM", sb.sequence);
//TODO howto distinguish between error and result
        return parseInteger(connection.getReply()) else -1;
    }

    

    
}