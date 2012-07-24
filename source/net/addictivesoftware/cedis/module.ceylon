Module module {
    name='net.addictivesoftware.cedis';
    version='1.0.0';
    doc = "A Redis client for Ceylon";
    by = { "Gertjan Assies" };
    license = 'http://www.apache.org/licenses/LICENSE-2.0.html';
    dependencies = {
        Import {
            name = 'ceylon.interop.java';
            version = '0.3.1';
            optional = false;
            export = false;
        },
        Import {
            name = 'ceylon.collection';
            version = '0.3.1';
            optional = false;
            export = false;
        }
    };
}