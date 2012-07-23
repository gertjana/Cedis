import java.net {InetSocketAddress,Socket, SocketException }
import java.lang {Byte}
import ceylon.interop.java {javaString}
shared class RedisConnection(String host="localhost", Integer port=6379, Integer timeout=2000) {
    
    variable Socket socket := Socket();
    variable Integer pipelinedCommands := 0;
    variable Protocol protocol := Protocol();
    //variable RedisOutputStream outputStream;
    //variable RedisInputStream inputStream;

    default shared void connect() {
        if (!isConnected()) {
            socket.reuseAddress := true;
            socket.keepAlive := true;
            socket.tcpNoDelay := true;
            socket.setSoLinger(true, 0);

            socket.connect(InetSocketAddress(host, port), timeout);
            socket.soTimeout := timeout;

            //outputStream = new RedisOutputStream(socket.getOutputStream());
            //inputStream = new RedisInputStream(socket.getInputStream());
        }
    }
    shared void disconnect() {
        if (isConnected()) {
                socket.inputStream.close();
                socket.outputStream.close();
                if (!socket.closed) {
                    socket.close();
                }
        }
    }
    shared Boolean isConnected() {
        return   socket.bound && 
                 socket.connected && 
                !socket.closed && 
                !socket.inputShutdown && 
                !socket.outputShutdown;
    }

    doc "Send command with no arguments"
    RedisConnection sendCommand(String cmd) {
        connect();
        Sequence<String> args = ArraySequence<String>();
        protocol.sendCommand(socket.outputStream, cmd, args);
        pipelinedCommands++;
        return this;
    }
    
    shared String info() {
        connect();
        sendCommand("info");
        return getBulkReply();
    }

    shared String getBulkReply() {
        return protocol.read(socket.inputStream);
    }
}

