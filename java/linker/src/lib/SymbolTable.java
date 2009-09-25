package lib;

import java.util.Hashtable;
import java.util.Set;
import java.util.Enumeration;
import java.util.ArrayList;

/**
 * User: Ross Kaffenberger
 * Date: Sep 22, 2009
 * Time: 10:19:12 PM
 */
public class SymbolTable {
    private Hashtable<String, Integer> symbols;
    private static SymbolTable table = new SymbolTable();

    private Hashtable<String, String> errors;
    private ArrayList<String> warnings;

    private SymbolTable() {
        this.symbols = new Hashtable<String, Integer>();
        this.errors = new Hashtable<String, String>();
        this.warnings = new ArrayList<String>();
    }

    public static SymbolTable getInstance() {
        return table;
    }

    public static void clear() {
        table = new SymbolTable();
    }

    public static Hashtable<String, Integer> symbols() {
        return table.getSymbols();
    }

    public Hashtable<String, Integer> getSymbols() {
        return symbols;
    }

    public static Object address(String symbol) {
        return table.symbols.get(symbol);
    }

    public Set keys() {
        return table.symbols.keySet();
    }

    public static boolean defines(String symbol) {
         return address(symbol) != null;
    }

    public void put(String symbol, int address) {
        this.symbols.put(symbol, address);
    }

    public Integer get(String key) {
        return symbols.get(key);
    }

    public Hashtable<String, String> getErrors() {
        return this.errors;
    }

    public ArrayList<String> getWarnings() {
        return warnings;
    }

    public String toString() {
        String result = "Symbol Table\n";
        Enumeration keys = getSymbols().keys();
        while(keys.hasMoreElements()) {
            String sym = (String) keys.nextElement();
            result += sym;
            result += "=";
            result += getSymbols().get(sym).toString();
            if (getErrors().get(sym) != null) {
                result += " " + getErrors().get(sym);
            }
            result += "\n";
        }
        return result;
    }
}
