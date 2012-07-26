doc "Main entrypoint, should be called from IDE integration or commandline"
shared class CUnitRunner() {

    doc "Executes test annotated methods in specified class"
    shared void execute(String className) {
        print(JavaCUnitRunner().execute(className));
    }
}