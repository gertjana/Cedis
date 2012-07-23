doc "Run the module `cedis`."
void run() {
    RedisConnection rd = RedisConnection();
    rd.connect();
   //rd.info();
}