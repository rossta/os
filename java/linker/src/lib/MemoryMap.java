package lib;

import java.util.Hashtable;
import java.util.ArrayList;
import java.util.Iterator;

/**
 * User: Ross Kaffenberger
 * Date: Sep 22, 2009
 * Time: 11:35:43 PM
 */
public class MemoryMap {
    private static MemoryMap memoryMap = new MemoryMap();
    private ArrayList<ProgramModule> modules;
    private ArrayList<String> warnings;

    private MemoryMap() {
        modules = new ArrayList<ProgramModule>();
        warnings = new ArrayList<String>();
    }

    public static void validate() {
        ArrayList<String> uses = collectAllUses();

        for (String unusedDefinition : SymbolTable.symbols().keySet()) {
            if (!uses.contains(unusedDefinition)) {
                getWarnings().add("Warning: " + unusedDefinition + " was defined in module " + getModuleIndex(unusedDefinition)
                        + " but never used.");
            }
        }

        for (ProgramModule module : instanceModules()) {
            for(String unusedUse : module.unusedSymbols()) {
                getWarnings().add("Warning: In module "
                        + moduleIndex(module) + " "
                        + unusedUse + " appeared in the use list but was not actually used.");

            }
        }

    }

    private static ArrayList<String> collectAllUses() {
        ArrayList<String> uses = new ArrayList<String>();
        for (ProgramModule module : instanceModules()) {
            for (String use : module.getUses()) {
                if (!uses.contains(use)) {
                    uses.add(use);
                }
            }
        }
        return uses;
    }

    private static int getModuleIndex(String sym) {
        for (ProgramModule module : instanceModules()) {
            if (module.defines(sym)) {
                return moduleIndex(module);
            }
        }
        return 1;
    }

    private static int moduleIndex(ProgramModule module) {
        return instanceModules().indexOf(module) + 1;
    }

    private static ArrayList<ProgramModule> instanceModules() {
        return getInstance().getModules();
    }


    public static void createProgramModule(int baseAddress, Hashtable moduleSymbols) {
        ProgramModule module = new ProgramModule(baseAddress);
        module.setSymbols(moduleSymbols);
        MemoryMap.getInstance().add(module);
    }

    private void add(ProgramModule module) {
        this.modules.add(module);
    }

    public static MemoryMap getInstance() {
        return memoryMap;
    }

    public static ArrayList<String> getWarnings() {
        return getInstance().warnings;
    }

    public String toString() {
        String result = "Memory Map\n";
        for (ProgramModule module : modules) {
            result += module.toString() + "\n";
        }
        for (String warning : MemoryMap.getWarnings()) {
            result += "\n" + warning;
        }

        return result;
    }

    public ArrayList<ProgramModule> getModules() {
        return modules;
    }

    public static void clear() {
        memoryMap = new MemoryMap();
    }
}
