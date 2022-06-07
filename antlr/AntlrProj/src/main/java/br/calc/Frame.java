package br.calc;

import org.antlr.v4.runtime.RuleContext;

import java.util.HashMap;
import java.util.Map;

public class Frame {
    private Function function;
    private Map<String, Number> localVars = new HashMap<>();
    private RuleContext ret;

    public Frame(final Function function, final RuleContext ret) {
        this.function = function;
        this.ret = ret;
    }

    public Function getFunction() {
        return function;
    }

    public Map<String, Number> getLocalVars() {
        return localVars;
    }

    public void setLocalVars(Map<String, Number> localVars) {
        this.localVars = localVars;
    }

    public RuleContext getRet() {
        return ret;
    }

}
