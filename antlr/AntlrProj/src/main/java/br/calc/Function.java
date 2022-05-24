package br.calc;

import org.antlr.v4.runtime.tree.RuleNode;

import java.util.ArrayList;
import java.util.List;

public class Function {
    private String name;
    private List<String> params = new ArrayList<>();
    private RuleNode statementBlock;

    public Function(final String name, final RuleNode statementBlock) {
        this.name = name;
        this.statementBlock = statementBlock;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public List<String> getParams() {
        return params;
    }

    public void setParams(List<String> params) {
        this.params = params;
    }

    public RuleNode getStatementBlock() {
        return statementBlock;
    }
}
