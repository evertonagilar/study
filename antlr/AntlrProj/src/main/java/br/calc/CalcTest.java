package br.calc;

public class CalcTest {

    public static void main(String[] args) {
        ExprEval calc = new ExprEval();
        Number result;

        result = calc.execute("/home/evertonagilar/study/antlr/AntlrProj/src/main/java/br/calc/calc.txt");
        System.out.println("Resultado = " + result);

    }


}
