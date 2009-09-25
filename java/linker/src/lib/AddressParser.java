package lib;

import java.io.IOException;
import java.util.Hashtable;

/**
 * User: Ross Kaffenberger
 * Date: Sep 22, 2009
 * Time: 11:37:03 PM
 */
public class AddressParser extends Parser {
    private int baseAddress = 0;

    public AddressParser(Linker linker) {
        super(linker);
    }

    public void parse() throws IOException {
        readNextCharString();
        while (!currentCharString().equals("")) {
            detectSymbolsAndBaseAddresses();
        }

        getReader().rewind();
    }

    private void detectSymbolsAndBaseAddresses() throws IOException {
        Hashtable<String, Integer> moduleSymbols = new Hashtable<String, Integer>();
        int nd = parseNumber();
        for (int i = 1; i <= nd; i++) {
            String symbol = parseWord();
            if (SymbolTable.defines(symbol)) {
                String error = "Error: This variable is multiply defined; first value used.";
                SymbolTable.getInstance().getErrors().put(symbol, error);
            } else {
                moduleSymbols.put(symbol, parseNumber() + this.baseAddress);
                SymbolTable.getInstance().put(symbol, moduleSymbols.get(symbol));
            }
        }
        skipUseList();
        int moduleSize = parseNumber();
        skipProgram(moduleSize);
        MemoryMap.createProgramModule(this.baseAddress, moduleSymbols);
        this.baseAddress += moduleSize;
        skipWhiteSpace();
    }

    private void skipProgram(int moduleSize) throws IOException {
        for (int i = 1; i <= moduleSize; i++) {
            parseWord();
            parseNumber();
        }
    }

    private void skipUseList() throws IOException {
        int nu = parseNumber();
        for (int i = 1; i <= nu; i++) {
            parseWord();
        }

    }

}
