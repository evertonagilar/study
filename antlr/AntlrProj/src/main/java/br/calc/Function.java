package br.calc;

import org.antlr.v4.runtime.tree.RuleNode;

import java.util.List;

public class Function {
    private String name;
    private List<String> params;
    private RuleNode statementBlock;

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

    public void setStatementBlock(RuleNode statementBlock) {
        this.statementBlock = statementBlock;
    }
}
