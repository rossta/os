package lib;

import java.io.IOException;
import java.util.regex.Pattern;

/**
 * User: Ross Kaffenberger
 * Date: Sep 22, 2009
 * Time: 11:58:47 PM
 */
public abstract class Parser {
    private Pattern WHITE_SPACE = Pattern.compile("[\\s]", Pattern.CASE_INSENSITIVE);
    private Pattern DIGIT = Pattern.compile("[\\d]", Pattern.CASE_INSENSITIVE);
    private Pattern LETTER = Pattern.compile("[\\w]", Pattern.CASE_INSENSITIVE);
    protected Linker linker;
    private String charString;

    public Parser(Linker linker) {
        this.linker = linker;

    }

    public abstract void parse() throws IOException;

    public String currentCharString() {
        return this.charString;
    }

    protected String parseWord() throws IOException {
        skipWhiteSpace();
        String word = "";
        while(LETTER.matcher(currentCharString()).matches()) {
            word += currentCharString();
            readNextCharString();
        }

        return word;
    }

    protected void skipWhiteSpace() throws IOException {
        while(WHITE_SPACE.matcher(currentCharString()).matches()) {
            readNextCharString();

        }

    }

    protected int parseNumber() throws IOException {
        skipWhiteSpace();
        String num = "";
        while (DIGIT.matcher(currentCharString()).matches()) {
            num += currentCharString();
            readNextCharString();
        }
        return new Integer(num);
    }

    public void readNextCharString() throws IOException {
        this.charString = linker.getReader().next();
    }

    public LinkerReader getReader() {
        return linker.getReader();
    }
}
