import java.io {OutputStream, InputStream}
import java.lang { Byte, Char=Character }
import ceylon.language {C=Character }
import ceylon.interop.java { javaString }

shared class Protocol() {
    variable Integer dollarByte := Byte.parseByte("$");
    variable Integer asterixByte := Byte.parseByte("*");
    variable Integer plusByte := Byte.parseByte("+");
    variable Integer minusByte := Byte.parseByte("-");
    variable Integer colonByte := Byte.parseByte(":");

    shared void sendCommand(OutputStream os, String command, Sequence<String>|Empty args) {
        os.write(asterixByte);
        os.write(args.size + 1);
        os.write(javaString("\r\n").bytes);
        os.write(dollarByte);
        os.write(command.size);
        os.write(javaString("\r\n").bytes);
        os.write(javaString(command).bytes);
        os.write(javaString("\r\n").bytes);
    
        for (String arg in args) {
            os.write(dollarByte);
            os.write(arg.size);
            os.write(javaString("\r\n").bytes);
            os.write(javaString(arg).bytes);
            os.write(javaString("\r\n").bytes);
        }
    }

    shared String|Iterable<String> read(InputStream inputStream) {
        return process(inputStream);
    }

    shared String process(InputStream inputStream) {
         variable Integer b := inputStream.read();

        if (b == minusByte) {
            processError(inputStream);
        } else if (b == asterixByte) {
        return processMultiBulkReply(inputStream);
        } else if (b == colonByte) {
        return processInteger(inputStream);
        } else if (b == dollarByte) {
        return processBulkReply(inputStream);
        } else if (b == plusByte) {
        return processStatusCodeReply(inputStream);
        } else {
            throw Exception("Unknown reply: " + b.string);
        }
        return "";
    } 
    shared String processError(InputStream inputStream) {
        return "";
    } 
    shared String processMultiBulkReply(InputStream inputStream) {
        return "";
    } 
    shared String processInteger(InputStream inputStream) {
        return "";
    } 
    shared String processBulkReply(InputStream inputStream) {
        Integer? len = parseInteger(readline(inputStream));
        if (!len exists) {
            return "";
        } else {
            Array<Integer> read = arrayOfSize<Integer>(0, len else 0);
            variable Integer offset := 0;
            while (offset < (len else 0)) {
                offset += inputStream.read(read, offset, ((len else 0)- offset));
            }
            // read 2 more bytes for the command delimiter
            inputStream.read();
            inputStream.read();
            return read.string;
        }
    } 

    shared String processStatusCodeReply(InputStream inputStream) {
        return "";
    } 

    String readline(InputStream inputStream) {
        variable Array<Integer> result := arrayOfSize<Integer>(0,0);
        variable Integer cnt := 0;
        while (true) {
            Integer b = inputStream.read();
            result.setItem(cnt,b);
            cnt++;
        }
        return javaString("").copyValueOf(result));
    }
    
}
