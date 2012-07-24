import java.net {InetSocketAddress,Socket, SocketException }
import java.lang {Byte}
import ceylon.interop.java {javaString}
shared class RedisConnection(String host, Integer port, Integer timeout) {
    
    variable Socket socket := Socket();
    variable Protocol protocol := Protocol();

    default shared void connect() {
        if (!isConnected()) {
            socket.reuseAddress := true;
            socket.keepAlive := true;
            socket.tcpNoDelay := true;
            socket.setSoLinger(true, 0);

            socket.connect(InetSocketAddress(host, port), timeout);
            socket.soTimeout := timeout;
        }
    }
    shared void disconnect() {
        if (isConnected()) {
                //socket.inputStream.close();
                //socket.outputStream.close();
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

    shared void sendCommandNoArgs(String cmd) {
        sendCommand(cmd, {});
    }
    shared void sendCommand(String cmd,  Empty|Sequence<String> args) {
        protocol.sendCommand(socket.outputStream, cmd, args);
    }

    shared String getReply() {
        Iterable<String> result = protocol.read(socket.inputStream);
        return result.first else "NO RESULT";
    }

    shared Iterable<String> getBulkReply() {
       return protocol.read(socket.inputStream);
    }

}

