package com.testlangpp.model;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class Program {
    public Config config;
    public List<Variable> variables;
    public List<TestBlock> tests;

    private Map<String, String> varMap = new HashMap<>();

    public Program(Config c, List<Variable> v, List<TestBlock> t) {
        this.config = c;
        this.variables = v;
        this.tests = t;

        if (v != null) {
            for (Variable var : v) {
                varMap.put(var.name, String.valueOf(var.value));
            }
        }

        // Apply substitution to tests after parsing
        if (tests != null) {
            for (TestBlock test : tests) {
                substituteInTest(test);
            }
        }
    }

    // Replace $vars in test blocks
    private void substituteInTest(TestBlock test) {
        if (test.request != null) {
            test.request.path = substitute(test.request.path);

            if (test.request.body != null && test.request.body.content != null) {
                test.request.body.content = substitute(test.request.body.content);
            }
        }

        if (test.assertions != null) {
            for (Assertion a : test.assertions) {
                if (a.value != null) {
                    a.value = substitute(a.value);
                }
                if (a.key != null) {
                    a.key = substitute(a.key);
                }
            }
        }
    }

    // Simple substitution helper
    private String substitute(String input) {
        if (input == null) return null;
        String result = input;
        for (Map.Entry<String, String> e : varMap.entrySet()) {
            result = result.replace("$" + e.getKey(), e.getValue());
        }
        return result;
    }

    @Override
    public String toString() {
        return "Program:\n" + config + "\nVariables: " + variables + "\nTests: " + tests;
    }
}
