shared interface Commands {
    formal shared void set(String key, String val);

    formal shared void get(String key);

/*
    formal shared void keyExists(String key);

    formal shared void del(String... keys);

    formal shared void type(String key);

    formal shared void keys(String pattern);

    formal shared void rename(String oldkey, String newkey);

    formal shared void renamenx(String oldkey, String newkey);

    formal shared void expire(String key, Integer timeoutInSeconds);

    formal shared void expireAt(String key, Number unixTime);

    formal shared void ttl(String key);

    formal shared void setbit(String key, Number offset, Boolean val);

    formal shared void getbit(String key, Number offset);

    formal shared void setrange(String key, Number offset, String val);

    formal shared void getrange(String key, Number startOffset, Number endOffset);

    formal shared void move(String key, Integer dbIndex);

    formal shared void getSet(String key, String val);

    formal shared void mget(String... keys);

    formal shared void setnx(String key, String val);

    formal shared void setex(String key, Integer expiresInSeconds, String val);

    formal shared void mset(String... keysvalues);

    formal shared void msetnx(String... keysvalues);

    formal shared void decrBy(String key, Number integer);

    formal shared void decr(String key);

    formal shared void incrBy(String key, Number integer);

    formal shared void incr(String key);

    formal shared void append(String key, String val);

    formal shared void substr(String key, Integer start, Integer end);

    formal shared void hset(String key, String field, String val);

    formal shared void hget(String key, String field);

    formal shared void hsetnx(String key, String field, String val);

    formal shared void hmset(String key, Map<String, String> hash);

    formal shared void hmget(String key, String... fields);

    formal shared void hincrBy(String key, String field, Number val);

    formal shared void hexists(String key, String field);

    formal shared void hdel(String key, String... fields);

    formal shared void hlen(String key);

    formal shared void hkeys(String key);

    formal shared void hvals(String key);

    formal shared void hgetAll(String key);

    formal shared void rpush(String key, String... strings);

    formal shared void lpush(String key, String... strings);

    formal shared void llen(String key);

    formal shared void lrange(String key, Number start, Number end);

    formal shared void ltrim(String key, Number start, Number end);

    formal shared void lindex(String key, Number index);

    formal shared void lset(String key, Number index, String val);

    formal shared void lrem(String key, Number count, String val);

    formal shared void lpop(String key);

    formal shared void rpop(String key);

    formal shared void rpoplpush(String srckey, String dstkey);

    formal shared void sadd(String key, String... members);

    formal shared void smembers(String key);

    formal shared void srem(String key, String... member);

    formal shared void spop(String key);

    formal shared void smove(String srckey, String dstkey,
        String member);

    formal shared void scard(String key);

    formal shared void sismember(String key, String member);

    formal shared void sinter(String... keys);

    formal shared void sinterstore(String dstkey, String... keys);

    formal shared void sunion(String... keys);

    formal shared void sunionstore(String dstkey, String... keys);

    formal shared void sdiff(String... keys);

    formal shared void sdiffstore(String dstkey, String... keys);

    formal shared void srandmember(String key);

    formal shared void zadd(String key, Float score, String member);

    formal shared void zaddMultiple(String key, Map<Float, String> scoreMembers);

    formal shared void zrange(String key, Number start, Number end);

    formal shared void zrem(String key, String... members);

    formal shared void zincrby(String key, Float score,
        String member);

    formal shared void zrank(String key, String member);

    formal shared void zrevrank(String key, String member);

    formal shared void zrevrange(String key, Number start, Number end);

    formal shared void zrangeWithScores(String key, Number start,
        Number end);

    formal shared void zrevrangeWithScores(String key, Number start,
        Number end);

    formal shared void zcard(String key);

    formal shared void zscore(String key, String member);

    formal shared void watch(String... keys);

    formal shared void sort(String key);

    formal shared void sortWithParams(String key, SortingParams sortingParameters);

    formal shared void blpop(String[] args);

    formal shared void sortWithParamsAndDestination(String key, SortingParams sortingParameters,
        String dstkey);

    formal shared void sortWithDestination(String key, String dstkey);

    formal shared void brpop(String[] args);

    formal shared void brpoplpush(String source, String destination, Integer timeout);

    formal shared void zcount(String key, Float min, Float max);

    formal shared void zcountFromString(String key, String min, String max);

    formal shared void zrangeByScore(String key, Float min, Float max);

    formal shared void zrangeByScore(String key, String min, String max);

    formal shared void zrangeByScore(String key, Float min, Float max, Integer offset, Integer count);

    formal shared void zrangeByScoreWithScores(String key, Float min, Float max);

    formal shared void zrangeByScoreWithScores(String key, Float min, Float max, Integer offset, Integer count);

    formal shared void zrangeByScoreWithScores(String key, String min, String max);

    formal shared void zrangeByScoreWithScores(String key, String min, String max, Integer offset, Integer count);

    formal shared void zrevrangeByScore(String key, Float max, Float min);

    formal shared void zrevrangeByScore(String key, String max, String min);

    formal shared void zrevrangeByScore(String key, Float max, Float min, Integer offset, Integer count);

    formal shared void zrevrangeByScoreWithScores(String key, Float max, Float min);

    formal shared void zrevrangeByScoreWithScores(String key, Float max, Float min, Integer offset, Integer count);

    formal shared void zrevrangeByScoreWithScores(String key, String max, String min);

    formal shared void zrevrangeByScoreWithScores(String key, String max, String min, Integer offset, Integer count);

    formal shared void zremrangeByRank(String key, Number start, Number end);

    formal shared void zremrangeByScore(String key, Float start, Float end);

    formal shared void zremrangeByScore(String key, String start, String end);

    formal shared void zunionstore(String dstkey, String... sets);

    formal shared void zunionstore(String dstkey, ZParams params, String... sets);

    formal shared void zinterstore(String dstkey, String... sets);

    formal shared void zinterstore(String dstkey, ZParams params, String... sets);

    formal shared void strlen(String key);

    formal shared void lpushx(String key, String string);

    formal shared void persist(String key);

    formal shared void rpushx(String key, String string);

    formal shared void echo(String string);

    formal shared void linsert(String key, LIST_POSITION where, String pivot, String val);

    formal shared void bgrewriteaof();

    formal shared void bgsave();

    formal shared void lastsave();

    formal shared void save();

    formal shared void configSet(String parameter, String val);

    formal shared void configGet(String pattern);

    formal shared void configResetStat();

    formal shared void multi();

    formal shared void exec();

    formal shared void discard();

    formal shared void objectRefcount(String key);

    formal shared void objectIdletime(String key);

    formal shared void objectEncoding(String key);
*/

}