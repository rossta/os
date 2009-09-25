package lib;

import java.util.Hashtable;
import java.util.ArrayList;

/**
 * User: Ross Kaffenberger
 * Date: Sep 23, 2009
 * Time: 8:42:21 AM
 */
public class ProgramModule {
    private int baseAddress;
    private Hashtable moduleSymbols;
    private ArrayList<String> uses;
    private ArrayList<Instruction> instructions;

    public ProgramModule(int baseAddress) {
        this.baseAddress = baseAddress;
        this.uses = new ArrayList<String>();
        this.instructions = new ArrayList<Instruction>();
    }

    public String toString() {
        String text = "";
        for (Instruction instruction : this.instructions) {
            int index = this.baseAddress + instructions.indexOf(instruction);
            text += "" + index;
            text += ": ";
            text += instruction.toString();
            if (this.instructions.indexOf(instruction) != (this.instructions.size() - 1)) {
                text += "\n";
            }
        }
        return text;
    }

    public void setSymbols(Hashtable moduleSymbols) {
        this.moduleSymbols = moduleSymbols;

    }

    public void addUse(String symbol) {
        this.uses.add(symbol);

    }

    public void createInstruction(String type, int word) {
        this.instructions.add(new Instruction(type, word));
    }

    public void mapInstructions() {
        for (Instruction instruction : this.instructions) {
            String symbol = null;
            if (instruction.getAddress() < this.uses.size()) {
                symbol = this.uses.get(instruction.getAddress());
            }
            instruction.updateAddress(symbol, baseAddress, this.instructions.size());
        }
    }

    public ArrayList<String> getUses() {
        return this.uses;
    }

    public boolean defines(String sym) {
        return this.moduleSymbols.keySet().contains(sym);
    }

    public ArrayList<String> unusedSymbols() {
        ArrayList<String> unused = this.uses;
        boolean allInstructionsInvalid = true;
        for (Instruction instr : this.instructions) {
            allInstructionsInvalid = allInstructionsInvalid && !instr.isValid();
            if (instr.getType().equals("E")) {
                if (instr.getSymbol() != null && unused.contains(instr.getSymbol())) {
                    unused.remove(instr.getSymbol());
                }
            }
        }
        if (allInstructionsInvalid) {
            return new ArrayList<String>(0);
        } else {
            return unused;
        }
    }
}
