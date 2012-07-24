import java.io {OutputStream, InputStream}
import java.lang { JString=String{format} }
import ceylon.interop.java { javaString }

doc "Contains all the know-how on how to talk to Redis"
by "Gertjan Assies"
shared class Protocol() {
    String commandPattern = "*%s\r\n$%s\r\n%s\r\n";
    String argPattern = "$%s\r\n%s\r\n";

    Integer plusSymbol     = 43;
    Integer minusSymbol    = 45;
    Integer colonSymbol    = 58;
    Integer dollarSymbol   = 36;
    Integer asteriksSymbol = 42;


    doc "A command will look like this:
        *<number of arguments> CR LF
        $<number of bytes of argument 1> CR LF
        <argument data> CR LF
        ...
        $<number of bytes of argument N> CR LF
        <argument data> CR LF"
    shared void sendCommand(OutputStream os, String command, Empty|Sequence<String> args) {
        StringBuilder sb = StringBuilder();
        sb.append(format(commandPattern, args.size+1, command.size, command));
        for (String arg in args) {
            sb.append(format(argPattern, arg.size, arg));
        }
        os.write(javaString(sb.string).bytes);
    }

    doc "The Type of response is based on the first character
        With a single line reply the first byte of the reply will be '+'
        With an error message the first byte of the reply will be '-'
        With an integer number the first byte of the reply will be ':'
        With bulk reply the first byte of the reply will be '$'
        With multi-bulk reply the first byte of the reply will be '*'
        "
    shared Iterable<String> read(InputStream inputStream) {
        Integer first = inputStream.read();
        //print("FIRST:"+first.string);
        if (first == minusSymbol) {
            return processError(inputStream);
        } else if (first == dollarSymbol) {
            return {processBulkReply(inputStream)};
        } else if (first == asteriksSymbol) {
            return processMultiBulkReply(inputStream);
        } else if (first == plusSymbol) {
            return processStatusCodeReply(inputStream);
        } else if (first == colonSymbol) {
            return processInteger(inputStream);
        } else {
            return {"ERROR, not a valid response"};
        }
    } 

    Iterable<String> processError(InputStream inputStream) {
        return {readline(inputStream)};
    } 

    Iterable<String> processMultiBulkReply(InputStream inputStream) {
        SequenceBuilder<String> result = SequenceBuilder<String>();
        variable Integer length := parseInteger(readline(inputStream)) else 0;
        while (length > 0) {
            inputStream.read();
            result.append(processBulkReply(inputStream));
            length--;
        }
       return result.sequence;
    } 

    Iterable<String> processInteger(InputStream inputStream) {
        return {readline(inputStream)};
    } 
    
    String processBulkReply(InputStream inputStream) {
        variable Integer length := parseInteger(readline(inputStream)) else 0;
        if (length == -1) {
            return "";
        }
        StringBuilder result = StringBuilder();
        variable Integer cnt := 0;
        while (cnt < length) {
            result.appendCharacter(inputStream.read().character);
            cnt++;
        }
        inputStream.read();
        inputStream.read();
        return result.string;
    } 

    Iterable<String> processStatusCodeReply(InputStream inputStream) {
        return {readline(inputStream)};
    } 

    String readline(InputStream inputStream) {
        variable StringBuilder sb := StringBuilder();

        while (true) {
            Integer b = inputStream.read();
            if (b == 13) {
                Integer c = inputStream.read();
                 if (c == 10) {
                    break;
                } else {
                    sb.appendCharacter(b.character);
                    sb.appendCharacter(c.character);
                }
            } else {
                sb.appendCharacter(b.character);
            }
        }
        return sb.string;
    }
    
}
