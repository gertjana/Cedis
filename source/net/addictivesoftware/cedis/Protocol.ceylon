import java.io {OutputStream, InputStream}
import java.lang { JString=String{format} }
import ceylon.interop.java { javaString }

doc "Contains all the know-how on how to talk to a Redis DB"
by "Gertjan Assies"
shared class Protocol() {
    String commandPattern = "*%s\r\n$%s\r\n%s\r\n";
    String argPattern = "$%s\r\n%s\r\n";

    Integer plusSymbol     = 43;
    Integer minusSymbol    = 45;
    Integer colonSymbol    = 58;
    Integer dollarSymbol   = 36;
    Integer asteriksSymbol = 42;


    doc "writes the command and its arguments to the outputStream
    
A command will look like this:

        *[number of arguments] CRLF
        $[number of bytes of argument 1] CRLF
        [argument data] CRLF
        ...
        $[number of bytes of argument N] CRLF
        [argument data] CRLF"
    shared void sendCommand(OutputStream os, String command, Empty|Sequence<String> args) {
        StringBuilder sb = StringBuilder();
        sb.append(format(commandPattern, args.size+1, command.size, command));
        for (String arg in args) {
            sb.append(format(argPattern, arg.size, arg));
        }
        os.write(javaString(sb.string).bytes);
    }

    doc "Gets the response back from the inputstream 

The Type of response is based on the first character  returned

<table style='width:300px;'> 
    <tr>
        <th>First Char</th>
        <th>Description</th>
    </tr>

    <tr>
        <td>+</td>
        <td>a single line reply</td>
    </tr>
    <tr>
        <td>-</td>
        <td>an error message</td>
    </tr>
    <tr>
        <td>:</td>
        <td>an integer number</td>
    </tr>
    <tr>
        <td>$</td>
        <td>bulk reply</td>
    </tr>
    <tr>
        <td>*</td>
        <td>multi-bulk reply, (consists of multiple bulk replies)</td>
    </tr>
</table>
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
