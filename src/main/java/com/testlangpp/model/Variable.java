package com.testlangpp.model;

public class Variable {
    public String name;
    public Object value;  // Can be String or Integer
    public String type;   // "string" or "integer"

    // String constructor
    public Variable(String name, String value) {
        this.name = name;
        this.value = value;
        this.type = "string";
    }

    // Integer constructor
    public Variable(String name, Integer value) {
        this.name = name;
        this.value = value;
        this.type = "integer";
    }

    @Override
    public String toString() {
        if (type.equals("string")) {
            return "let " + name + " = \"" + value + "\";";
        } else {
            return "let " + name + " = " + value + ";";
        }
    }
}