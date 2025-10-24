package com.testlangpp.model;

import java.util.List;

public class Program {  // ← Must be PUBLIC
    public Config config;
    public List<Variable> variables;
    public List<TestBlock> tests;

    public Program(Config config, List<Variable> variables, List<TestBlock> tests) {
        this.config = config;
        this.variables = variables;
        this.tests = tests;
    }

    @Override
    public String toString() {
        return "Program{config=" + config + ", variables=" + variables + ", tests=" + tests + "}";
    }
}