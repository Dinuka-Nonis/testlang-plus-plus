package com.testlangpp.model;

import java.util.List;

public class Program {
    public Config config;
    public List<Variable> variables;
    public List<TestBlock> tests;

    public Program(Config c, List<Variable> v, List<TestBlock> t) {
        this.config = c;
        this.variables = v;
        this.tests = t;
    }

    public String toString() {
        return "Program:\n" + config + "\nVariables: " + variables + "\nTests: " + tests;
    }
}