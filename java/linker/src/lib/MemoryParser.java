package lib;

import java.io.IOException;

/**
 * User: Ross Kaffenberger
 * Date: Sep 22, 2009
 * Time: 11:36:22 PM
 */
public class MemoryParser extends Parser {
    public MemoryParser(Linker linker) {
        super(linker);
    }

    public void parse() throws IOException {
        readNextCharString();
        for (ProgramModule module : MemoryMap.getInstance().getModules()) {
            detectUses(module);
            detectInstructions(module);
        }
        getReader().rewind();

        MemoryMap.validate();
    }

    private void detectInstructions(ProgramModule module) throws IOException {
        int nt = parseNumber();
        for (int i = 1; i <= nt; i++) {
            String type = parseWord();
            int word = parseNumber();

            module.createInstruction(type, word);
        }
        module.mapInstructions();
    }

    private void skipSymbols() throws IOException {
        int times = parseNumber();
        for (int i = 1; i <= times; i++) {
            parseWord();
            parseNumber();
        }

    }

    private void detectUses(ProgramModule module) throws IOException {
        skipSymbols();
        int nu = parseNumber();
        for (int i = 1; i <= nu; i++) {
            module.addUse(parseWord());
        }
    }
}
