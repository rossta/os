package lib;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.Hashtable;

/**
 * User: Ross Kaffenberger
 * Date: Sep 22, 2009
 * Time: 11:33:37 PM
 */
public class Linker {
    private LinkerReader reader;
    private MemoryParser memoryParser = new MemoryParser(this);
    private AddressParser addressParser = new AddressParser(this);

    public Linker(String fileName) throws FileNotFoundException {
        this.reader = new LinkerReader(fileName);
    }

    public void link() throws IOException {
        clear();

        addressParser.parse();
        memoryParser.parse();
    }

    private void clear() {
        SymbolTable.clear();
        MemoryMap.clear();
    }

    public LinkerReader getReader() {
        return reader;
    }

    public String toString() {
        String output = SymbolTable.getInstance().toString();
        output += "\n";
        output += MemoryMap.getInstance().toString();
        output += "\n";
        return output;

    }
}
