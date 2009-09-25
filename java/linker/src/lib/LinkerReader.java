package lib; /**
 * User: Ross Kaffenberger
 * Date: Sep 22, 2009
 * Time: 11:11:38 PM
 */
import java.io.*;

public class LinkerReader {
    File file;
    FileReader fr;
    BufferedReader br;
    private String fileName;

    public LinkerReader(String fileName) throws FileNotFoundException {
        this.fileName = fileName;
        this.file = new File(fileName);
        this.fr = new FileReader(file);
        this.br = new BufferedReader(fr);
    }

    public void rewind() throws IOException {
        this.br.close();
        this.file = new File(fileName);
        this.fr = new FileReader(file);
        this.br = new BufferedReader(fr);

    }

    public boolean ready() throws IOException {
        return this.br.ready();
    }

    public String next() throws IOException {
        if (ready()) {
            return Character.toString((char) this.br.read());
        } else {
            return "";
        }
    }
}
