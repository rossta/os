package lib;

import java.io.IOException;

/**
 * User: Ross Kaffenberger
 * Date: Sep 23, 2009
 * Time: 7:55:22 AM
 */
public class Runner {

    public static void main(String args[]) throws IOException {
        if (args.length == 1) {
            Linker linker = new Linker(args[0]);
            linker.link();
            System.out.println(linker.toString());
        } else {
            System.out.println("Usage: Please enter a valid filename");
        }
    }
}
