import java.lang {System{currentTimeMillis}}
import ceylon.interop.java {javaString}
import ceylon.collection {HashMap}
import net.addictivesoftware.cunit { CUnitRunner }

doc "runs the unittests"
void test() {
    CUnitRunner().execute("net.addictivesoftware.cedis.CedisTests");
}

doc "Run the module `cedis`. some poor man's Unit Tests"
void run() {
    runBenchMarks();
}

Integer nrOfKeys = 10000;

shared void runBenchMarks() {
    print("Running Benchmarks...");
    Cedis cedis = Cedis();
    cedis.connect();
    cedis.flushAll();
    print("creating " + nrOfKeys.string + " key-values");
    variable Integer start := currentTimeMillis();
    for (i in 1..nrOfKeys) {
        cedis.set("key_"+i.string, i.string);
    }
    variable Integer end := currentTimeMillis();
    print((end-start).string + " ms");

    print("creating " + nrOfKeys.string + " hash key-values");
    start := currentTimeMillis();
    for (i in 1..nrOfKeys) {
        cedis.hset("key_"+i.string, i.string, i.string);
    }
    end := currentTimeMillis();
    print((end-start).string + " ms");
}

 
