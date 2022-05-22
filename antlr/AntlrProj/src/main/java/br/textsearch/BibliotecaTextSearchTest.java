package br.textsearch;

import br.textsearch.parser.BibliotecaTextSearchLexer;
import br.textsearch.parser.BibliotecaTextSearchParser;
import org.antlr.runtime.ANTLRStringStream;
import org.antlr.v4.runtime.ANTLRFileStream;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.tree.ParseTree;
import org.antlr.v4.runtime.tree.ParseTreeWalker;

import java.nio.charset.Charset;

public class BibliotecaTextSearchTest {

    public static void main(String[] args) throws Exception {
        String fileName = args[0];
        CharStream stream = CharStreams.fromFileName(fileName, Charset.forName("utf-8"));
        String pesquisa_original = stream.toString();
        BibliotecaTextSearchLexer lexer = new BibliotecaTextSearchLexer(stream);
        CommonTokenStream tokens = new CommonTokenStream(lexer);
        BibliotecaTextSearchParser parser = new BibliotecaTextSearchParser(tokens);
        ParseTree tree = parser.pesquisa();
        String pesquisa = tree.getText();
        ParseTreeWalker walker = new ParseTreeWalker();
        BibliotecaTextSearchWalker geraTextSearchComParen = new BibliotecaTextSearchWalker(pesquisa, true);
        BibliotecaTextSearchWalker geraTextSearchSemParen = new BibliotecaTextSearchWalker(pesquisa, false);
        walker.walk(geraTextSearchComParen, tree);
        String resultado;
        if (!geraTextSearchComParen.isTemErro()) {
            if (geraTextSearchComParen.isUserParenPresent()) {
                walker.walk(geraTextSearchSemParen, tree);
                resultado = geraTextSearchSemParen.getPesquisa();
            } else if (!geraTextSearchComParen.isBoolOperPresent()) {
                walker.walk(geraTextSearchSemParen, tree);
                resultado = geraTextSearchSemParen.getPesquisa();
            } else {
                resultado = geraTextSearchComParen.getPesquisa();
            }
        }else{
            StringBuilder resultadoBuilder = new StringBuilder(pesquisa_original.length());
            for (char ch : pesquisa_original.toCharArray()) {
                if (ch == '[' || ch == ']' || ch == '{' || ch == '}' ||
                        ch == '=' || ch == ':' || ch == '!' || ch == '@' ||
                        ch == '%' || ch == '^' || ch == '~' || ch == '(' || ch == ')') {
                    resultadoBuilder.append('\\');
                    resultadoBuilder.append(ch);
                } else {
                    resultadoBuilder.append(ch);
                }
            }
            resultado = resultadoBuilder.toString();
        }
        System.out.println("resultado: "+ resultado);

    }

}
