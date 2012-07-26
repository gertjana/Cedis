

doc "All supported Redis Commands
     Current support based on Redis 2.4.5"
shared interface RedisCommands {

    shared formal Integer               append(String key, String val);
    shared formal Integer 				decr(String key);
    shared formal Integer 				decrBy(String key, Integer integer);
    shared formal Boolean 				existsKey(String key);
    shared formal Integer 				expire(String key, Integer seconds);
	shared formal Integer 				expireAt(String key, Integer unixTime);
    shared formal Integer 				incr(String key);
    shared formal Integer 				incrBy(String key, Integer integer);
    shared formal String 				info();
    shared formal String 				get(String key);
    shared formal Boolean 				getBit(String key, Integer offset);
    shared formal String                getSet(String key, String val);
    shared formal Integer               hdel(String key, String... field);
    shared formal Boolean               hexists(String key, String field);
    shared formal String 				hget(String key, String field);
    shared formal Map<String, String> 	hgetAll(String key);
    shared formal Iterable<String>      hkeys(String key);
    shared formal Integer               hlen(String key);
    shared formal Iterable<String> 		hmget(String key, String... fields);
    shared formal String 				hmset(String key, Map<String, String> hash);
    shared formal Integer	 			hset(String key, String field, String val);
    shared formal Iterable<String>      hvals(String key);
    shared formal Integer               sadd(String key, String... member);
    shared formal String 				set(String key, String val);
    shared formal Boolean 				setBit(String key, Integer offset, Boolean val);
    shared formal String                setex(String key, Integer seconds, String val);
    shared formal Integer               setnx(String key, String val);
    shared formal Set<String>           smembers(String key);
shared formal Integer                   srem(String key, String... member);
    shared formal String                substr(String key, Integer start, Integer end);
    shared formal Integer 				ttl(String key);
    shared formal String 				type(String key);


/*

    shared formal Integer setrange(String key, Integer offset, String val);

    shared formal String getrange(String key, Integer startOffset, Integer endOffset);

    shared formal Integer hsetnx(String key, String field, String val);

    shared formal Integer hincrBy(String key, String field, Integer val);

    shared formal Integer rpush(String key, String... string);

    shared formal Integer lpush(String key, String... string);

    shared formal Integer llen(String key);

    shared formal List<String> lrange(String key, Integer start, Integer end);

    shared formal String ltrim(String key, Integer start, Integer end);

    shared formal String lindex(String key, Integer index);

    shared formal String lset(String key, Integer index, String val);

    shared formal Integer lrem(String key, Integer count, String val);

    shared formal String lpop(String key);

    shared formal String rpop(String key);



    shared formal String spop(String key);

    shared formal Integer scard(String key);

    shared formal Boolean sismember(String key, String member);

    shared formal String srandmember(String key);

    shared formal Integer zaddSingle(String key, Number score, String member);
    
    shared formal Integer zaddMulti(String key, Map<Number, String> scoreMembers);

    shared formal Set<String> zrange(String key, Integer start, Integer end);

    shared formal Integer zrem(String key, String... member);

    shared formal Number zincrby(String key, Number score, String member);

    shared formal Integer zrank(String key, String member);

    shared formal Integer zrevrank(String key, String member);

    shared formal Set<String> zrevrange(String key, Integer start, Integer end);

    //shared formal Set<Tuple> zrangeWithScores(String key, Integer start, Integer end);

    //shared formal Set<Tuple> zrevrangeWithScores(String key, Integer start, Integer end);

    shared formal Integer zcard(String key);

    shared formal Number zscore(String key, String member);

    shared formal List<String> sort(String key);

    shared formal List<String> sortWithParams(String key, SortingParams sortingParameters);

    shared formal Integer zcount(String key, Number min, Number max);

    shared formal Integer zcountFromString(String key, String min, String max);

    shared formal Set<String> zrangeByScore(String key, Number min, Number max);

    shared formal Set<String> zrangeByScoreFromString(String key, String min, String max);

    shared formal Set<String> zrevrangeByScore(String key, Number max, Number min);

    shared formal Set<String> zrangeByScoreWithOffset(String key, Number min, Number max, Integer offset,
            Integer count);
 
    shared formal Set<String> zrevrangeByScoreFromString(String key, String max, String min);

    shared formal Set<String> zrangeByScoreFromStringWithOffset(String key, String min, String max, Integer offset,
            Integer count);

    shared formal Set<String> zrevrangeByScoreWithOffset(String key, Number max, Number min,
            Integer offset, Integer count);

//    shared formal Set<Tuple> zrangeByScoreWithScores(String key, Number min, Number max);

//    shared formal Set<Tuple> zrevrangeByScoreWithScores(String key, Number max, Number min);

//    shared formal Set<Tuple> zrangeByScoreWithScores(String key, Number min, Number max,
//            Integer offset, Integer count);
    
    shared formal Set<String> zrevrangeByScoreFromStringWithOffset(String key, String max, String min,
            Integer offset, Integer count);

//    shared formal Set<Tuple> zrangeByScoreWithScores(String key, String min, String max);
    
//    shared formal Set<Tuple> zrevrangeByScoreWithScores(String key, String max, String min);

//    shared formal Set<Tuple> zrangeByScoreWithScores(String key, String min, String max,
//            Integer offset, Integer count);

//    shared formal Set<Tuple> zrevrangeByScoreWithScores(String key, Number max, Number min,
//            Integer offset, Integer count);
    
//    shared formal Set<Tuple> zrevrangeByScoreWithScores(String key, String max, String min,
//            Integer offset, Integer count);

    shared formal Integer zremrangeByRank(String key, Integer start, Integer end);

    shared formal Integer zremrangeByScore(String key, Number start, Number end);
    
    shared formal Integer zremrangeByScoreFromString(String key, String start, String end);

//    shared formal Integer linsert(String key, Client.LIST_POSITION where, String pivot,
//            String val);
    
    shared formal Integer lpushx(String key, String string);
    
    shared formal Integer rpushx(String key, String string); 
*/
}
