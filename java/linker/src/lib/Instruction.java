package lib;

import java.util.ArrayList;

/**
 * User: Ross Kaffenberger
 * Date: Sep 24, 2009
 * Time: 1:02:16 AM
 */
public class Instruction {
    protected String type;
    private int address;
    private ArrayList<String> errors;
    private int opCode;
    private String symbol;

    public Instruction(String type, int word) {
        this.type = type;
        this.address = word % 1000;
        this.opCode = (word - this.address) / 1000;
        this.errors = new ArrayList<String>();
    }

    public int getAddress() {
        return address;
    }

    public void updateAddress(String symbol, int baseAddress, int size) {
        if (this.type.equals("R")) {
            validateAndUpdateRelativeAddress(baseAddress, size);
        } else if (this.type.equals("E")) {
            validateAndUpdateExternalAddress(symbol);
        }

        if (!this.type.equals("I")) {
            validateMachineSize();
        }
    }

    private void setAddress(int address) {
        this.address = address;
    }

    public String toString() {
        String text = "" + getWord();
        if (!isValid()) {
            for (String error : this.errors) {
                text += " " + error;
            }
        }
        return text;
    }

    public boolean isValid() {
        return this.errors.isEmpty();
    }

    public int getWord() {
        return (this.opCode * 1000) + this.address;
    }

    private void validateMachineSize() {
        if(getAddress() > Machine.SIZE) {
            this.errors.add("Error: Absolute address exceeds machine size; zero used");
            setAddress(0);
        }
    }

    private void validateAndUpdateRelativeAddress(int baseAddress, int size) {
        if (getAddress() > size) {
            setAddress(0);
            this.errors.add("Error: Relative address exceeds length module size; zero used");
        } else {
            setAddress(getAddress() + baseAddress);
        }
    }

    private void validateAndUpdateExternalAddress(String symbol) {
        if (symbol == null) {
            this.errors.add("Error: External address exceeds length of use list; treated as immediate");
        } else if (SymbolTable.address(symbol) != null) {
            this.symbol = symbol;
            setSymbol(symbol);
            setAddress((Integer) SymbolTable.address(symbol));
        } else {
            setAddress(0);
            this.errors.add("Error: " + symbol + " is not defined; zero used");
        }

    }

    private void setSymbol(String symbol) {
        this.symbol = symbol;
    }

    public String getType() {
        return this.type;
    }

    public String getSymbol() {
        return this.symbol;
    }
}
