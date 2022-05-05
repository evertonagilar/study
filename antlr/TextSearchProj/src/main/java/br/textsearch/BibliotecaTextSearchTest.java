package br.textsearch;

import org.antlr.v4.runtime.ANTLRFileStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.tree.ParseTree;
import org.antlr.v4.runtime.tree.ParseTreeWalker;

public class BibliotecaTextSearchTest {

    public static void main(String[] args) throws Exception {
        BibliotecaTextSearchLexer lexer = new BibliotecaTextSearchLexer(new ANTLRFileStream(args[0]));
        CommonTokenStream tokens = new CommonTokenStream(lexer);
        BibliotecaTextSearchParser parser = new BibliotecaTextSearchParser(tokens);
        ParseTree tree = parser.pesquisa();
        ParseTreeWalker walker = new ParseTreeWalker();
        walker.walk(new BibliotecaTextSearchWalker(), tree);
    }

}
